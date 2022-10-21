import 'dart:math';

import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';

class ReactiveNoteList {
  List _value = [];
  final _dbManager =
      DBManager(tableName: NoteData.tableName, fields: NoteData.fields);
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
      final noteData = NoteData(title: title, content: "");
      _value.add(noteData);
      _dbManager.insert(noteData);
    });
  }

  removeAt(index) {
    setState(() {
      _dbManager.delete(_value[index].id);
      _value.removeAt(index);
    });
  }

  List<String> toList() => _value.map<String>((item) => item.title).toList();

  String getId(int index) => _value[index].id;
}
