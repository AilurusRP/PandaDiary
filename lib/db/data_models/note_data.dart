import 'package:panda_diary/db/data_models/common_data_model.dart';
import 'package:uuid/uuid.dart';

sealed class NoteDataOrOldNoteData {}

class NoteData extends NoteDataOrOldNoteData implements CommonDataModel {
  NoteData({
    required this.id,
    required this.title,
    required this.content,
    required this.folderId,
    required this.ord,
  });

  static uuid() => const Uuid().v4();

  @override
  final String id;

  String title;
  String content;
  String folderId;
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

  @override
  NoteData.fromMap(Map<String, Object?> map)
      : id = map["id"] as String,
        title = map["title"] as String,
        content = map["content"] as String,
        folderId = map["folder_id"] as String,
        ord = map["ord"] as int;

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "ord": ord,
      "folder_id": folderId
    };
  }

  @override
  String toString() {
    return "NoteData{id: $id, title: $title, content: $content, ord: $ord}";
  }
}

class OldNoteData extends NoteDataOrOldNoteData implements CommonDataModel {
  OldNoteData(
      {required this.title,
      required this.content,
      required this.ord,
      required this.id}) {}

  static uuid() => const Uuid().v4();

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
      id: id,
      title: title,
      content: content,
      folderId: defaultFolderId,
      ord: ord,
    );
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
