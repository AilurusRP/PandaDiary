import 'dart:math';

import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_service.dart';
import 'package:panda_diary/states/folder_controller.dart';

class NoteListController extends GetxController {
  final _notesDB = Get.find<DBService>().notesDB;
  final Map<String, RxList<NoteData>> _noteLists = <String, RxList<NoteData>>{};

  NoteListController() {
    _init();
  }

  RxList<NoteData> get currentFolderNotes {
    final notes = _noteLists[Get.find<FolderController>().currentFolderId];
    if (notes == null) {
      _noteLists[Get.find<FolderController>().currentFolderId] =
          <NoteData>[].obs;
      return _noteLists[Get.find<FolderController>().currentFolderId]!;
    } else {
      return notes;
    }
  }

  List<NoteData> get allNotes {
    List<NoteData> notes = [];
    _noteLists.forEach((_, noteList) {
      notes += noteList;
    });
    return notes;
  }

  int get lastUntitledIndex {
    if (_noteLists.isEmpty) {
      return 0;
    } else {
      var untitledNotes = currentFolderNotes
          .where((elem) => elem.title.startsWith("Untitled-"));
      if (untitledNotes.isEmpty) {
        return 0;
      } else {
        return untitledNotes.map<int>((elem) {
          try {
            return int.parse(elem.title.substring(9));
          } on FormatException {
            return 0;
          }
        }).reduce(max);
      }
    }
  }

  void _init() async {
    final allNotes = await _fetchAllNotes();
    allNotes.forEach((note) {
      if (_noteLists[note.folderId] != null) {
        _noteLists[note.folderId]!.add(note);
      } else {
        _noteLists[note.folderId] = <NoteData>[note].obs;
      }
    });
    _noteLists.forEach((folderId, noteList) {
      assert(
          noteList
              .asMap()
              .entries
              .every((noteEntry) => noteEntry.value.ord == noteEntry.key),
          "note.ord does not match the note's index!");
    });
  }

  Future<List<NoteData>> _fetchAllNotes() async {
    return await _notesDB.query(NoteData.fromMap);
  }

  void updateNoteLists() {
    _noteLists.forEach((folderId, noteList) {
      noteList.clear();
    });
    _init();
  }

  add(title) {
    final noteData = NoteData(
        ord: currentFolderNotes.length,
        title: title,
        content: "",
        folderId: Get.find<FolderController>().currentFolderId,
        id: NoteData.uuid());
    currentFolderNotes.add(noteData);
    _notesDB.insert(noteData);
  }

  NoteData removeAt(String noteId) {
    late NoteData value;
    _notesDB.delete(noteId);
    value = currentFolderNotes.removeAt(getIndexFromId(noteId));
    return value;
  }

  void editNoteTitle(NoteData note, String newTitle) {
    _notesDB.update(NoteData(
        id: note.id,
        title: newTitle,
        content: note.content,
        ord: note.ord,
        folderId: Get.find<FolderController>().currentFolderId));
    currentFolderNotes[getIndexFromId(note.id)].title = newTitle;
    currentFolderNotes.refresh();
  }

  void editNoteContent(String noteId, String newContent) {
    currentFolderNotes[getIndexFromId(noteId)].content = newContent;
    currentFolderNotes.refresh();
  }

  void moveNoteToAnotherFolder(NoteData note, String newFolderId) async {
    final newFolderLength = getNotesByFolderId(newFolderId).length;
    final updatedNote = NoteData(
        id: note.id,
        title: note.title,
        content: note.content,
        folderId: newFolderId,
        ord: newFolderLength);
    await _notesDB.update(updatedNote);
    currentFolderNotes.removeAt(currentFolderNotes.indexOf(note));
    _noteLists[newFolderId]!.insert(newFolderLength, updatedNote);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final oldCurrentFolderNotes = List.from(currentFolderNotes);

    NoteData temp = currentFolderNotes
        .removeAt(currentFolderNotes.indexOf(oldCurrentFolderNotes[oldIndex]));
    currentFolderNotes.insert(newIndex, temp);

    final oldNote = oldCurrentFolderNotes[oldIndex];
    await _notesDB.update(NoteData.fromMap({
      "id": oldNote.id,
      "title": oldNote.title,
      "content": oldNote.content,
      "folder_id": oldNote.folderId,
      "ord": newIndex
    }));
    currentFolderNotes[getIndexFromId(oldNote.id)].ord = newIndex;

    if (newIndex > oldIndex) {
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        final oldNote = oldCurrentFolderNotes[i];
        await _notesDB.update(NoteData.fromMap({
          "id": oldNote.id,
          "title": oldNote.title,
          "content": oldNote.content,
          "folder_id": oldNote.folderId,
          "ord": i - 1
        }));
      }
    }

    if (newIndex < oldIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        final oldNote = oldCurrentFolderNotes[i];
        await _notesDB.update(NoteData.fromMap({
          "id": oldNote.id,
          "title": oldNote.title,
          "content": oldNote.content,
          "folder_id": oldNote.folderId,
          "ord": i + 1
        }));
      }
    }
  }

  int getIndexFromId(String noteId) {
    return currentFolderNotes.indexWhere((note) => note.id == noteId);
  }

  RxList<NoteData> getNotesByFolderId(String folderId) {
    var notes = _noteLists[folderId];
    if (notes == null) {
      if (Get.find<FolderController>()
          .folders
          .where((folder) => folder.id == folderId)
          .isNotEmpty) {
        _noteLists[folderId] = <NoteData>[].obs;
        notes = _noteLists[folderId];
      } else {
        throw Exception(
            "getNotesByFolderId failed as _noteLists[folderId] is null.");
      }
    }
    return notes!;
  }

  importNote(NoteData note) async {
    await _notesDB.insert(note);
  }
}
