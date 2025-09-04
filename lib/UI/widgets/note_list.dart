import 'package:flutter/material.dart';
import 'package:panda_diary/UI/widgets/show_delete_note_dialog.dart';
import 'package:panda_diary/db/data_binders/reactive_note_list.dart';
import 'action_menu_item.dart';

class NoteList extends StatefulWidget {
  const NoteList(
      {Key? key,
      required this.noteList,
      required this.onPress,
      required this.onDelete,
      required this.onReorder})
      : super(key: key);

  final ReactiveNoteList noteList;
  final Function onPress;
  final void Function(int) onDelete;
  final Function onReorder;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: widget.noteList.toList().asMap().entries.map<Widget>((entry) {
        print(entry.value.id);
        return NoteListItem(
            key: Key(entry.value.id),
            text: entry.value.title,
            index: entry.key,
            onPress: widget.onPress,
            onDelete: widget.onDelete);
      }).toList(),
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        setState(() {
          widget.onReorder(oldIndex, newIndex);
        });
      },
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
        // onHorizontalDragEnd: (DragEndDetails details) {
        //   showDeleteNoteDialog(context,
        //       onOk: () => widget.onDelete(widget.index));
        // },
        child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.text,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black38),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            child: ActionMenuItem(
                          text: 'Delete Note',
                          onPressed: () {
                            Navigator.pop(context);
                            showDeleteNoteDialog(context,
                                onOk: () => widget.onDelete(widget.index));
                          },
                        ))
                      ])
            ],
          ),
        ));
  }
}
