import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/UI/widgets/dialogs/show_edit_note_title_dialog.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'action_menu_item.dart';
import 'dialogs/show_delete_note_dialog.dart';
import 'dialogs/show_move_to_another_folder_dialog.dart';
import 'marquee_text.dart';

class NoteList extends StatelessWidget {
  NoteList({Key? key, required this.onPress}) : super(key: key);

  final Function onPress;

  final _folderController = Get.find<FolderController>();
  final _noteListController = Get.find<NoteListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ReorderableListView(
          onReorder: _noteListController.reorder,
          children: _noteListController.currentFolderNotes
              .where(
                  (note) => note.folderId == _folderController.currentFolderId)
              .toList()
              .map<Widget>((note) {
            return NoteListItem(
              key: Key(note.id),
              onPress: onPress,
              note: note,
            );
          }).toList(),
        ));
  }
}

class NoteListItem extends StatelessWidget {
  const NoteListItem({Key? key, required this.note, required this.onPress})
      : super(key: key);

  final NoteData note;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPress(note),
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
                    text: note.title,
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
                            showDeleteNoteDialog(context, note.id);
                          },
                        )),
                        PopupMenuItem(
                            child: ActionMenuItem(
                          text: 'Edit Title',
                          onPressed: () {
                            Navigator.pop(context);
                            showEditNoteTitleDialog(context, note);
                          },
                        )),
                        PopupMenuItem(
                            child: ActionMenuItem(
                          text: 'Move to..',
                          onPressed: () {
                            Navigator.pop(context);
                            showMoveToAnotherFolderDialog(context, note);
                          },
                        ))
                      ])
            ],
          ),
        ));
  }
}
