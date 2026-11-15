import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().activeUser;
    final mealProvider = context.watch<MealProvider>();
    final meals = mealProvider.mealsForUser(user.id);

    final completed = meals.where((m) => m.isCompleted).length;
    final progress = meals.isEmpty ? 0.0 : completed / meals.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning, ${user.name.split(" ").first}!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const Text("Here's your eating plan for today.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 14),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Color(0xFF0B68B3)),
                      SizedBox(width: 8),
                      Text('Thursday, September 25, 2026', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(height: 24),
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: const Color(0xFF0B9A57),
                        ),
                        Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Meal Plan Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$completed of ${meals.length} meals completed', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Today's Meals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...meals.map((meal) => Card(
                child: ListTile(
                  onTap: () => mealProvider.toggleMealCompletion(meal.id),
                  leading: Text(meal.iconEmoji, style: const TextStyle(fontSize: 24)),
                  title: Text(meal.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(meal.foods),
                  trailing: Icon(
                    meal.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: meal.isCompleted ? const Color(0xFF0B9A57) : Colors.grey,
                  ),
                ),
              )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F3FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.water_drop, color: Color(0xFF0B68B3)),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Today's Note: Remember to drink enough water and eat healthy! 💚"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}