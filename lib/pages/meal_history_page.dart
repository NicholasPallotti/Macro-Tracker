import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

class MealHistoryPage extends StatefulWidget {
  @override
  State<MealHistoryPage> createState() => _MealHistoryPageState();
}

class _MealHistoryPageState extends State<MealHistoryPage> {
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

          // 1. Group meals by date and compute daily calories
          final Map<String, List<Meal>> grouped = {};
          final List<String> dateKeys = [];

          for (var meal in meals) {
            final dateKey = DateFormat('MMM d').format(meal.date.toLocal());

            if (!grouped.containsKey(dateKey)) {
              grouped[dateKey] = [];
              dateKeys.add(dateKey);
            }
            grouped[dateKey]!.add(meal);
          }

          // 2. Build the list of ExpansionTiles with calorie sums
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: dateKeys.length,
            itemBuilder: (context, i) {
              final date = dateKeys[i];
              final mealsOnDate = grouped[date]!;

              // Calculate total calories for this date
              final totalCalories = mealsOnDate
                  .map((m) => m.calories)
                  .fold<int>(0, (sum, c) => sum + c);

              // Calculate total protien for this date
              final totalProtien = mealsOnDate
                  .map((m) => m.protien)
                  .fold<int>(0, (sum, c) => sum + c);

              // Calculate total fat for this date
              final totalFat = mealsOnDate
                  .map((m) => m.fat)
                  .fold<int>(0, (sum, c) => sum + c);

              // Calculate total fat for this date
              final totalCarbs = mealsOnDate
                  .map((m) => m.carbs)
                  .fold<int>(0, (sum, c) => sum + c);

              return ExpansionTile(
                title: Text(
                  '$date — Cal: $totalCalories Pro: $totalProtien Fat: $totalFat Carbs: $totalCarbs',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: mealsOnDate.map((meal) {
                  ListTile(
                      title: const Text(
                        'Daily Total',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: 'Calories: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '$totalCalories  '),
                            TextSpan(text: 'Protein: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '$totalProtien  '),
                            TextSpan(text: 'Fat: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '$totalFat  '),
                            TextSpan(text: 'Carbs: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '$totalCarbs'),
                          ],
                        ),
                      ),
                    );

                  return ListTile(
                    title: Text(meal.name),
                    subtitle: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [

                          //list calories for meal
                          TextSpan(
                            text: 'Calories: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${meal.calories}  '),

                          //list protien for meal
                          TextSpan(
                            text: 'Protein: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${meal.protien}  '),

                          //list fat for meal
                          TextSpan(
                            text: 'Fat: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${meal.fat}  '),

                          //list carbs for meal
                          TextSpan(
                            text: 'Carbs: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${meal.carbs}'),
                        ],
                      ),
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // your logic here
                        await MealDatabase.instance.deleteMeal(meal.id!);
                          setState(() {});
                      },
                     
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
