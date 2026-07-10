abstract class CommonDataModel {
  CommonDataModel();
  CommonDataModel.fromMap(Map<String, Object?> map);

  static late String tableName;
  static late Map<String, String> fields;

  abstract final String id;

  Map<String, Object?> toMap();

  @override
  String toString();
}
