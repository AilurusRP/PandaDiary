import 'package:panda_diary/db/data_models/common_data_model.dart';

class AppConfig extends CommonDataModel {
  AppConfig({required this.defaultFolderId, required this.recycleBinFolderId});

  @override
  final String id = firstId;

  late String defaultFolderId;
  late String recycleBinFolderId;

  static const String tableName = "app_config";
  static const String firstId = "setting";
  static const Map<String, String> fields = {
    "id": "TEXT  PRIMARY KEY CHECK (id = '$firstId')",
    "default_folder_id": "TEXT",
    "recycle_bin_folder_id": "TEXT"
  };

  @override
  AppConfig.fromMap(Map<String, Object?> map) {
    if (map["id"] != id) {
      throw Exception('The id of AppConfig must be "$id"!');
    }
    defaultFolderId = map["default_folder_id"] as String;
    recycleBinFolderId = map["recycle_bin_folder_id"] as String;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "default_folder_id": defaultFolderId,
      "recycle_bin_folder_id": recycleBinFolderId
    };
  }
}
