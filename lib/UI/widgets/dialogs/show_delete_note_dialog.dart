import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/note_list_controller.dart";

Future<void> showDeleteNoteDialog(context, String noteId, {onCancel}) async {
  final noteListController = Get.find<NoteListController>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure to delete this note?"),
          actions: [
            TextButton(
                onPressed: () {
                  noteListController.removeAt(noteId);
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
