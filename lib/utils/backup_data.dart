import '../db/data_models/folder_data.dart';
import '../db/data_models/note_data.dart';

sealed class BackupData {
  int get version;
  DateTime get createdAt;
  List<NoteDataOrOldNoteData> get data;

  BackupData();
}

class BackupDataV1 extends BackupData {
  BackupDataV1({required this.createdAt, required this.data});

  @override
  final int version = 1;
  @override
  DateTime createdAt;
  @override
  List<OldNoteData> data;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "data": data.map((note) => note.toMap()).toList()
    };
  }

  factory BackupDataV1.fromJson(Map<String, dynamic> json) {
    return BackupDataV1(createdAt: json["createdAt"], data: json["data"]);
  }
}

class BackupDataV2 extends BackupData {
  BackupDataV2(
      {required this.createdAt, required this.folders, required this.data});

  @override
  final int version = 2;
  @override
  DateTime createdAt;
  List<FolderData> folders;
  @override
  List<NoteData> data;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "folders": folders.map((folder) => folder.toMap()).toList(),
      "data": data.map((note) => note.toMap()).toList()
    };
  }

  factory BackupDataV2.fromJson(Map<String, dynamic> json) {
    return BackupDataV2(
        createdAt: json["createdAt"],
        folders: json["folders"],
        data: json["data"]);
  }
}
