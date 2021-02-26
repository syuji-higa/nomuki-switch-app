import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DrinkTime {
  static String table = 'drink_time';
  static int version = 1;

  final int id;
  final DateTime createdAt;

  DrinkTime({ this.id, this.createdAt });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
  
  @override
  String toString() {
    return 'DrinkTime{id: $id, createdAt: $createdAt}';
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'drink_time_database.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE drink_time(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TEXT NOT NULL
          )
        ''');
      },
      version: version,
    );
    return _database;
  }

  static Future<List<DrinkTime>> getDrinkTimes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('drink_time');
    return List.generate(maps.length, (i) {
      return DrinkTime(
        id: maps[i]['id'],
        createdAt: DateTime.parse(maps[i]['created_at']).toLocal(),
      );
    });
  }

  static Future<DrinkTime> insertDrinkTime(DrinkTime drinkTime) async {
    DateTime now = DateTime.now();
    final Map<String, dynamic> row = {
      'created_at': now.toString(),
    };

    final Database db = await database;
    final int id = await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return DrinkTime(
      id: id,
      createdAt: now,
    );
  }

  static Future<void> deleteDrinkTime(int id) async {
    final db = await database;
    await db.delete(
      'drink_time',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
