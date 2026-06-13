import 'package:panda_diary/db/data_models/note_data.dart';

class NoteBackupV1 {
  NoteBackupV1({required this.createdAt, required this.data});

  static const int version = 1;
  DateTime createdAt;
  List<NoteData> data;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "data": data.map((note) => note.toMap()).toList()
    };
  }

  factory NoteBackupV1.fromJson(Map<String, dynamic> json) {
    return NoteBackupV1(createdAt: json["createdAt"], data: json["data"]);
  }
}
