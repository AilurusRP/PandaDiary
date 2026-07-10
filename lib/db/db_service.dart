import 'package:get/get.dart';
import 'package:panda_diary/db/data_models/app_config.dart';
import 'package:panda_diary/db/data_models/folder_data.dart';
import 'package:panda_diary/db/data_models/note_data.dart';
import 'package:panda_diary/db/db_manager.dart';

class DBService extends GetxService {
  late final DBManager<AppConfig> appConfigDB;
  late final DBManager<FolderData> foldersDB;
  late final DBManager<NoteData> notesDB;

  Future<DBService> init() async {
    appConfigDB =
        DBManager(tableName: AppConfig.tableName, fields: AppConfig.fields);
    foldersDB =
        DBManager(tableName: FolderData.tableName, fields: FolderData.fields);
    notesDB = DBManager(tableName: NoteData.tableName, fields: NoteData.fields);

    await appConfigDB.open();
    await foldersDB.open();
    await notesDB.open();

    return this;
  }
}
