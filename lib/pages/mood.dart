import 'package:fittracker/fittracker_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // For isSameDay

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  Future<void> _addMoodEntry(BuildContext context) async {
    String mood = '';
    String note = '';

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Mood Entry'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 12,
                    children:
                        {
                          'Very Happy': Icons.sentiment_very_satisfied,
                          'Happy': Icons.sentiment_satisfied,
                          'Neutral': Icons.sentiment_neutral,
                          'Sad': Icons.sentiment_dissatisfied,
                          'Very Sad': Icons.sentiment_very_dissatisfied,
                        }.entries.map((entry) {
                          final isSelected = mood == entry.key;
                          return ChoiceChip(
                            label: Text(entry.key),
                            avatar: Icon(
                              entry.value,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                mood = selected ? entry.key : '';
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor,
                          );
                        }).toList(),
                  ),
                  TextField(
                    onChanged: (value) => note = value.trim(),
                    decoration: InputDecoration(labelText: 'Notes (optional)'),
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
                    if (mood.isNotEmpty) {
                      Provider.of<FitTrackerState>(
                        context,
                        listen: false,
                      ).addMoodEntry(mood, note);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<FitTrackerState>(context);

    // Filter moods for selected date
    final filteredMoodEntries =
        state.moodEntries.where((entry) {
          return isSameDay(entry.timestamp, state.selectedDate);
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Mood Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _addMoodEntry(context),
                child: Text('Add Mood Entry'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Recent Mood Entries',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (filteredMoodEntries.isEmpty)
              Center(
                child: Text(
                  'No mood entries yet.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ...filteredMoodEntries.map(
                (entry) => Card(
                  child: ListTile(
                    leading: Icon(
                      {
                        'Very Happy': Icons.sentiment_very_satisfied,
                        'Happy': Icons.sentiment_satisfied,
                        'Neutral': Icons.sentiment_neutral,
                        'Sad': Icons.sentiment_dissatisfied,
                        'Very Sad': Icons.sentiment_very_dissatisfied,
                      }[entry.mood],
                      color: Colors.blue,
                    ),
                    title: Text(entry.mood),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (entry.note.isNotEmpty) Text(entry.note),
                        Text(
                          '${entry.timestamp.toLocal()}'.split('.')[0],
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
