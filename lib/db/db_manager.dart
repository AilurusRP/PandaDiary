import 'package:flutter/material.dart';
import 'package:panda_diary/db/common_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager<T extends CommonDataModel> {
  DBManager({required this.tableName, required this.fields});

  String tableName;
  Map<String, String> fields;

  late Future<Database> dataBase;

  String get _fieldsToString {
    String str = fields.entries
        .fold("", (prev, elem) => "$prev ${elem.key} ${elem.value},");
    return str.substring(0, str.length - 1);
  }

  Future<DBManager<T>> open() async {
    WidgetsFlutterBinding.ensureInitialized();
    dataBase = openDatabase(join(await getDatabasesPath(), "panda_diary.db"),
        onCreate: (db, version) =>
            db.execute("CREATE TABLE $tableName($_fieldsToString)"),
        version: 1);
    return this;
  }

  Future<void> insert(T data) async {
    final db = await dataBase;
    await db.insert(tableName, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<T>> query(Function(Map<String, Object?>) fromMap) async {
    final db = await dataBase;
    final List<Map<String, Object?>> maps =
        await db.query(tableName, orderBy: "ord");
    return List.generate(maps.length, (index) => fromMap(maps[index]));
  }

  Future<void> update(T data) async {
    final db = await dataBase;
    await db
        .update(tableName, data.toMap(), where: "id = ?", whereArgs: [data.id]);
  }

  Future<void> delete(String id) async {
    final db = await dataBase;
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
