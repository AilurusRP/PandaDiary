import "package:flutter/material.dart";

Future<void> showAddNoteDialog(context,
    {required Function onOk, onCancel}) async {
  final noteNameTextController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    const Text("Note Name: "),
                    SizedBox(
                        width: 120,
                        child: TextField(
                          controller: noteNameTextController,
                        ))
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  onOk(noteNameTextController.text);
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
