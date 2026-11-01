import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/note_list_controller.dart";

Future<void> showDeleteNoteDialog(context, String noteId, {onCancel}) async {
  final noteListController = Get.find<NoteListController>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Note",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text("Are you sure to delete this note?",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          actions: [
            TextButton(
                onPressed: () {
                  noteListController.removeAt(noteId);
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
