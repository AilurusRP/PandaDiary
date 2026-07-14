import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/UI/widgets/dialogs/show_alert_dialog.dart";
import "package:panda_diary/states/folder_controller.dart";

Future<void> showDeleteFolderDialog(context, int index, {onCancel}) async {
  final folderController = Get.find<FolderController>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Folder"),
          content: const Text("Are you sure to delete this folder?"),
          actions: [
            TextButton(
                onPressed: () {
                  try {
                    folderController.removeAt(index);
                    Navigator.of(context).pop();
                  } catch (err) {
                    Navigator.of(context).pop();
                    showAlertDialog(context, "Error", err.toString());
                  }
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
