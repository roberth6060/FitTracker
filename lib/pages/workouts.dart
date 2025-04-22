import 'package:fittracker/fittracker_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutsPage extends StatelessWidget {
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
            Consumer<FitTrackerState>(
              // Use Consumer to listen for changes.
              builder: (context, state, child) {
                if (state.workouts.isEmpty)
                  return Center(
                    child: Text(
                      'No workouts logged yet.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );

                return Column(
                  children:
                      state.workouts
                          .map(
                            (w) => Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.fitness_center,
                                  color: Colors.blue,
                                ),
                                title: Text(w.name),
                                subtitle: Text(
                                  '${w.duration} mins • ${w.timestamp.toLocal().toString().split('.')[0]}',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _addWorkout(context),
                icon: Icon(Icons.add),
                label: Text('Log Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addWorkout(BuildContext context) async {
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
                  int parsedDuration = int.tryParse(duration) ?? 0;
                  Provider.of<FitTrackerState>(
                    context,
                    listen: false,
                  ).addWorkout(name.trim(), parsedDuration);
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
}
