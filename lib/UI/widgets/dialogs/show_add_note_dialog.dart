import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/note_list_controller.dart";

Future<void> showAddNoteDialog(context, {onCancel}) async {
  final noteTitleTextController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Note",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Text("Note Title: ",
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
                  final noteListController = Get.find<NoteListController>();
                  if (noteTitleTextController.text != "") {
                    noteListController.add(noteTitleTextController.text);
                  } else {
                    noteListController.add(
                        "Untitled-${noteListController.lastUntitledIndex + 1}");
                  }

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
