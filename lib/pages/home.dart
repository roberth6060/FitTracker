import 'package:fittracker/pages/dashboard.dart';
import 'package:fittracker/pages/meals.dart';
import 'package:fittracker/pages/mood.dart';
import 'package:fittracker/pages/workouts.dart';
import 'package:fittracker/pages/map_page.dart'; // Import MapPage
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Update the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "FitTracker",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "Dashboard"),
              Tab(text: "Meals"),
              Tab(text: "Mood"),
              Tab(text: "Workouts"),
            ],
          ),
        ),
        body: TabBarView(
          children: [DashboardPage(), MealsPage(), MoodPage(), WorkoutsPage()],
        ),
      ),
    );
  }
}
