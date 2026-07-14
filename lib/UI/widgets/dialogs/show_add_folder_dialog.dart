import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../states/folder_controller.dart";

Future<void> showAddFolderDialog(context, {onCancel}) async {
  final folderTitleTextController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Folder"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    const Text("Folder Title: "),
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
