import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  void _openMealFormDialog(
    BuildContext context,
    String userId, {
    Meal? existingMeal,
  }) {
    final categoryCtrl = TextEditingController(
      text: existingMeal?.category ?? 'Breakfast',
    );
    final foodsCtrl = TextEditingController(text: existingMeal?.foods ?? '');
    final timeCtrl = TextEditingController(
      text: existingMeal?.time ?? '8:00 AM',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingMeal == null ? 'Add New Meal' : 'Edit Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: foodsCtrl,
              decoration: const InputDecoration(labelText: 'Food Items'),
            ),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<MealProvider>();
              if (existingMeal == null) {
                provider.addMeal(
                  Meal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: userId,
                    category: categoryCtrl.text,
                    foods: foodsCtrl.text,
                    time: timeCtrl.text,
                    iconEmoji: '🍽️',
                  ),
                );
              } else {
                provider.updateMeal(
                  existingMeal.id,
                  category: categoryCtrl.text,
                  foods: foodsCtrl.text,
                  time: timeCtrl.text,
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().activeUser.id;
    final mealProvider = context.watch<MealProvider>();
    final meals = mealProvider.mealsForUser(userId);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Today's Meal Plan",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => _openMealFormDialog(context, userId),
            icon: const Icon(Icons.add),
            label: const Text('Add New Meal'),
          ),
          const SizedBox(height: 12),
          ...meals.map(
            (meal) => Card(
              child: ListTile(
                leading: Text(
                  meal.iconEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  '${meal.category} • ${meal.time}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(meal.foods),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF0B68B3)),
                      onPressed: () => _openMealFormDialog(
                        context,
                        userId,
                        existingMeal: meal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => mealProvider.deleteMeal(meal.id),
                    ),
                    Checkbox(
                      value: meal.isCompleted,
                      activeColor: const Color(0xFF0B9A57),
                      onChanged: (_) =>
                          mealProvider.toggleMealCompletion(meal.id),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B9A57),
        foregroundColor: Colors.white,
        onPressed: () => _openMealFormDialog(context, userId),
        child: const Icon(Icons.add),
      ),
    );
  }
}
