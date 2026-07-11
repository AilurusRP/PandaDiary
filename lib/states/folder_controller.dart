import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/states/app_config_controller.dart';

import '../db/db_service.dart';

class FolderController extends GetxController {
  final _dbManager = Get.find<DBService>().foldersDB;
  late Rx<List<FolderData>> folders = Rx<List<FolderData>>([]);
  late Rx<String> _currentFolderId;
  final storage = GetStorage();

  init() async {
    folders.value = await fetchAll();
  }

  String get currentFolderId => _currentFolderId.value;

  initCurrentFolder() {
    var currentFolderIdInStorage = storage.read("current_folder_id");
    if (currentFolderIdInStorage != null) {
      _currentFolderId = currentFolderIdInStorage.obs;
      return;
    }

    var defaultFolderId = Get.find<AppConfigController>().defaultFolderId;
    _currentFolderId = defaultFolderId.obs;
    storage.write("current_folder_id", _currentFolderId);
  }

  setCurrentFolder(String folderId) {
    _currentFolderId.value = folderId;
    storage.write("current_folder_id", _currentFolderId);
  }

  Future<List<FolderData>> fetchAll() async {
    return _dbManager.query(FolderData.fromMap);
  }

  Future<String> createFolder(String title) async {
    var data = FolderData(title: title, ord: folders.value.length);
    await _dbManager.insert(data);
    return data.id;
  }
}
