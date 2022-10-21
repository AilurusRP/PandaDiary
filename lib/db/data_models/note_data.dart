import 'package:panda_diary/db/common_data_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid().v4;

class NoteData implements CommonDataModel {
  NoteData({required this.title, required this.content}) : id = uuid();

  @override
  NoteData.fromMap(Map<String, Object?> map)
      : id = map["id"] as String,
        title = map["title"] as String,
        content = map["content"] as String;

  static String tableName = "notes";
  static Map<String, String> fields = {
    "id": "TEXT",
    "title": "TEXT",
    "content": "TEXT"
  };

  @override
  final String id;

  String title;
  String content;

  void setContent(String newContent) {
    content = newContent;
  }

  @override
  Map<String, String> toMap() {
    return {"id": id, "title": title, "content": content};
  }

  @override
  String toString() {
    return "NoteData{id: $id, title: $title, content: $content}";
  }
}
