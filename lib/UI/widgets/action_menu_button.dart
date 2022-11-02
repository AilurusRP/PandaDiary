import "package:flutter/material.dart";
import 'package:panda_diary/UI/widgets/show_add_note_dialog.dart';

class ActionMenuButton extends StatefulWidget {
  const ActionMenuButton({Key? key, required this.onAddNoteOk})
      : super(key: key);

  final Function onAddNoteOk;

  @override
  State<ActionMenuButton> createState() => _ActionMenuButtonState();
}

class _ActionMenuButtonState extends State<ActionMenuButton> {
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
            ]);
  }
}

class ActionMenuItem extends StatefulWidget {
  const ActionMenuItem({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  State<ActionMenuItem> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.grey[200])),
        onPressed: widget.onPressed,
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(color: Colors.black),
        )));
  }
}
