import 'package:panda_diary/db/data_models/note_data.dart';

class NoteBackupV2 {
  NoteBackupV2({required this.createdAt, required this.data});

  static const int version = 2;
  DateTime createdAt;
  List<NoteData> data;

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "data": data.map((note) => note.toMap()).toList()
    };
  }

  factory NoteBackupV2.fromJson(Map<String, dynamic> json) {
    return NoteBackupV2(createdAt: json["createdAt"], data: json["data"]);
  }
}
