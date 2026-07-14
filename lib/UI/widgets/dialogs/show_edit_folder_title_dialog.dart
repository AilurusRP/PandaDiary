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
