import 'dart:math';

import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_service.dart';
import 'package:panda_diary/states/folder_controller.dart';

class NoteListController extends GetxController {
  final _notesDB = Get.find<DBService>().notesDB;
  final RxList _notes = [].obs;
  final _folderController = Get.find<FolderController>();

  NoteListController() {
    _init();
  }

  int get lastUntitledIndex {
    if (_notes.isEmpty) {
      return 0;
    } else {
      var untitledNotes =
          _notes.where((elem) => elem.title.startsWith("Untitled-"));
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
    _notes.value = await _notesDB.query(NoteData.fromMap);
  }

  void updateNoteList() {
    _init();
  }

  add(title) {
    final noteData = NoteData(
        ord: _notes.length,
        title: title,
        content: "",
        folderId: _folderController.currentFolderId);
    _notes.add(noteData);
    _notesDB.insert(noteData);
  }

  NoteData removeAt(index) {
    late NoteData value;
    _notesDB.delete(_notes[index].id);
    value = _notes.removeAt(index);
    return value;
  }

  void editElemTitle(int index, String newTitle) {
    _notesDB.update(NoteData(
        id: _notes[index].id,
        title: newTitle,
        content: _notes[index].content,
        ord: _notes[index].ord,
        folderId: _folderController.currentFolderId));
    _notes[index].title = newTitle;
    _notes.refresh();
  }

  void editElemContent(int index, String newContent) {
    _notes[index].content = newContent;
    _notes.refresh();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    var oldValue = List.from(_notes);

    NoteData temp = _notes.removeAt(oldIndex);
    _notes.insert(newIndex, temp);

    var oldNote = oldValue[oldIndex];
    await _notesDB.update(NoteData.fromMap({
      "id": oldNote.id,
      "title": oldNote.title,
      "content": oldNote.content,
      "folder_id": oldNote.folderId,
      "ord": newIndex
    }));

    if (newIndex > oldIndex) {
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        var oldNote = oldValue[i];
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
        var oldNote = oldValue[i];
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

  RxList toList() {
    return _notes;
  }

  String getId(int index) {
    return _notes[index].id;
  }

  String getTitle(int index) => _notes[index].title;
}
