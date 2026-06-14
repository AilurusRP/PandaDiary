import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';

class DBService extends GetxService {
  late final DBManager<NoteData> notesDB;

  Future<DBService> init() async {
    notesDB = DBManager(tableName: NoteData.tableName, fields: NoteData.fields);

    await Future.wait([notesDB.open()]);

    return this;
  }
}
