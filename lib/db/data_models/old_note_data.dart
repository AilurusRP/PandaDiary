import 'package:panda_diary/db/data_models/common_data_model.dart';
import 'package:uuid/uuid.dart';

import 'note_data.dart';

var uuid = const Uuid().v4;

class OldNoteData implements CommonDataModel {
  OldNoteData(
      {required this.title, required this.content, required this.ord, id}) {
    if (id == null) {
      this.id = uuid();
    } else {
      this.id = id;
    }
  }

  @override
  late final String id;

  String title;
  String content;
  int ord;

  void setContent(String newContent) {
    content = newContent;
  }

  static String tableName = "notes";
  static Map<String, String> fields = {
    "id": "TEXT",
    "title": "TEXT",
    "content": "TEXT",
    "folder_id": "TEXT",
    "ord": "INTEGER",
  };

  NoteData toNewNoteData(String defaultFolderId) {
    return NoteData(
        title: title, content: content, folderId: defaultFolderId, ord: ord);
  }

  @override
  OldNoteData.fromMap(Map<String, Object?> map)
      : id = map["id"] as String,
        title = map["title"] as String,
        content = map["content"] as String,
        ord = map["ord"] as int;

  @override
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content, "ord": ord};
  }

  @override
  String toString() {
    return "NoteData{id: $id, title: $title, content: $content, ord: $ord}";
  }
}
