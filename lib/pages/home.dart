import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
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
              Tab(text: "Workouts"),
              Tab(text: "Meals"),
              Tab(text: "Mood"),
              Tab(text: "Dashboard"),
            ],
          ),
        ),
        body: TabBarView(
          children: [WorkoutsPage(), MealsPage(), MoodPage(), DashboardPage()],
        ),
      ),
    );
  }
}

// Placeholder for Workouts page
class WorkoutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Workouts Page"));
  }
}

// Placeholder for Meals page
class MealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Meals Page"));
  }
}

// Placeholder for Mood page
class MoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Mood Tracker Page"));
  }
}

// Placeholder for Dashboard page
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Dashboard Page"));
  }
}
