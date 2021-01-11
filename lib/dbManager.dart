import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Activity.dart';

class DbActivityManager {
  Database database;

  Future openDb() async {
    if (database == null) {
      database = await openDatabase(
          join(await getDatabasesPath(), "activity_db"),
          version: 1, onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE activity (id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT)');
      });
    }
  }

  Future<int> insertActivity(Activity activity) async {
    await openDb();
    return await database.insert('activity', activity.toMap());
  }

  Future<List<Activity>> getActivityList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await database.query("activity");
    return List.generate(maps.length, (index) {
      return Activity(
        id: maps[index]['id'],
        title: maps[index]['title'],
        description: maps[index]['description'],
      );
    });
  }

  Future<int> updateActivity(Activity activity) async {
    await openDb();
    return await database.update("activity", activity.toMap(),
        where: "id =? ", whereArgs: [activity.id]);
  }

  Future<void> deleteActivity(int id) async {
    await openDb();
    await database.delete('activity', where: "id = ?", whereArgs: [id]);
  }
}
