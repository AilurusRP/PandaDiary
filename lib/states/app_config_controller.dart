import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/app_config.dart';
import 'package:panda_diary/states/folder_controller.dart';

import '../db/db_service.dart';

class AppConfigController extends GetxController {
  final _dbManager = Get.find<DBService>().appConfigDB;
  late Rx<AppConfig> _currentAppConfig;
  final _folderController = Get.find<FolderController>();

  get defaultFolderId => _currentAppConfig.value.defaultFolderId;

  get recycleBinId => _currentAppConfig.value.recycleBinFolderId;

  init() async {
    AppConfig? appConfig = (await _dbManager.query(AppConfig.fromMap))
        .firstWhereOrNull((elem) => elem.id == AppConfig.firstId);

    if (appConfig == null) {
      var folders = _folderController.folders;
      if (folders.value.isEmpty) {
        throw Exception("No folder found!");
      }

      var recycleBinFolderId =
          await _folderController.createFolder("Recycle Bin");

      await _dbManager.insert(AppConfig(
          defaultFolderId: folders.value[0].id,
          recycleBinFolderId: recycleBinFolderId));
      appConfig = (await _dbManager.query(AppConfig.fromMap))
          .firstWhere((elem) => elem.id == AppConfig.firstId);
    }

    _currentAppConfig = Rx<AppConfig>(appConfig);
  }

  setDefaultFolder(String defaultFolderId) {
    _dbManager.update(AppConfig(
        defaultFolderId: defaultFolderId,
        recycleBinFolderId: _currentAppConfig.value.recycleBinFolderId));
  }

  setRecycleBinFolderId(String recycleBinFolderId) {
    _dbManager.update(AppConfig(
        defaultFolderId: _currentAppConfig.value.defaultFolderId,
        recycleBinFolderId: recycleBinFolderId));
  }
}
