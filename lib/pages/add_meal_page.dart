import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/custom_appbar.dart';


class AddMealPage extends StatefulWidget {
  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _formController = TextEditingController();
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _protienController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();



  @override
  void dispose() {
    _formController.dispose();
    _mealController.dispose();
    _caloriesController.dispose();
    _protienController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
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
      protien: int.parse(_protienController.text),
      fat: int.parse(_fatController.text),
      carbs: int.parse(_carbsController.text),
      date: DateTime.parse(_dateController.text),
    );
    
    await MealDatabase.instance.insertMeal(meal);

    _mealController.clear();
    _caloriesController.clear();
    _protienController.clear();
    _fatController.clear();
    _carbsController.clear();
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
                  controller: _protienController,
                  decoration: InputDecoration(labelText: 'protien'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter protien';
                    }
                    return null;
                  },
              ),
              TextFormField(
                  controller: _fatController,
                  decoration: InputDecoration(labelText: 'fat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fat';
                    }
                    return null;
                  },
              ),
              TextFormField(
                  controller: _carbsController,
                  decoration: InputDecoration(labelText: 'carbs'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter carbs';
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