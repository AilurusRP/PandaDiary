import 'package:panda_diary/db/data_models/common_data_model.dart';
import 'package:panda_diary/db/data_models/note_data.dart';

import 'package:uuid/uuid.dart';

var uuid = const Uuid().v4;

class FolderData implements CommonDataModel {
  FolderData({required this.title, required this.ord, id}) {
    if (id == null) {
      this.id = uuid();
    } else {
      this.id = id;
    }
  }

  @override
  late final String id;

  String title;
  int ord;

  List<NoteData> notes = [];

  static String tableName = "folders";
  static Map<String, String> fields = {
    "id": "TEXT",
    "title": "TEXT",
    "ord": "INTEGER"
  };

  @override
  FolderData.fromMap(Map<String, Object?> map)
      : id = map["id"] as String,
        title = map["title"] as String,
        ord = map["ord"] as int;

  @override
  Map<String, Object?> toMap() {
    return {"id": id, "title": title, "ord": ord};
  }

  @override
  String toString() {
    return "FolderData{id: $id, title: $title, ord: $ord}";
  }
}
