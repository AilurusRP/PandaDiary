import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/states/note_list_controller.dart';

import '../db/db_service.dart';

class FolderController extends GetxController {
  final _folderDB = Get.find<DBService>().foldersDB;
  final RxList<FolderData> folders = RxList<FolderData>([]);
  final RxString _currentFolderId = "".obs;
  final _storage = GetStorage();

  init() async {
    folders.value = await fetchAll();
    _initCurrentFolder();
  }

  updateFolders() async {
    await init();
  }

  _initCurrentFolder() async {
    var currentFolderIdInStorage = _storage.read("current_folder_id");
    if (currentFolderIdInStorage != null) {
      setCurrentFolder(currentFolderIdInStorage);
      return;
    }

    if (folders.isNotEmpty) {
      setCurrentFolder(folders[0].id);
    } else {
      setCurrentFolder(await createFolder("Default"));
    }
  }

  String get currentFolderId => _currentFolderId.value;

  String get currentFolderTitle =>
      folders.firstWhere((folder) => folder.id == _currentFolderId.value).title;

  int get lastUntitledIndex {
    if (folders.isEmpty) {
      return 0;
    } else {
      var untitledFolders =
          folders.where((elem) => elem.title.startsWith("Untitled-"));
      if (untitledFolders.isEmpty) {
        return 0;
      } else {
        return untitledFolders.map<int>((elem) {
          try {
            return int.parse(elem.title.substring(9));
          } on FormatException {
            return 0;
          }
        }).reduce(max);
      }
    }
  }

  setCurrentFolder(String folderId) {
    _currentFolderId.value = folderId;
    _storage.write("current_folder_id", _currentFolderId.value);
  }

  Future<List<FolderData>> fetchAll() async {
    return _folderDB.query(FolderData.fromMap);
  }

  Future<String> createFolder(String title) async {
    var data =
        FolderData(title: title, ord: folders.length, id: FolderData.uuid());
    folders.add(data);
    await _folderDB.insert(data);
    return data.id;
  }

  FolderData removeAt(index) {
    if (Get.find<NoteListController>()
        .getNotesByFolderId(folders[index].id)
        .isNotEmpty) {
      throw Exception("Cannot delete folder that is not empty!");
    }

    if (folders[index].id == _currentFolderId.value) {
      setCurrentFolder(folders[0].id);
    }

    _folderDB.delete(folders[index].id);
    return folders.removeAt(index);
  }

  void editFolderTitle(int index, String newTitle) {
    _folderDB.update(FolderData(
        id: folders[index].id, title: newTitle, ord: folders[index].ord));
    folders[index].title = newTitle;
    folders.refresh();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    var oldValue = List.from(folders);

    FolderData temp = folders.removeAt(oldIndex);
    folders.insert(newIndex, temp);

    var oldFolder = oldValue[oldIndex];
    await _folderDB.update(FolderData.fromMap(
        {"id": oldFolder.id, "title": oldFolder.title, "ord": newIndex}));

    if (newIndex > oldIndex) {
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        var oldNote = oldValue[i];
        await _folderDB.update(FolderData.fromMap(
            {"id": oldNote.id, "title": oldNote.title, "ord": i - 1}));
      }
    }

    if (newIndex < oldIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        var oldNote = oldValue[i];
        await _folderDB.update(FolderData.fromMap(
            {"id": oldNote.id, "title": oldNote.title, "ord": i + 1}));
      }
    }

    folders.refresh();
  }

  importFolder(FolderData folder) async {
    await _folderDB.insert(folder);
  }
}
