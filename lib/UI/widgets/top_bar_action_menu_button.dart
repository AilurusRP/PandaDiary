import "package:flutter/material.dart";
import 'package:panda_diary/UI/widgets/show_add_note_dialog.dart';
import 'package:panda_diary/utils/file_utils.dart';

import 'action_menu_item.dart';

class TopBarActionMenuButton extends StatelessWidget {
  const TopBarActionMenuButton(
      {Key? key, required this.onAddNoteOk, required this.updateNoteList})
      : super(key: key);

  final Function onAddNoteOk;

  final void Function() updateNoteList;

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
                      showAddNoteDialog(context, onOk: onAddNoteOk);
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
                      await importNotes(onFall: (Object? err) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: Text(err.toString()));
                            });
                      }, onOk: (importedNotesCount) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Successfully Imported $importedNotesCount Notes'),
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
                      updateNoteList();
                    },
                  )),
            ]);
  }
}
