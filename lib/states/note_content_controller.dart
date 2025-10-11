import 'package:get/get.dart';

import '../db/data_models/note_data.dart';
import '../db/db_manager.dart';

class NoteContentController extends GetxController {
  final _dbManager = DBManager<NoteData>(
      tableName: NoteData.tableName, fields: NoteData.fields);
  late NoteData _noteData;

  final _historyList = [""].obs;
  final _currentIndex = 0.obs;

  final dataLoaded = false.obs;

  get currentContent => _historyList[_currentIndex.value];

  bool get undoDisabled => _currentIndex <= 0;

  bool get redoDisabled {
    return _currentIndex >= _historyList.length - 1;
  }

  init(String id) async {
    if (_historyList.length != 1 ||
        _historyList[0] != "" ||
        _currentIndex.value != 0) {
      throw "States hasn't been cleared!";
    }
    _noteData = (await (await _dbManager.open()).query(NoteData.fromMap))
        .firstWhere((elem) => elem.id == id);

    _historyList.removeLast();
    _historyList.add(_noteData.content);

    dataLoaded.value = true;
  }

  editContent(String newContent) async {
    if (_currentIndex < _historyList.length - 1) {
      _historyList.removeRange(_currentIndex.value, _historyList.length - 1);
    }
    if (_historyList.length < 5) {
      _currentIndex.value++;
    } else {
      _historyList.removeAt(0);
    }
    _historyList.add(newContent);
    _noteData.setContent(newContent);
    await _dbManager.update(_noteData);
  }

  undo() async {
    if (!undoDisabled) {
      _currentIndex.value--;
      _noteData.setContent(currentContent);
      await _dbManager.update(_noteData);
    } else {
      throw "No more history to undo!";
    }
  }

  redo() async {
    if (!redoDisabled) {
      _currentIndex.value++;
      _noteData.setContent(currentContent);
      await _dbManager.update(_noteData);
    } else {
      throw "No more history to redo!";
    }
  }

  clear() {
    _historyList.clear();
    _historyList.add("");
    _currentIndex.value = 0;
    dataLoaded.value = false;
  }
}
