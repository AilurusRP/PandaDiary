import "package:flutter/material.dart";

Future<void> showEditTitleDialog(context,
    {required Function onOk, onCancel}) async {
  final noteTitleTextController = TextEditingController();

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
                  onOk(noteTitleTextController.text);
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
