import 'package:flutter/material.dart';
import 'package:fittracker/pages/home.dart'; // Ensure to create appropriate pages for each tab
import 'package:provider/provider.dart';
import 'fittracker_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FitTrackerState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'FitTracker', home: HomePage());
  }
}
