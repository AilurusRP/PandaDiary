import 'dart:math';

import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/app_config.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_service.dart';
import 'package:panda_diary/states/app_config_controller.dart';

class ReactiveNoteList {
  List<NoteData> _value = [];
  final _notesDB = Get.find<DBService>().notesDB;
  // final _appConfigDB = Get.find<DBService>().appConfigDB;
  // final _folderDB = Get.find<DBService>().foldersDB;
  late final Function setState;
  // late String _defaultFolderId;

  ReactiveNoteList(this.setState) {
    _init();
  }

  int get lastUntitledIndex {
    if (_value.isEmpty) {
      return 0;
    } else {
      var untitledNotes =
          _value.where((elem) => elem.title.startsWith("Untitled-"));
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
    _value = await _notesDB.query(NoteData.fromMap);

    setState(() {});
  }

  void update() {
    _init();
  }

  add(title) {
    setState(() {
      final noteData = NoteData(
          ord: _value.length,
          title: title,
          content: "",
          folderId: Get.find<AppConfigController>().defaultFolderId);
      _value.add(noteData);
      _notesDB.insert(noteData);
    });
  }

  NoteData removeAt(index) {
    late NoteData value;
    setState(() {
      _notesDB.delete(_value[index].id);
      value = _value.removeAt(index);
    });
    return value;
  }

  void editElemTitle(int index, String newTitle) {
    setState(() {
      _notesDB.update(NoteData(
          id: _value[index].id,
          title: newTitle,
          content: _value[index].content,
          ord: _value[index].ord,
          folderId: Get.find<AppConfigController>().defaultFolderId));
      _value[index].title = newTitle;
    });
  }

  void editElemContent(int index, String newContent) {
    setState(() {
      _value[index].content = newContent;
    });
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    var oldValue = List.from(_value);

    NoteData temp = _value.removeAt(oldIndex);
    _value.insert(newIndex, temp);

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

  List<NoteData> toList() {
    return _value;
  }

  String getId(int index) {
    return _value[index].id;
  }

  String getTitle(int index) => _value[index].title;
}
