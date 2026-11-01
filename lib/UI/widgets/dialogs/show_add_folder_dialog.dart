import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../states/folder_controller.dart";

Future<void> showAddFolderDialog(context, {onCancel}) async {
  final folderTitleTextController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Folder",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Text("Folder Title: ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                    SizedBox(
                        width: 120,
                        child: TextField(
                          controller: folderTitleTextController,
                        ))
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final folderController = Get.find<FolderController>();
                  if (folderTitleTextController.text != "") {
                    folderController
                        .createFolder(folderTitleTextController.text);
                  } else {
                    folderController.createFolder(
                        "Untitled-${folderController.lastUntitledIndex + 1}");
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
