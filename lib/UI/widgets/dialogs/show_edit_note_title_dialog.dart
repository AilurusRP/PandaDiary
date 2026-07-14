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
          title: const Text("Edit Title"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    const Text("New Title: "),
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
                child: const Text("Ok")),
            TextButton(
                onPressed: () {
                  (onCancel != null) ? onCancel() : null;
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      });
}
