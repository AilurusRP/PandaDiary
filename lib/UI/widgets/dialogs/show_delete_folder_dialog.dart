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
          title: Text("Delete Folder",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text("Are you sure to delete this folder?",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
