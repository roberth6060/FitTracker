import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final TextEditingController _noteController = TextEditingController();
  String _selectedMood = '';
  final List<_MoodEntry> _entries = [];

  final Map<String, IconData> _moodOptions = {
    'Very Happy': Icons.sentiment_very_satisfied,
    'Happy': Icons.sentiment_satisfied,
    'Neutral': Icons.sentiment_neutral,
    'Sad': Icons.sentiment_dissatisfied,
    'Very Sad': Icons.sentiment_very_dissatisfied,
  };

  void _addEntry() {
    if (_selectedMood.isEmpty) return;
    setState(() {
      _entries.insert(
        0,
        _MoodEntry(
          mood: _selectedMood,
          note: _noteController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _noteController.clear();
      _selectedMood = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children:
                  _moodOptions.entries.map((entry) {
                    final mood = entry.key;
                    final icon = entry.value;
                    final isSelected = _selectedMood == mood;
                    return ChoiceChip(
                      label: Text(mood),
                      avatar: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedMood = mood),
                      selectedColor: Theme.of(context).primaryColor,
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _addEntry,
                child: Text('Save Entry'),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Recent Entries',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (_entries.isEmpty)
              Center(
                child: Text(
                  'No entries yet.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ..._entries.map(
                (e) => Card(
                  child: ListTile(
                    leading: Icon(_moodOptions[e.mood], color: Colors.blue),
                    title: Text(e.mood),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (e.note.isNotEmpty) Text(e.note),
                        Text(
                          '${e.timestamp.toLocal()}'.split('.')[0],
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

class _MoodEntry {
  final String mood;
  final String note;
  final DateTime timestamp;

  _MoodEntry({required this.mood, required this.note, required this.timestamp});
}
