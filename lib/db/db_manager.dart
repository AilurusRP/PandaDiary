import 'dart:async';

import 'package:panda_diary/db/data_models/common_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager<T extends CommonDataModel> {
  DBManager({required this.tableName, required this.fields});

  String tableName;
  Map<String, String> fields;

  late Future<Database> dataBase;

  // 共享的数据库单例，所有 DBManager 实例共用
  static Database? _sharedDb;
  static Completer<Database>? _openingCompleter;

  // 收集所有需要建的表的 SQL，等真正打开数据库时统一执行
  static final Map<String, String> _pendingCreateStatements = {};

  String get _fieldsToString {
    String str = fields.entries
        .fold("", (prev, elem) => "$prev ${elem.key} ${elem.value},");
    return str.substring(0, str.length - 1);
  }

  Future<DBManager<T>> open() async {
    // 先注册自己的建表语句
    _pendingCreateStatements[tableName] =
        "CREATE TABLE IF NOT EXISTS $tableName($_fieldsToString)";

    dataBase = _openSharedDb();
    return this;
  }

  static Future<Database> _openSharedDb() async {
    if (_sharedDb != null) return _sharedDb!;
    if (_openingCompleter != null) return _openingCompleter!.future;

    _openingCompleter = Completer<Database>();

    final db = await openDatabase(
      join(await getDatabasesPath(), "panda_diary.db"),
      version: 1,
      onCreate: (db, version) async {
        // 数据库首次创建时，把当前已注册的所有建表语句都执行一遍
        for (final sql in _pendingCreateStatements.values) {
          await db.execute(sql);
        }
      },
      onOpen: (db) async {
        // 数据库已存在的情况下，确保所有表都存在（处理新增表的场景）
        for (final sql in _pendingCreateStatements.values) {
          await db.execute(sql);
        }
      },
    );

    _sharedDb = db;
    _openingCompleter!.complete(db);
    return db;
  }

  Future<void> insert(T data) async {
    final db = await dataBase;
    await db.insert(tableName, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<T>> query(Function(Map<String, Object?>) fromMap) async {
    final db = await dataBase;
    final List<Map<String, Object?>> maps = tableName == "app_config"
        ? await db.query(tableName)
        : await db.query(tableName, orderBy: "ord");
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
