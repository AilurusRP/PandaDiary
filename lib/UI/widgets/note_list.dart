import 'package:flutter/material.dart';
import 'package:panda_diary/UI/widgets/show_delete_note_dialog.dart';

class NoteList extends StatefulWidget {
  const NoteList(
      {Key? key,
      required this.noteList,
      required this.onPress,
      required this.onDelete})
      : super(key: key);

  final List noteList;
  final Function onPress;
  final void Function(int) onDelete;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.noteList
          .asMap()
          .entries
          .map<Widget>((entry) => NoteListItem(
              text: entry.value,
              index: entry.key,
              onPress: widget.onPress,
              onDelete: widget.onDelete))
          .toList(),
    );
  }
}

class NoteListItem extends StatefulWidget {
  const NoteListItem(
      {Key? key,
      required this.text,
      required this.index,
      required this.onPress,
      required this.onDelete})
      : super(key: key);

  final String text;
  final int index;
  final Function onPress;
  final void Function(int) onDelete;

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onPress(widget.index),
        onLongPress: () {
          showDeleteNoteDialog(context,
              onOk: () => widget.onDelete(widget.index));
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ));
  }
}
