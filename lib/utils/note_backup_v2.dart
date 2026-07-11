import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/db/data_models/note_data.dart';

class NoteBackupV2 {
  NoteBackupV2(
      {required this.createdAt, required this.folders, required this.data});

  static const int version = 2;
  DateTime createdAt;
  List<FolderData> folders;
  List<NoteData> data;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "folders": folders.map((folder) => folder.toMap()).toList(),
      "data": data.map((note) => note.toMap()).toList()
    };
  }

  factory NoteBackupV2.fromJson(Map<String, dynamic> json) {
    return NoteBackupV2(
        createdAt: json["createdAt"],
        folders: json["folders"],
        data: json["data"]);
  }
}
