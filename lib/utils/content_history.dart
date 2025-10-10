class ContentHistory {
  final List<String> _historyList = [];
  late int _currentIndex;

  ContentHistory(String content) {
    _historyList.add(content);
    _currentIndex = 0;
  }

  get currentContent {
    return _historyList[_currentIndex];
  }

  bool get undoDisabled => _currentIndex <= 0;

  bool get redoDisabled => _currentIndex >= _historyList.length - 1;

  record(String newContent) {
    if (_currentIndex < _historyList.length - 1) {
      _historyList.removeRange(_currentIndex + 1, _historyList.length - 1);
    }
    if (_historyList.length < 5) {
      _currentIndex++;
    } else {
      _historyList.removeAt(0);
    }
    _historyList.add(newContent);
  }

  undo() {
    if (!undoDisabled) {
      _currentIndex--;
    } else {
      throw "No more history to undo!";
    }
  }

  redo() {
    if (!redoDisabled) {
      _currentIndex++;
    } else {
      throw "No more history to redo!";
    }
  }
}
