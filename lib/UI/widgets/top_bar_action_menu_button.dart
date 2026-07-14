import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:panda_diary/UI/widgets/dialogs/show_add_folder_dialog.dart';
import 'package:panda_diary/UI/widgets/dialogs/show_add_note_dialog.dart';
import 'package:panda_diary/states/folder_controller.dart';
import 'package:panda_diary/states/note_list_controller.dart';
import 'package:panda_diary/utils/file_utils.dart';

import 'action_menu_item.dart';

class TopBarActionMenuButton extends StatelessWidget {
  TopBarActionMenuButton({
    Key? key,
  }) : super(key: key);

  final _noteListController = Get.find<NoteListController>();
  final _folderController = Get.find<FolderController>();

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
                      showAddNoteDialog(context);
                    },
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "New Folder",
                    onPressed: () {
                      Navigator.pop(context);
                      showAddFolderDialog(context);
                    },
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "Export Notes",
                    onPressed: () {
                      exportNotes(onFall: (Object? err) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: Text(err.toString()));
                            });
                      }, onOk: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully Exported'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    },
                  )),
              PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  child: ActionMenuItem(
                    text: "Import Notes",
                    onPressed: () async {
                      print("进入onpress");
                      await importNotesAndFolders(onFall: (Object? err) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: Text(err.toString()));
                            });
                      }, onOk: (
                          {required int importedFoldersCount,
                          required int importedNotesCount}) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Successfully Imported $importedFoldersCount Folders and $importedNotesCount Notes'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }, onNotFound: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No Backups Found'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                      await _folderController.updateFolders();
                      _noteListController.updateNoteLists();
                    },
                  )),
            ]);
  }
}
