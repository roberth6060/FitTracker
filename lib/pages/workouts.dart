import 'package:flutter/material.dart';

class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final List<_WorkoutEntry> _workouts = [];

  void _addWorkout() {
    String name = '';
    String duration = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Workout Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Duration (mins)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => duration = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.trim().isNotEmpty && duration.trim().isNotEmpty) {
                  setState(() {
                    _workouts.add(
                      _WorkoutEntry(
                        name: name.trim(),
                        duration: int.tryParse(duration) ?? 0,
                        timestamp: DateTime.now(),
                      ),
                    );
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workouts')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Workouts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (_workouts.isEmpty)
              Center(
                child: Text(
                  'No workouts logged yet.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ..._workouts.map(
                (w) => Card(
                  child: ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.blue),
                    title: Text(w.name),
                    subtitle: Text(
                      '${w.duration} mins • ${w.timestamp.toLocal().toString().split('.')[0]}',
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addWorkout,
                icon: Icon(Icons.add),
                label: Text('Log Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutEntry {
  final String name;
  final int duration;
  final DateTime timestamp;

  _WorkoutEntry({
    required this.name,
    required this.duration,
    required this.timestamp,
  });
}
