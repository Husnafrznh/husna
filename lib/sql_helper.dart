import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE diaries(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        feeling TEXT,
        description TEXT,
        image TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'diaries.db'),
      onCreate: (db, version) async {
        await createTables(db);
      },
      version: 1,
    );
  }
  

  static Future<int> createDiary(String feeling, String description, String? image) async {
    final db = await SQLHelper.db();
    final data = {
      'feeling': feeling,
      'description': description,
      'image': image,
      'createdAt': DateTime.now().toString()
    };
    final id = await db.insert('diaries', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getDiaries() async {
    final db = await SQLHelper.db();
    return db.query('diaries', orderBy: "id");
  }

  static Future<int> updateDiary(int id, String feeling, String description, String? image) async {
    final db = await SQLHelper.db();
    final data = {
      'feeling': feeling,
      'description': description,
      'image': image,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update('diaries', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteDiary(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("diaries", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }

}


