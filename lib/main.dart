import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panda_diary/UI/home_page.dart';
import 'package:panda_diary/constants/package_name.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_content_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';

import 'db/db_service.dart';
import 'global_error_handler.dart';

void main() async {
  runAppWithErrorHandling(() async {
    await GetStorage.init();

    await Get.putAsync<DBService>(() => DBService().init());

    Get.put(NoteListController());
    Get.put(FolderController());
    Get.put(NoteContentController());
    final folderController = Get.find<FolderController>();
    await folderController.init();

    runApp(const MyApp());
  });
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
