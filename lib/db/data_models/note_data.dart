import 'package:panda_diary/db/common_data_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid().v4;

class NoteData implements CommonDataModel {
  NoteData(
      {required this.title, required this.content, required this.ord, id}) {
    if (id == null) {
      this.id = uuid();
    } else {
      this.id = id;
    }
  }

  @override
  NoteData.fromMap(Map<String, Object?> map)
      : id = map["id"] as String,
        title = map["title"] as String,
        content = map["content"] as String,
        ord = map["ord"] as int;

  static String tableName = "notes";
  static Map<String, String> fields = {
    "id": "TEXT",
    "title": "TEXT",
    "content": "TEXT",
    "ord": "INTEGER",
  };

  @override
  late final String id;

  String title;
  String content;
  int ord;

  void setContent(String newContent) {
    content = newContent;
  }

  @override
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content, "ord": ord};
  }

  @override
  String toString() {
    return "NoteData{id: $id, title: $title, content: $content, ord: $ord}";
  }
}
