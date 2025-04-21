import 'package:flutter/material.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  double _waterIntake = 0.0;
  final List<String> _meals = [];

  void _addMealManually() {
    showDialog(
      context: context,
      builder: (context) {
        String meal = '';
        return AlertDialog(
          title: Text('Add Meal'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Meal Description'),
            onChanged: (value) => meal = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (meal.trim().isNotEmpty) {
                  setState(() {
                    _meals.add(meal.trim());
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

  void _addMealViaCamera() {
    // TODO: Integrate camera plugin for photo-based meal entry
    // Placeholder implementation:
    setState(() {
      _meals.add('Meal added via camera (placeholder)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meals')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Meals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (_meals.isEmpty)
              Center(
                child: Text(
                  'No meals logged yet.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ..._meals.map((meal) => Card(child: ListTile(title: Text(meal)))),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addMealManually,
                  icon: Icon(Icons.edit),
                  label: Text('Add Manually'),
                ),
                ElevatedButton.icon(
                  onPressed: _addMealViaCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Use Camera'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Water Intake (ml)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: 3000,
              divisions: 30,
              value: _waterIntake,
              label: '${_waterIntake.toInt()} ml',
              onChanged:
                  (value) => setState(() {
                    _waterIntake = value;
                  }),
            ),
            Center(
              child: Text(
                '${_waterIntake.toInt()} ml',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
