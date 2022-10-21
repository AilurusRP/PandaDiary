import "package:flutter/material.dart";

Future<void> showDeleteNoteDialog(context,
    {required Function onOk, onCancel}) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("add note"),
          content: const Text("Are you sure to delete this note?"),
          actions: [
            TextButton(
                onPressed: () {
                  onOk();
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
