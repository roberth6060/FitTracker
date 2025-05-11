import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';

class FitTrackerState with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  final List<MealEntry> _meals = [];
  double _waterIntake = 0.0;
  final List<MoodEntry> _moodEntries = [];
  final List<WorkoutEntry> _workouts = [];

  List<MealEntry> getMealsForSelectedDate() {
    return _meals.where((meal) {
      return isSameDay(meal.date, _selectedDate);
    }).toList();
  }

  List<MealEntry> get meals => _meals;
  double get waterIntake => _waterIntake;
  List<MoodEntry> get moodEntries => _moodEntries;
  List<WorkoutEntry> get workouts => _workouts;

  // New method to add meal with description and calories
  void addMeal({
    required String name,
    required double calories,
    required String protein,
    required String fat,
    required String carbs,
    File? image,
  }) {
    _meals.add(
      MealEntry(
        name: name,
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
        image: image,
        date: _selectedDate,
      ),
    );
    notifyListeners();
  }

  void updateMealImage(MealEntry meal, File image) {
    final index = _meals.indexOf(meal);
    if (index != -1) {
      _meals[index] = MealEntry(
        name: meal.name,
        calories: meal.calories,
        protein: meal.protein,
        fat: meal.fat,
        carbs: meal.carbs,
        image: image,
        date: _selectedDate,
      );
      notifyListeners();
    }
  }

  void updateWaterIntake(double value) {
    _waterIntake = value;
    notifyListeners();
  }

  void addMoodEntry(String mood, String note) {
    if (mood.isNotEmpty) {
      _moodEntries.insert(
        0,
        MoodEntry(mood: mood, note: note, timestamp: _selectedDate),
      );
      notifyListeners();
    }
  }

  void addWorkout(String name, int duration) {
    if (name.isNotEmpty && duration > 0) {
      _workouts.insert(
        0,
        WorkoutEntry(name: name, duration: duration, timestamp: _selectedDate),
      );
      notifyListeners();
    }
  }

  double get totalCaloriesToday {
    return _meals.fold(0.0, (sum, meal) => sum + meal.calories);
  }
}

class MealEntry {
  final String name;
  final double calories;
  final String protein;
  final String fat;
  final String carbs;
  final File? image;
  final DateTime date;

  MealEntry({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.image,
    required this.date,
  });

  DateTime get timestamp => date;
}

class MoodEntry {
  final String mood;
  final String note;
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.note, required this.timestamp});
}

class WorkoutEntry {
  final String name;
  final int duration; // Duration in minutes
  final DateTime timestamp;

  WorkoutEntry({
    required this.name,
    required this.duration,
    required this.timestamp,
  });
}
