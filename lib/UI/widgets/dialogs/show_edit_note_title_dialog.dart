import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/note_list_controller.dart";

import "../../../db/data_models/note_data.dart";

Future<void> showEditNoteTitleDialog(context, NoteData note, {onCancel}) async {
  final noteTitleTextController = TextEditingController();
  final noteListController = Get.find<NoteListController>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Title",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Text("New Title: ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                    SizedBox(
                        width: 120,
                        child: TextField(
                          controller: noteTitleTextController,
                        ))
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  noteListController.editNoteTitle(
                      note, noteTitleTextController.text);
                  Navigator.of(context).pop();
                },
                child: Text("Ok",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface))),
            TextButton(
                onPressed: () {
                  (onCancel != null) ? onCancel() : null;
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface)))
          ],
        );
      });
}
