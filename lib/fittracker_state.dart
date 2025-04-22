import 'package:flutter/foundation.dart';

class FitTrackerState with ChangeNotifier {
  final List<String> _meals = [];
  double _waterIntake = 0.0;
  final List<_MoodEntry> _moodEntries = [];
  final List<_WorkoutEntry> _workouts = [];

  List<String> get meals => _meals;
  double get waterIntake => _waterIntake;
  List<_MoodEntry> get moodEntries => _moodEntries;
  List<_WorkoutEntry> get workouts => _workouts;

  void addMeal(String meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void updateWaterIntake(double value) {
    _waterIntake = value;
    notifyListeners();
  }

  void addMoodEntry(String mood, String note) {
    if (mood.isNotEmpty) {
      _moodEntries.insert(
        0,
        _MoodEntry(mood: mood, note: note, timestamp: DateTime.now()),
      );
      notifyListeners();
    }
  }

  void addWorkout(String name, int duration) {
    if (name.isNotEmpty && duration > 0) {
      _workouts.insert(
        0,
        _WorkoutEntry(
          name: name,
          duration: duration,
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }
}

class _MoodEntry {
  final String mood;
  final String note;
  final DateTime timestamp;

  _MoodEntry({required this.mood, required this.note, required this.timestamp});
}

class _WorkoutEntry {
  final String name;
  final int duration; // Duration in minutes
  final DateTime timestamp;

  _WorkoutEntry({
    required this.name,
    required this.duration,
    required this.timestamp,
  });
}
