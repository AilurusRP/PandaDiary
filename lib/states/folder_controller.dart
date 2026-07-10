import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';

import '../db/db_service.dart';

class FolderController extends GetxController {
  final _dbManager = Get.find<DBService>().foldersDB;
  late Rx<List<FolderData>> folders = Rx<List<FolderData>>([]);
  String? currentFolderId;

  init() async {
    folders.value = await fetchAll();
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
