import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'header.dart';

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
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '飲む気スイッチ',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.black87,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: Header(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberOfTimesContainer(),
              SizedBox(height: 40),
              NomukiButtonContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberOfTimesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NumberOfTimes(),
        SizedBox(height: 4),
        NumberOfTimesDescText('飲んでいます'),
      ],
    );
  }
}

class NumberOfTimesDescText extends StatelessWidget {
  final String text;
  NumberOfTimesDescText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Theme.of(context).accentColor,
      )
    );
  }
}

class NumberOfTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        NumberOfTimesUnit('1週間以内に'),
        NumberOfTimesValue('0'),
        NumberOfTimesUnit('回'),
      ]
    );
  }
}

class NumberOfTimesValue extends StatelessWidget {
  final String value;
  NumberOfTimesValue(this.value);
  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 60,
        color: Theme.of(context).accentColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 60.0,
      ),
    );
  }
}

class NumberOfTimesUnit extends StatelessWidget {
  final String unit;
  NumberOfTimesUnit(this.unit);
  Widget build(BuildContext context) {
    return Text(
      unit,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Theme.of(context).accentColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 72.0,
      ),
    );
  }
}

class NomukiButtonContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NomukiButton(),
        SizedBox(height: 16),
        Icon(
          Icons.arrow_upward_rounded,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 4),
        NomukiButtonDesc()
      ],
    );
  }
}

class NomukiButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.amber,
        shape: CircleBorder(),
      ),
      child: SizedBox(
        height: 100.0,
        width: 100.0,
        child: IconButton(
          icon: Icon(
            Icons.sports_bar_outlined,
            size: 40.0
          ),
          color: Colors.white,
          onPressed: _addDrinkTime,
        ),
      ),
    );
  }
}

class NomukiButtonDesc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '飲む前にタップ',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

void _addDrinkTime() async {
  DrinkTime _drinkTime = DrinkTime();
  await DrinkTime.insertDrinkTime(_drinkTime);
}
