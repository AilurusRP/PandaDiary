import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';

import '../db/db_service.dart';

class FolderController extends GetxController {
  final _folderDB = Get.find<DBService>().foldersDB;
  final Rx<List<FolderData>> folders = Rx<List<FolderData>>([]);
  final Rx<String> _currentFolderId = "".obs;
  final storage = GetStorage();

  init() async {
    folders.value = await fetchAll();
    initCurrentFolder();
  }

  initCurrentFolder() async {
    var currentFolderIdInStorage = storage.read("current_folder_id");
    if (currentFolderIdInStorage != null) {
      setCurrentFolder(currentFolderIdInStorage);
      return;
    }

    if (folders.value.isNotEmpty) {
      setCurrentFolder(folders.value[0].id);
    } else {
      setCurrentFolder(await createFolder("Default"));
    }
  }

  String get currentFolderId => _currentFolderId.value;

  setCurrentFolder(String folderId) {
    _currentFolderId.value = folderId;
    storage.write("current_folder_id", _currentFolderId.value);
  }

  Future<List<FolderData>> fetchAll() async {
    return _folderDB.query(FolderData.fromMap);
  }

  Future<String> createFolder(String title) async {
    var data = FolderData(title: title, ord: folders.value.length);
    await _folderDB.insert(data);
    return data.id;
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    var oldValue = List.from(folders.value);

    FolderData temp = folders.value.removeAt(oldIndex);
    folders.value.insert(newIndex, temp);

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
}
