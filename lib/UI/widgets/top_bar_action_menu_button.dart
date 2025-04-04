import "package:flutter/material.dart";
import 'package:panda_diary/UI/widgets/show_add_note_dialog.dart';
import 'package:panda_diary/utils/file_utils.dart';

import 'action_menu_item.dart';

class TopBarActionMenuButton extends StatefulWidget {
  const TopBarActionMenuButton({Key? key, required this.onAddNoteOk})
      : super(key: key);

  final Function onAddNoteOk;

  @override
  State<TopBarActionMenuButton> createState() => _TopBarActionMenuButtonState();
}

class _TopBarActionMenuButtonState extends State<TopBarActionMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.add),
        itemBuilder: (context) => [
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "New Note",
                    onPressed: () {
                      Navigator.pop(context);
                      showAddNoteDialog(context, onOk: widget.onAddNoteOk);
                    },
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "New Folder",
                    onPressed: () {},
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "Export Notes",
                    onPressed: (){
                      exportNotes();
                    },
                  )),
            ]);
  }
}
