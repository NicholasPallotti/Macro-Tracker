import 'package:flutter/material.dart';
import '../pages/meal_history_page.dart';
import '../pages/add_meal_page.dart';

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