import 'package:flutter/material.dart';
import 'package:fittracker/pages/map_page.dart'; // Import MapPage
import 'package:provider/provider.dart';
import 'package:fittracker/fittracker_state.dart'; // Your state class
import 'package:table_calendar/table_calendar.dart'; // For isSameDay

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fitTrackerState = Provider.of<FitTrackerState>(context);
    final selectedDate = fitTrackerState.selectedDate;

    // Filter workouts for selected date
    final workoutsToday =
        fitTrackerState.workouts.where((workout) {
          return isSameDay(workout.timestamp, selectedDate);
        }).toList();

    // Filter meals for selected date
    final mealsToday =
        fitTrackerState.meals.where((meal) {
          return isSameDay(meal.timestamp, selectedDate);
        }).toList();

    // Filter mood entries for selected date
    final moodsToday =
        fitTrackerState.moodEntries.where((entry) {
          return isSameDay(entry.timestamp, selectedDate);
        }).toList();

    // Calculate total workouts for selected date
    int workoutsCount = workoutsToday.length;

    // Calculate total calories for selected date
    double caloriesLogged = mealsToday.fold(
      0,
      (total, meal) => total + meal.calories,
    );

    // Calculate total protein, fat, carbs for selected date
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbohydrates = 0;

    for (var meal in mealsToday) {
      totalProtein +=
          double.tryParse(meal.protein.replaceAll('g', '').trim()) ?? 0;
      totalFat += double.tryParse(meal.fat.replaceAll('g', '').trim()) ?? 0;
      totalCarbohydrates +=
          double.tryParse(meal.carbs.replaceAll('g', '').trim()) ?? 0;
    }

    // Get today's mood (for selected date)
    String moodToday =
        moodsToday.isNotEmpty ? moodsToday.first.mood : "No mood logged";

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome to FitTracker Dashboard!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Track your fitness and wellbeing progress here.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                child: Text("View Nearby Fitness Facilities"),
              ),
              SizedBox(height: 20),
              // Quick Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue),
                        title: Text("Selected Date"),
                        subtitle: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          Icons.fitness_center,
                          color: Colors.green,
                        ),
                        title: Text("Workouts"),
                        subtitle: Text("$workoutsCount sessions"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.restaurant, color: Colors.orange),
                        title: Text("Calories Logged"),
                        subtitle: Text(
                          "${caloriesLogged.toStringAsFixed(0)} kcal",
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.restaurant, color: Colors.purple),
                        title: Text("Total Protein"),
                        subtitle: Text("${totalProtein.toStringAsFixed(1)} g"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.fastfood, color: Colors.brown),
                        title: Text("Total Fat"),
                        subtitle: Text("${totalFat.toStringAsFixed(1)} g"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.local_cafe, color: Colors.orange),
                        title: Text("Total Carbohydrates"),
                        subtitle: Text(
                          "${totalCarbohydrates.toStringAsFixed(1)} g",
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.mood, color: Colors.purple),
                        title: Text("Mood"),
                        subtitle: Text(moodToday),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "You are currently logged in.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
