import 'package:flutter/material.dart';
import 'package:panda_diary/db/common_data_model.dart';

import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';
import 'package:panda_diary/utils/content_history.dart';

class NoteContentText {
  late NoteData _noteData;
  final _dbManager = DBManager<NoteData>(
      tableName: NoteData.tableName, fields: NoteData.fields);
  late final ContentHistory _contentHistory;
  late final Function setState;

  final String id;
  final TextEditingController controller;
  ScrollController scrollController;

  Function? init;

  String get _value => _contentHistory.currentContent;

  bool get undoDisabled => _contentHistory.undoDisabled;

  bool get redoDisabled => _contentHistory.redoDisabled;

  NoteContentText._create(this.setState,
      {required this.controller,
      required this.scrollController,
      required this.id,
      required NoteData noteData}) {
    _noteData = noteData;
    _contentHistory = ContentHistory(_noteData.content);
    setState(() {
      controller.text = _value;
    });
    _setInit();
  }

  static Future<NoteContentText> create(Function setState,
      {required TextEditingController controller,
      required ScrollController scrollController,
      required String id}) async {
    DBManager<NoteData> dbManager = DBManager<NoteData>(
        tableName: NoteData.tableName, fields: NoteData.fields);
    NoteData noteData = (await (await dbManager.open()).query(NoteData.fromMap))
        .firstWhere((elem) => elem.id == id);

    return NoteContentText._create(setState,
        controller: controller,
        scrollController: scrollController,
        id: id,
        noteData: noteData);
  }

  Future<void> save(String newContent) async {
    _contentHistory.record(newContent);
    _noteData.setContent(newContent);
    await _dbManager.update(_noteData);
  }

  undo() async {
    _contentHistory.undo();
    controller.text = _contentHistory.currentContent;
    _noteData.setContent(_contentHistory.currentContent);
    await _dbManager.update(_noteData);
  }

  redo() async {
    _contentHistory.redo();
    controller.text = _contentHistory.currentContent;
    _noteData.setContent(_contentHistory.currentContent);
    await _dbManager.update(_noteData);
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
