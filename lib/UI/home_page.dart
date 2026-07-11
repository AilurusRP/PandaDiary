import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/UI/pages/note_content_edit_page/note_content_edit_page.dart';
import 'package:panda_diary/UI/widgets/top_bar_action_menu_button.dart';
import 'package:panda_diary/UI/widgets/note_list.dart';
import 'package:panda_diary/UI/widgets/side_drawer.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'package:panda_diary/utils/file_utils.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  final NoteListController _noteList = Get.find<NoteListController>();

  @override
  void initState() {
    super.initState();
    createExportDirAndImportDir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          TopBarActionMenuButton(
              onAddNoteOk: (String noteName) {
                if (noteName != "") {
                  _noteList.add(noteName);
                } else {
                  _noteList.add("Untitled-${_noteList.lastUntitledIndex + 1}");
                }
              },
              updateNoteList: _noteList.updateNoteList)
        ],
      ),
      drawer: const SideDrawer(),
      body: Center(
          child: NoteList(
              onPress: (index) => NoteContentEditPage.navigatorPush(context,
                      id: _noteList.getId(index),
                      title: _noteList.getTitle(index),
                      onContentChange: (String newContent) {
                    _noteList.editElemContent(index, newContent);
                  }))),
    );
  }
}
