import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  void _showReminderDialog(BuildContext context, String userId, {Meal? meal}) {
    final titleCtrl = TextEditingController(
      text: meal?.category ?? 'Hydration / Snack',
    );
    final timeCtrl = TextEditingController(text: meal?.time ?? '9:00 AM');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(meal == null ? 'Add Reminder' : 'Edit Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Meal Label'),
            ),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: 'Reminder Time'),
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
              if (meal == null) {
                provider.addMeal(
                  Meal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: userId,
                    category: titleCtrl.text,
                    foods: 'Scheduled reminder',
                    time: timeCtrl.text,
                    iconEmoji: '⏰',
                    isReminderOn: true,
                  ),
                );
              } else {
                provider.updateMeal(
                  meal.id,
                  category: titleCtrl.text,
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Meal Reminders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Get notified for your planned meals.',
          style: TextStyle(color: Colors.grey),
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
                meal.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(meal.time),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        _showReminderDialog(context, userId, meal: meal),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => mealProvider.deleteMeal(meal.id),
                  ),
                  Switch(
                    value: meal.isReminderOn,
                    activeColor: const Color(0xFF0B9A57),
                    onChanged: (_) => mealProvider.toggleReminder(meal.id),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B9A57),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => _showReminderDialog(context, userId),
          icon: const Icon(Icons.add),
          label: const Text('Add Reminder'),
        ),
      ],
    );
  }
}
