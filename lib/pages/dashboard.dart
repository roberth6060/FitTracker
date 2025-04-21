import 'package:flutter/material.dart';
import 'package:fittracker/pages/map_page.dart'; // Import MapPage

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

              // 👇 Suggested: Quick Stats Section
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
                        subtitle: Text("4 sessions"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.restaurant, color: Colors.orange),
                        title: Text("Calories Logged Today"),
                        subtitle: Text("1,850 kcal"),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.mood, color: Colors.blue),
                        title: Text("Mood Today"),
                        subtitle: Text("😊 Feeling Good"),
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
