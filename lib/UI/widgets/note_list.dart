import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/UI/widgets/show_delete_note_dialog.dart';
import 'package:panda_diary/UI/widgets/show_edit_title_dialog.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'action_menu_item.dart';
import 'marquee_text.dart';

class NoteList extends StatelessWidget {
  NoteList({Key? key, required this.onPress}) : super(key: key);

  final Function onPress;

  final _folders = Get.find<FolderController>();
  final _noteList = Get.find<NoteListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ReorderableListView(
          children: _noteList
              .toList()
              .where((note) => note.folderId == _folders.currentFolderId)
              .toList()
              .asMap()
              .entries
              .map<Widget>((entry) {
            return NoteListItem(
                key: Key(entry.value.id),
                text: entry.value.title,
                index: entry.key,
                onPress: onPress);
          }).toList(),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            _noteList.reorder(oldIndex, newIndex);
          },
        ));
  }
}

class NoteListItem extends StatelessWidget {
  NoteListItem(
      {Key? key,
      required this.text,
      required this.index,
      required this.onPress})
      : super(key: key);

  final String text;
  final int index;
  final Function onPress;

  final _noteList = Get.find<NoteListController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPress(index),
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
                  child: MarqueeText(
                    text: text,
                    fontSize: 18,
                    blankSpace: 15,
                    maxWidth: 280,
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
                                onOk: () => _noteList.removeAt(index));
                          },
                        )),
                        PopupMenuItem(
                            child: ActionMenuItem(
                          text: 'Edit Title',
                          onPressed: () {
                            Navigator.pop(context);
                            showEditTitleDialog(context,
                                onOk: (String newTitle) {
                              _noteList.editElemTitle(index, newTitle);
                            });
                          },
                        ))
                      ])
            ],
          ),
        ));
  }
}
