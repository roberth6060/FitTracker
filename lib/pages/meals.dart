import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fittracker/fittracker_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<Map<String, String>?> _showMealDetailsDialog(
    BuildContext context, {
    required String name,
    required String calories,
    required String protein,
    required String fat,
    required String carbs,
  }) async {
    final nameController = TextEditingController(text: name);
    final caloriesController = TextEditingController(text: calories);
    final proteinController = TextEditingController(text: protein);
    final fatController = TextEditingController(text: fat);
    final carbsController = TextEditingController(text: carbs);

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Meal Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Food Name'),
                ),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: proteinController,
                  decoration: InputDecoration(labelText: 'Protein (g)'),
                ),
                TextField(
                  controller: fatController,
                  decoration: InputDecoration(labelText: 'Fat (g)'),
                ),
                TextField(
                  controller: carbsController,
                  decoration: InputDecoration(labelText: 'Carbohydrates (g)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newData = {
                  'name': nameController.text.trim(),
                  'calories': caloriesController.text.trim(),
                  'protein': proteinController.text.trim(),
                  'fat': fatController.text.trim(),
                  'carbs': carbsController.text.trim(),
                };
                Navigator.pop(context, newData);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    return result; // It'll be null if canceled
  }

  Future<void> _addMealManually(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController fatController = TextEditingController();
    final TextEditingController carbsController = TextEditingController();

    File? imageFile; // Hold the image selected in dialog

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('Add Meal Details'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Camera icon button within dialog to pick image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera_alt, size: 40),
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.camera,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile.path);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (imageFile != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.file(imageFile!, height: 150),
                          ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Food Name'),
                        ),
                        TextField(
                          controller: caloriesController,
                          decoration: InputDecoration(labelText: 'Calories'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: proteinController,
                          decoration: InputDecoration(labelText: 'Protein (g)'),
                        ),
                        TextField(
                          controller: fatController,
                          decoration: InputDecoration(labelText: 'Fat (g)'),
                        ),
                        TextField(
                          controller: carbsController,
                          decoration: InputDecoration(
                            labelText: 'Carbohydrates (g)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final cal =
                            double.tryParse(caloriesController.text.trim()) ??
                            0;
                        final protein = proteinController.text.trim();
                        final fat = fatController.text.trim();
                        final carbs = carbsController.text.trim();

                        if (name.isNotEmpty) {
                          Provider.of<FitTrackerState>(
                            context,
                            listen: false,
                          ).addMeal(
                            name: name,
                            calories: cal,
                            protein: protein,
                            fat: fat,
                            carbs: carbs,
                            image: imageFile,
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Helper method to input the full meal details

  Future<void> _addMealFromSearch(BuildContext context) async {
    final TextEditingController queryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Meal'),
          content: TextField(
            controller: queryController,
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
                final query = queryController.text.trim();
                if (query.isEmpty) return;

                final product = await _searchMeal(query);

                log(product.toString());

                if (product != null) {
                  final name = product['product_name'] ?? 'Unnamed';
                  final nutriments = product['nutriments'] ?? {};
                  final caloriesStr =
                      nutriments['energy-kcal']?.toString() ?? '0';
                  final calories = double.tryParse(caloriesStr) ?? 0;
                  final protein = nutriments['proteins']?.toString() ?? 'N/A';
                  final fat = nutriments['fat']?.toString() ?? 'N/A';
                  final carbs =
                      nutriments['carbohydrates']?.toString() ?? 'N/A';
                  String imageUrl = product['image_url'] ?? '';

                  log(name + " protein " + protein);

                  // Show dialog for editing details
                  final mealData = await _showMealDetailsDialog(
                    context,
                    name: name,
                    calories: calories.toString(),
                    protein: protein,
                    fat: fat,
                    carbs: carbs,
                  );

                  if (mealData != null) {
                    // Add meal to state
                    Provider.of<FitTrackerState>(
                      context,
                      listen: false,
                    ).addMeal(
                      name: mealData['name'] ?? 'Unnamed',
                      calories:
                          double.tryParse(mealData['calories'] ?? '0') ?? 0,
                      protein: mealData['protein'] ?? 'N/A',
                      fat: mealData['fat'] ?? 'N/A',
                      carbs: mealData['carbs'] ?? 'N/A',
                    );

                    // Close the dialog
                    Navigator.of(context).pop();
                  }
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

  Future<Map<String, dynamic>?> _searchMeal(String query) async {
    final url = Uri.parse(
      'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'];
      if (products != null && products.isNotEmpty) {
        return products[0];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<FitTrackerState>(context);
    final filteredMeals = state.getMealsForSelectedDate();

    return Scaffold(
      appBar: AppBar(title: Text('Meals')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addMealManually(context),
                  icon: Icon(Icons.edit),
                  label: Text('Add Manually'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addMealFromSearch(context),
                  icon: Icon(Icons.search),
                  label: Text('Search Food'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Your Meals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (filteredMeals.isEmpty)
              Center(
                child: Text(
                  'No meals logged yet.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              ...filteredMeals.map(
                (meal) => Card(
                  child: ListTile(
                    leading:
                        meal.image != null
                            ? Image.file(
                              meal.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            : Icon(Icons.restaurant_menu, size: 50),
                    title: Text(meal.name),
                    subtitle: Text(
                      'Calories: ${meal.calories}\nProtein: ${meal.protein}\nFat: ${meal.fat}\nCarbs: ${meal.carbs}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.photo),
                      tooltip: 'Add / Change Image',
                      onPressed: () async {
                        final newImageFile = await _pickImage();
                        if (newImageFile != null) {
                          Provider.of<FitTrackerState>(
                            context,
                            listen: false,
                          ).updateMealImage(meal, newImageFile);
                        }
                      },
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
