import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_diary/states/folder_controller.dart';

import 'marquee_text.dart';

class FolderList extends StatelessWidget {
  FolderList({super.key});

  final _folderController = Get.find<FolderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            _folderController.reorder(oldIndex, newIndex);
          },
          children: _folderController.folders.value
              .asMap()
              .entries
              .map((entry) => FolderListItem(
                    key: Key(entry.value.id),
                    id: entry.value.id,
                    title: entry.value.title,
                    index: entry.key,
                  ))
              .toList(),
        ));
  }
}

class FolderListItem extends StatelessWidget {
  FolderListItem(
      {super.key, required this.id, required this.title, required this.index});

  final String id;
  final String title;
  final int index;

  final _folderController = Get.find<FolderController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _folderController
            .setCurrentFolder(_folderController.folders.value[index].id),
        child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MarqueeText(
                    text: title,
                    fontSize: 18,
                    blankSpace: 15,
                    maxWidth: 280,
                  ),
                ),
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black38),
                  itemBuilder: (context) => [])
            ],
          ),
        ));
  }
}
