import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';


class Meal {
  final int? id;
  final String name;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final DateTime date;

  Meal({this.id, required this.name, required this.calories, required this.protein, required this.fat, required this.carbs, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'date': date.toIso8601String(), // Store as ISO 8601 string
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      fat: map['fat'],
      carbs: map['carbs'],
      date: DateTime.parse(map['date']),
    );
  }
}

class MealDatabase {
  static final MealDatabase instance = MealDatabase._init();
  static Database? _database;

  MealDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    
    return _database!;
  }

 Future<Database> _initDB(String fileName) async {
  String path;

  if (kIsWeb) {
    // IndexedDB store name
    path = fileName;
  } else {
    // On mobile & desktop we want the app’s documents directory
    final Directory docsDir = await getApplicationDocumentsDirectory();
    path = join(docsDir.path, fileName);
  }

  // for debugging, run on mobile/desktop to see the real path
  print('🗄️ Opening DB at: $path');

  return databaseFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: _createDB,
    ),
  );
}

Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        protein INTEGER NOT NULL,
        fat INTEGER NOT NULL,
        carbs INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await instance.database;
    await db.insert('meals', meal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

    /// Deletes a meal by its primary key id.
  Future<int> deleteMeal(int id) async {
    final db = await instance.database;
    return await db.delete(
      'meals',                  // your table name
      where: 'id = ?',          // the column to match
      whereArgs: [id],          // value for the placeholder
    );
  }

  /// Updates an existing meal in the database.
  /// Expects that `meal.id` is non-null and matches an existing row.
  Future<int> updateMeal(Meal meal) async {
    final db = await instance.database;
    return await db.update(
      'meals',                  // your table name
      meal.toMap(),             // map of column/value pairs
      where: 'id = ?',          // only update the row with this id
      whereArgs: [meal.id],     // pass the id here
    );
  }

  Future<List<Meal>> fetchMeals() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT * 
        FROM meals
        ORDER BY datetime(date) DESC
    ''');

    print(result);
    return result.map((map) => Meal.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} 
