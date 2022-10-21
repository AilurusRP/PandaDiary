import 'package:flutter/material.dart';

import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';

class NoteContentText {
  late NoteData _noteData;
  final _dbManager = DBManager<NoteData>(
      tableName: NoteData.tableName, fields: NoteData.fields);
  late final Function setState;

  final String id;
  final TextEditingController controller;
  ScrollController scrollController;

  Function? init;

  String get _value => _noteData.content;

  NoteContentText(this.setState,
      {required this.controller,
      required this.scrollController,
      required this.id}) {
    _init();
  }

  void _init() async {
    _noteData = (await (await _dbManager.open()).query(NoteData.fromMap))
        .firstWhere((elem) => elem.id == id);
    setState(() {
      controller.text = _value;
    });
    _setInit();
  }

  void save(String newContent) {
    _noteData.setContent(newContent);
    _dbManager.update(_noteData);
  }

  _setInit() {
    init = () {
      setState(() {
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      init = null;
    };
  }

  void setNewScrollController(ScrollController newScrollController) {
    scrollController = newScrollController;
  }

  @override
  String toString() => _value;
}
