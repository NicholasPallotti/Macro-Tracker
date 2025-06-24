import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    // Use web implementation on the web.
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Use ffi on Linux and Windows.
    if (Platform.isLinux || Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();
    }
  }

  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(title: 'Macro Tracker'),
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
    );
  }
}

class MealHistoryPage extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Meal History'),
      body: FutureBuilder<List<Meal>>(
        future: MealDatabase.instance.fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No meals recorded.'));
          }

          final meals = snapshot.data!;
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return ListTile(
                title: Text(meal.name),
                subtitle: Text(
                  'Calories: ${meal.calories} • Date: ${meal.date.toLocal().toString().split(' ')[0]}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddMealPage extends StatefulWidget {
  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _formController = TextEditingController();
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();



  @override
  void dispose() {
    _formController.dispose();
    _mealController.dispose();
    _caloriesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    setState(() {
      _dateController.text = picked.toIso8601String().split('T').first;
    });
  }
}

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final meal = Meal(
      name: _mealController.text,
      calories: int.parse(_caloriesController.text),
      date: DateTime.parse(_dateController.text),
    );
    
    await MealDatabase.instance.insertMeal(meal);

    _mealController.clear();
    _caloriesController.clear();
    _dateController.clear();
  }
}


  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(title: 'Add Meal'),

       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Key to reference the form for validation
          child: Column(
            children: [
              TextFormField(
                  controller: _mealController,
                  decoration: InputDecoration(labelText: 'Meal'),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal name';
                  }
                  return null;
                  },
              ),
              TextFormField(
                  controller: _caloriesController,
                  decoration: InputDecoration(labelText: 'calories'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter calories';
                    }
                    return null;
                  },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
          ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
          ),

            ]
            
          ),
        ),
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final Color backgroundColor;


  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.blue,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
       backgroundColor: Colors.teal,
          
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMealPage()),
                );
              },
            ),

            IconButton(
              icon: Icon(Icons.calendar_month),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealHistoryPage()),
                );
              },
            ),
            
          ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class Meal {
  final int? id;
  final String name;
  final int calories;
  final DateTime date;

  Meal({this.id, required this.name, required this.calories, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'date': date.toIso8601String(), // Store as ISO 8601 string
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
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

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
  version: 1,
  onCreate: _createDB,
));
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await instance.database;
    await db.insert('meals', meal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Meal>> fetchMeals() async {
    final db = await instance.database;
    final result = await db.query('meals');
    return result.map((map) => Meal.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
