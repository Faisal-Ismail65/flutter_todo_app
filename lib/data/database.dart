import 'package:flutter_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelder {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}todo.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute('CREATE TABLE "tasks"('
              'id INTEGER,  title	TEXT,'
              'note	TEXT,'
              'date	TEXT,'
              'startTime	TEXT,'
              'endTime	TEXT,'
              'remind	INTEGER,'
              'repeat	TEXT,'
              'color	INTEGER,'
              'isCompleted	INTEGER,'
              'PRIMARY KEY("id" AUTOINCREMENT)'
              ')');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insertTask(Task task) async {
    return await _db?.insert(_tableName, task.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    return await _db!.query(_tableName);
  }

  static Future<int> deleteTask(int taskId) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [taskId]);
  }

  static Future<int> updateTask(int taskId) async {
    return await _db!.rawUpdate('''
    UPDATE tasks SET isCompleted = ? WHERE id = ? ''', [1, taskId]);
  }
}
