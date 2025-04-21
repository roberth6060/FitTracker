import 'package:flutter/material.dart';
import 'package:fittracker/pages/home.dart'; // Ensure to create appropriate pages for each tab

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'FitTracker', home: HomePage());
  }
}
