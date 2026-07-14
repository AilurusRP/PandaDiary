import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:panda_diary/states/folder_controller.dart";
import "package:panda_diary/states/note_list_controller.dart";

import "../../../db/data_models/note_data.dart";

Future<void> showMoveToAnotherFolderDialog(context, NoteData note,
    {onCancel}) async {
  final noteListController = Get.find<NoteListController>();

  String selectedFolderId = Get.find<FolderController>().folders[0].id;

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Move to Another Folder"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: Get.find<FolderController>()
                    .folders
                    .where((folder) => folder.id != note.folderId)
                    .map((folder) => RadioListTile<String>(
                          title: Text(folder.title),
                          value: folder.id,
                          groupValue: selectedFolderId,
                          onChanged: (newSelectedFolderId) {
                            if (newSelectedFolderId != null) {
                              selectedFolderId = newSelectedFolderId;
                              setState(() {});
                            }
                          },
                        ))
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    noteListController.moveNoteToAnotherFolder(
                        note, selectedFolderId);
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
      });
}
