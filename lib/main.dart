import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panda_diary/UI/home_page.dart';
import 'package:panda_diary/constants/package_name.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_content_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'package:panda_diary/utils/file_utils.dart';

import 'db/db_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await GetStorage.init();

    await Get.putAsync<DBService>(() => DBService().init());

    Get.put(NoteListController());
    Get.put(FolderController());
    Get.put(NoteContentController());
    final folderController = Get.find<FolderController>();
    await folderController.init();

    createExportDirAndImportDir();

    runApp(const MyApp());

  } catch (e, s) {
    if (kDebugMode) {
      print("Exception found: $e\n$s");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      title: appName,
      home: DiaryHomePage(),
    );
  }
}
