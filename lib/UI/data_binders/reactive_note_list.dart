import 'dart:math';

import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';

class ReactiveNoteList {
  List<NoteData> _value = [];
  final _dbManager = DBManager<NoteData>(
      tableName: NoteData.tableName, fields: NoteData.fields);
  late final Function setState;

  ReactiveNoteList(this.setState) {
    _init();
  }

  int get lastUntitledIndex {
    if (_value.isEmpty) return 0;
    return _value
        .where((elem) => elem.title.startsWith("Untitled-"))
        .map<int>((elem) {
      try {
        return int.parse(elem.title.substring(9));
      } on FormatException {
        return 0;
      }
    }).reduce(max);
  }

  void _init() async {
    _value = await (await _dbManager.open()).query(NoteData.fromMap);
    setState(() {});
  }

  add(title) {
    setState(() {
      final noteData = NoteData(ord: _value.length, title: title, content: "");
      _value.add(noteData);
      _dbManager.insert(noteData);
    });
  }

  NoteData removeAt(index) {
    late NoteData value;
    setState(() {
      _dbManager.delete(_value[index].id);
      value = _value.removeAt(index);
    });
    return value;
  }

  void changeElemContent(int index, String newContent) {
    setState(() {
      _value[index].content = newContent;
    });
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    var oldValue = List.from(_value);

    NoteData temp = _value.removeAt(oldIndex);
    _value.insert(newIndex, temp);

    var oldNote = oldValue[oldIndex];
    await _dbManager.update(NoteData.fromMap({
      "id": oldNote.id,
      "title": oldNote.title,
      "content": oldNote.content,
      "ord": newIndex
    }));

    if (newIndex > oldIndex) {
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        var oldNote = oldValue[i];
        await _dbManager.update(NoteData.fromMap({
          "id": oldNote.id,
          "title": oldNote.title,
          "content": oldNote.content,
          "ord": i - 1
        }));
        print(i);
      }
    }

    if (newIndex < oldIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        var oldNote = oldValue[i];
        await _dbManager.update(NoteData.fromMap({
          "id": oldNote.id,
          "title": oldNote.title,
          "content": oldNote.content,
          "ord": i + 1
        }));
        print(i);
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
