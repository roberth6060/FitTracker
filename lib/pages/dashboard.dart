import 'package:flutter/material.dart';
import 'package:fittracker/pages/map_page.dart'; // Import MapPage
import 'package:provider/provider.dart';
import 'package:fittracker/fittracker_state.dart'; // Ensure this import points to your FitTrackerState file.

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fitTrackerState = Provider.of<FitTrackerState>(
      context,
    ); // Access the provider

    // Calculating today's logged workouts, calories, and mood
    int workoutsThisWeek =
        fitTrackerState
            .workouts
            .length; // Assuming all workouts are logged this week
    double caloriesLoggedToday = fitTrackerState.meals.fold(0, (total, meal) {
      // This assumes you have a way to extract calorie info from meals.
      // Replace `0` with actual extraction logic if available.
      return total +
          0; // Change this with the caloric value of each meal if available
    });

    String moodToday =
        fitTrackerState.moodEntries.isNotEmpty
            ? fitTrackerState
                .moodEntries
                .first
                .mood // Get the latest mood entry
            : "No mood logged";

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
                        leading: Icon(
                          Icons.fitness_center,
                          color: Colors.green,
                        ),
                        title: Text("Workouts This Week"),
                        subtitle: Text("$workoutsThisWeek sessions"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.restaurant, color: Colors.orange),
                        title: Text("Calories Logged Today"),
                        subtitle: Text(
                          "${caloriesLoggedToday.toStringAsFixed(0)} kcal",
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.mood, color: Colors.blue),
                        title: Text("Mood Today"),
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
