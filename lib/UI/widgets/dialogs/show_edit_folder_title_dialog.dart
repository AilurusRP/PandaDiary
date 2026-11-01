import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/folder_controller.dart";

Future<void> showEditFolderTitleDialog(context, int index, {onCancel}) async {
  final folderTitleController = TextEditingController();
  final folderController = Get.find<FolderController>();

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
                          controller: folderTitleController,
                        ))
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  folderController.editFolderTitle(
                      index, folderTitleController.text);
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
