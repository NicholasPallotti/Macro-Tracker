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
              //Meal Name - Full Width
              TextFormField(
                controller: _mealController,
                decoration: InputDecoration(labelText: 'Meal', border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a meal name' : null,
              ),
              SizedBox(height: 16),
              //Row: Calories & Protien
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration: InputDecoration(labelText: 'Calories', border: OutlineInputBorder(),),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Enter calories' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _protienController,
                      decoration: InputDecoration(labelText: 'Protien', border: OutlineInputBorder(),),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Enter protien' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              //Row: Fat & Carbs
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      decoration: InputDecoration(labelText: 'Fat', border: OutlineInputBorder(),),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Enter fat' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: InputDecoration(labelText: 'Carbs', border: OutlineInputBorder(),),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Enter carbs' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // 📅 Date - Full Width
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
              ),

              // 🚀 Submit Button
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