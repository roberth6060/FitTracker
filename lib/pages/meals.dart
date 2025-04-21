import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _addMealViaCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera permission is required.')));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _meals.add('📸 Photo meal: ${pickedFile.path.split('/').last}');
      });
    }
  }

  Future<Map<String, dynamic>?> searchMeal(String query) async {
    final url = Uri.parse(
      'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1',
    );

    final response = await http.get(url);
    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'];

      if (products != null && products.isNotEmpty) {
        return products[0];
      }
    }
    return null;
  }

  void _addMealFromSearch() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Meal'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter meal or product name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final query = controller.text.trim(); // ✅ get actual input
                Navigator.pop(context);

                if (query.isEmpty) return;

                final product = await searchMeal(query);
                print(product);
                if (product != null) {
                  final name = product['product_name'] ?? 'Unnamed';
                  final nutriments = product['nutriments'] ?? {};
                  final calories =
                      nutriments['energy-kcal']?.toString() ?? 'N/A';
                  final protein = nutriments['proteins']?.toString() ?? 'N/A';
                  final fat = nutriments['fat']?.toString() ?? 'N/A';
                  final carbs =
                      nutriments['carbohydrates']?.toString() ?? 'N/A';

                  setState(() {
                    _meals.add(
                      '$name\nCalories: $calories kcal\nProtein: $protein g\nFat: $fat g\nCarbs: $carbs g',
                    );
                    print('Meal Added: $name');
                  });
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('No results found.')));
                }
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: _addMealManually,
                  icon: Icon(Icons.edit),
                  label: Text('Add Manually'),
                ),
                ElevatedButton.icon(
                  onPressed: _addMealFromSearch,
                  icon: Icon(Icons.search),
                  label: Text('Search Food'),
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
              onChanged: (value) {
                setState(() {
                  _waterIntake = value;
                });
              },
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
