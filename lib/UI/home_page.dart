import 'package:flutter/material.dart';
import 'package:panda_diary/UI/data_binders/reactive_note_list.dart';
import 'package:panda_diary/UI/pages/note_content_edit_page/note_content_edit_page.dart';
import 'package:panda_diary/UI/widgets/top_bar_action_menu_button.dart';
import 'package:panda_diary/UI/widgets/note_list.dart';
import 'package:panda_diary/UI/widgets/side_drawer.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  late final ReactiveNoteList _noteList;

  @override
  void initState() {
    _noteList = ReactiveNoteList(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          TopBarActionMenuButton(onAddNoteOk: (String noteName) {
            if (noteName != "") {
              _noteList.add(noteName);
            } else {
              _noteList.add("Untitled-${_noteList.lastUntitledIndex + 1}");
            }
          })
        ],
      ),
      drawer: const SideDrawer(),
      body: Center(
          child: NoteList(
        noteList: _noteList,
        onPress: (index) => NoteContentEditPage.navigatorPush(context,
            id: _noteList.getId(index), title: _noteList.getTitle(index),
            onContentChange: (String newContent) {
          _noteList.changeElemContent(index, newContent);
        }),
        onDelete: _noteList.removeAt,
        onReorder: (int oldIndex, int newIndex) async {
          await _noteList.reorder(oldIndex, newIndex);
          setState(() {});
        },
      )),
    );
  }
}
