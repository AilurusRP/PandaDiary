import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/UI/pages/note_content_edit_page/note_content_edit_page.dart';
import 'package:panda_diary/UI/widgets/top_bar_action_menu_button.dart';
import 'package:panda_diary/UI/widgets/note_list.dart';
import 'package:panda_diary/UI/widgets/side_drawer.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';

import '../db/data_models/note_data.dart';

class DiaryHomePage extends StatelessWidget {
  DiaryHomePage({Key? key}) : super(key: key);

  final _noteListController = Get.find<NoteListController>();
  final _folderController = Get.find<FolderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Obx(() => Text(_folderController.currentFolderTitle)),
        actions: [TopBarActionMenuButton()],
      ),
      drawer: const SideDrawer(),
      body: Center(
          child: NoteList(
              onPress: (NoteData note) => NoteContentEditPage.navigatorPush(context,
                      id: note.id,
                      title: note.title,
                      onContentChange: (String newContent) {
                    _noteListController.editNoteContent(note.id, newContent);
                  }))),
    );
  }
}
