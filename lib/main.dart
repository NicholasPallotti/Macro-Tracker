import 'package:flutter/material.dart';

void main() {
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


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(title: 'test'),
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

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All validations passed, you can process your data.
      debugPrint('Form submitted with: ${_formController.text}');
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
                  decoration: InputDecoration(labelText: 'Meal'),

              ),
              TextFormField(
                  decoration: InputDecoration(labelText: 'calories'),
              ),
          ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
          ),

            ]
            
          ),
        ),
      ),
      /*
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Key to reference the form for validation
          child: Column(
            children: [
              //text form for meal name
              TextFormField(
                controller: _formController,
                decoration: const InputDecoration(
                  hintText: 'Meals Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null; // Returns null if the input is valid.
                },
              ),
              //text form for calorie amount
              TextFormField(
                controller: _formController,
                decoration: const InputDecoration(
                  hintText: 'calories',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text2';
                  }
                  return null; // Returns null if the input is valid.
                },
              ),
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),*/
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
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
            ),
            
          ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}


/*
class _FormInputScreenState extends State<FormInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _formController = TextEditingController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All validations passed, you can process your data.
      debugPrint('Form submitted with: ${_formController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Key to reference the form for validation
          child: Column(
            children: [
              TextFormField(
                controller: _formController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null; // Returns null if the input is valid.
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/