import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/constants/package_name.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/db/db_service.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'package:panda_diary/utils/backup_data.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../db/data_models/note_data.dart';

void exportNotes(
    {required Function(Object?) onFall, required Function() onOk}) async {
  Permission.manageExternalStorage.request();
  List<NoteData> data = await _getAllNotesData();

  final folderController = Get.find<FolderController>();

  String content = jsonEncode(BackupDataV2(
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

Future<void> importNotesAndFolders(
    {required Function(Object?) onFall,
    required Function(
            {required int importedFoldersCount,
            required int importedNotesCount})
        onOk,
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
  String backupDataString =
      await (noteFiles.toList()[0] as File).readAsString();
  Map<String, dynamic> backupDataMap = jsonDecode(backupDataString);

  BackupData backupData;
  try {
    if (backupDataMap["version"] == 1) {
      backupData = BackupDataV1.fromJson({
        "version": backupDataMap["version"],
        "createdAt":
            DateTime.fromMillisecondsSinceEpoch(backupDataMap['createdAt']),
        "data": (backupDataMap["data"] as List)
            .map<OldNoteData>(
                (note) => OldNoteData.fromMap(note as Map<String, dynamic>))
            .toList()
      });
    } else if (backupDataMap["version"] == 2) {
      backupData = BackupDataV2.fromJson({
        "version": backupDataMap["version"],
        "createdAt":
            DateTime.fromMillisecondsSinceEpoch(backupDataMap['createdAt']),
        "folders": (backupDataMap["folders"] as List)
            .map((folder) => FolderData.fromMap(folder as Map<String, dynamic>))
            .toList(),
        "data": (backupDataMap["data"] as List)
            .map((note) => NoteData.fromMap(note as Map<String, dynamic>))
            .toList()
      });
    } else {
      return onFall("Format Error!");
    }
  } catch (err, stack) {
    return onFall(err.toString() + stack.toString());
  }

  int importedFoldersCount = 0;
  if (backupData.version == 2) {
    importedFoldersCount = await _importFolders(
        backupData: backupData as BackupDataV2, onFall: onFall);
  }
  int importedNotesCount =
      await _importNotes(backupData: backupData, onFall: onFall);

  onOk(
      importedFoldersCount: importedFoldersCount,
      importedNotesCount: importedNotesCount);
}

Future<int> _importFolders(
    {required BackupDataV2 backupData,
    required Function(Object?) onFall}) async {
  final folderController = Get.find<FolderController>();

  List<FolderData> folderDataList = backupData.folders;

  int importedFolderCount = 0;
  final existedFolderCount = folderController.folders.length;
  await Future.forEach(folderDataList, (folder) async {
    try {
      bool imported = await _importFolder(
          folderDataBackup: folder,
          ord: existedFolderCount + importedFolderCount,
          existFolders: folderController.folders);
      if (imported) importedFolderCount++;
    } catch (err, stack) {
      onFall(err.toString() + stack.toString());
    }
  });
  return importedFolderCount;
}

Future<int> _importNotes(
    {required BackupData backupData, required Function(Object?) onFall}) async {
  final noteListController = Get.find<NoteListController>();
  List<NoteData> notesInDatabase = noteListController.allNotes;

  List<NoteDataOrOldNoteData> noteDataList;
  if (backupData.version == 1) {
    var currentFolderId = Get.find<FolderController>().currentFolderId;
    noteDataList = (backupData as BackupDataV1)
        .data
        .map<NoteData>(
            (oldNoteData) => oldNoteData.toNewNoteData(currentFolderId))
        .toList();
  } else if (backupData.version == 2) {
    noteDataList = (backupData as BackupDataV2).data;
  } else {
    return onFall("Format Error!");
  }

  int importedNotesCount = 0;
  Map<String, int> lengthsOfFolders = getLengthsOfFolders();
  for (int i = 0; i < noteDataList.length; i++) {
    try {
      bool imported = await _importNote(
          noteDataList[i] as NoteData,
          (lengthsOfFolders[(noteDataList[i] as NoteData).folderId] ?? 0) +
              importedNotesCount,
          notesInDatabase);
      if (imported) importedNotesCount++;
    } catch (err, stack) {
      onFall(err.toString() + stack.toString());
    }
  }
  return (importedNotesCount);
}

Future<bool> _importFolder(
    {required FolderData folderDataBackup,
    required int ord,
    required List<FolderData> existFolders}) async {
  List<FolderData> duplicatedFolders =
      existFolders.where((folder) => folder.id == folderDataBackup.id).toList();
  if (duplicatedFolders.length > 1) {
    throw Exception(
        "There have been more than 1 duplicated folders in the database!");
  }

  if (duplicatedFolders.isNotEmpty) {
    return false;
  }

  final folderData = FolderData(
      title: folderDataBackup.title, ord: ord, id: folderDataBackup.id);

  await Get.find<FolderController>().importFolder(folderData);

  return true;
}

Future<bool> _importNote(
    NoteData noteDataBackup, int ord, List<NoteData> notesInDatabase) async {
  String id = noteDataBackup.id;
  String title = noteDataBackup.title;
  String content = noteDataBackup.content;
  String folderId = noteDataBackup.folderId;

  List<NoteData> duplicatedNotes =
      notesInDatabase.where((noteData) => noteData.id == id).toList();
  if (duplicatedNotes.length > 1) {
    throw Exception(
        "There have been more than 1 duplicated notes in the database!");
  }

  if (duplicatedNotes.isNotEmpty) {
    if (duplicatedNotes[0].content == content) return false;
    if (notesInDatabase.any((noteData) =>
        noteData.title == "$title(1)" && noteData.content == content)) {
      return false;
    }
    id = NoteData.uuid();
    if (duplicatedNotes[0].title == title) title = "$title(1)";
  }

  final noteData = NoteData(
      id: id, title: title, content: content, ord: ord, folderId: folderId);

  await Get.find<NoteListController>().importNote(noteData);

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
