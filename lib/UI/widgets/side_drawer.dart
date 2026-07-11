import 'package:flutter/material.dart';
import 'package:panda_diary/UI/widgets/folder_list.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        children: [
          const Text(
            "Folders",
            style: TextStyle(fontSize: 22),
          ),
          Expanded(child: FolderList())
        ],
      ),
    ));
  }
}
