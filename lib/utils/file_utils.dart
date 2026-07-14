import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/constants/package_name.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/db/data_models/old_note_data.dart';
import 'package:panda_diary/db/db_service.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'package:panda_diary/utils/note_backup_v1.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../db/data_models/note_data.dart';
import '../db/db_manager.dart';
import 'note_backup_v2.dart';

void exportNotes(
    {required Function(Object?) onFall, required Function() onOk}) async {
  Permission.manageExternalStorage.request();
  List<NoteData> data = await _getAllNotesData();

  final folderController = Get.find<FolderController>();

  String content = jsonEncode(NoteBackupV2(
      createdAt: DateTime.now(),
      folders: folderController.folders,
      data: data));

  _writeTextToPublicDocument(
          fileName: '$packageName.backup.json', content: content)
      .then((_) {
    onOk();
  }).onError((err, stackTrace) {
    onFall(err);
    debugPrint(stackTrace.toString());
  });
}

Future<void> importNotes(
    {required Function(Object?) onFall,
    required Function(int) onOk,
    required Function() onNotFound}) async {
  Permission.manageExternalStorage.request();
  final Directory dir = Directory("/storage/emulated/0/$packageName");
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final Directory importDir = Directory("${dir.path}/import");
  var childFilesAndDirs = importDir.listSync();

  var noteFiles = childFilesAndDirs.where(
      (fse) => fse is File && basename(fse.path) == "$packageName.backup.json");
  if (noteFiles.isEmpty) {
    onNotFound();
    return;
  }
  String noteBackupContent =
      await (noteFiles.toList()[0] as File).readAsString();

  final dbManager = Get.find<DBService>().notesDB;
  List<NoteData> notesInDatabase = await dbManager.query(NoteData.fromMap);

  List<NoteData> noteDataList;
  try {
    Map<String, dynamic> jsonData = jsonDecode(noteBackupContent);

    if (jsonData["version"] == 1) {
      var currentFolderId = Get.find<FolderController>().currentFolderId;

      noteDataList = NoteBackupV1.fromJson({
        "version": jsonData["version"],
        "createdAt": DateTime.fromMillisecondsSinceEpoch(jsonData['createdAt']),
        "data": (jsonData["data"] as List)
            .map<OldNoteData>(
                (data) => OldNoteData.fromMap(data as Map<String, dynamic>))
            .toList()
      })
          .data
          .map<NoteData>(
              (oldNoteData) => oldNoteData.toNewNoteData(currentFolderId))
          .toList();
    } else if (jsonData["version"] == 2) {
      noteDataList = NoteBackupV2.fromJson({
        "version": jsonData["version"],
        "createdAt": DateTime.fromMillisecondsSinceEpoch(jsonData['createdAt']),
        "folders": (jsonData["folders"] as List)
            .map((folder) => FolderData.fromMap(folder as Map<String, dynamic>))
            .toList(),
        "data": (jsonData["data"] as List)
            .map((data) => NoteData.fromMap(data as Map<String, dynamic>))
            .toList()
      }).data;
    } else {
      return onFall("Format Error!");
    }
  } catch (err, stack) {
    return onFall(err.toString() + stack.toString());
  }

  int importedNotesCount = 0;
  Map<String, int> lengthsOfFolders = getLengthsOfFolders();
  for (int i = 0; i < noteDataList.length; i++) {
    try {
      var imported = await _importNote(
          noteDataList[i],
          (lengthsOfFolders[noteDataList[i].folderId] ?? 0) + i,
          dbManager,
          notesInDatabase);
      if (imported) importedNotesCount++;
    } catch (err) {
      onFall(err);
    }
  }
  onOk(importedNotesCount);
}

Future<bool> _importNote(NoteData noteDataBackup, int ord,
    DBManager<NoteData> dbManager, List<NoteData> notesInDatabase) async {
  String id = noteDataBackup.id;
  String title = noteDataBackup.title;
  String content = noteDataBackup.content;
  String folderId = noteDataBackup.folderId;

  List<NoteData> duplicatedNotes =
      notesInDatabase.where((noteData) => noteData.id == id).toList();
  assert(duplicatedNotes.length <= 1);

  if (duplicatedNotes.isNotEmpty) {
    if (duplicatedNotes[0].content == content) return false;
    if (notesInDatabase.any((noteData) =>
        noteData.title == "$title(1)" && noteData.content == content)) {
      return false;
    }
    id = const Uuid().v4();
    if (duplicatedNotes[0].title == title) title = "$title(1)";
  }

  final noteData = NoteData(
      id: id, title: title, content: content, ord: ord, folderId: folderId);

  dbManager.insert(noteData);

  return true;
}

void createExportDirAndImportDir() async {
  Permission.manageExternalStorage.request();
  final Directory dir = Directory("/storage/emulated/0/$packageName");
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final Directory exportDir = Directory("${dir.path}/export");
  final Directory importDir = Directory("${dir.path}/import");
  exportDir.create();
  importDir.create();
}

Future<List<NoteData>> _getAllNotesData() async {
  List<NoteData> value = [];
  final dbManager = Get.find<DBService>().notesDB;
  value = await (await dbManager.open()).query(NoteData.fromMap);
  return value;
}

// Functions below are generated by Proton Lumo AI
Future<void> _writeTextToPublicDocument({
  required String fileName,
  required String content,
}) async {
  final Directory dir = Directory("/storage/emulated/0/$packageName");

  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  final Directory exportDir = Directory("${dir.path}/export");

  final File file = File('${exportDir.path}/$fileName');

  await file.writeAsString(content, flush: true);
}

Map<String, int> getLengthsOfFolders() {
  final folderController = Get.find<FolderController>();
  final noteListController = Get.find<NoteListController>();
  Map<String, int> lengthsOfFolders = {};
  folderController.folders.forEach((folder) {
    lengthsOfFolders[folder.id] =
        noteListController.getNotesByFolderId(folder.id).length;
  });
  return lengthsOfFolders;
}
