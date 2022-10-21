import 'package:flutter/material.dart';
import 'package:panda_diary/UI/data_binders/reactive_note_list.dart';
import 'package:panda_diary/UI/pages/note_content_edit_page/note_content_edit_page.dart';
import 'package:panda_diary/UI/widgets/action_menu_button.dart';
import 'package:panda_diary/UI/widgets/note_list.dart';
import 'package:panda_diary/UI/widgets/side_drawer.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  late final ReactiveNoteList _noteListText;

  @override
  void initState() {
    _noteListText = ReactiveNoteList(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ActionMenuButton(onAddNoteOk: (String noteName) {
            if (noteName != "") {
              _noteListText.add(noteName);
            } else {
              _noteListText
                  .add("Untitled-${_noteListText.lastUntitledIndex + 1}");
            }
          })
        ],
      ),
      drawer: const SideDrawer(),
      body: Center(
          child: NoteList(
        noteList: _noteListText.toList(),
        onPress: (index) => NoteContentEditPage.navigatorPush(context,
            id: _noteListText.getId(index)),
        onDelete: _noteListText.removeAt,
      )),
    );
  }
}
