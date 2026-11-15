import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/note_log.dart';

class MealProvider extends ChangeNotifier {
  final List<Meal> _meals = [
    Meal(id: 'm1', userId: 'u1', category: 'Breakfast', foods: 'Egg + Rice + Banana', time: '7:00 AM', iconEmoji: '☀️', isCompleted: true, isReminderOn: true),
    Meal(id: 'm2', userId: 'u1', category: 'Morning Snack', foods: 'Apple', time: '10:00 AM', iconEmoji: '🍎', isCompleted: true, isReminderOn: false),
    Meal(id: 'm3', userId: 'u1', category: 'Lunch', foods: 'Chicken + Vegetables', time: '12:30 PM', iconEmoji: '🍴', isCompleted: true, isReminderOn: true),
    Meal(id: 'm4', userId: 'u1', category: 'Afternoon Snack', foods: 'Bread + Fruit', time: '3:30 PM', iconEmoji: '🍌', isCompleted: false, isReminderOn: false),
    Meal(id: 'm5', userId: 'u1', category: 'Dinner', foods: 'Fish + Rice', time: '7:00 PM', iconEmoji: '🌙', isCompleted: false, isReminderOn: true),
  ];

  final List<NoteLog> _noteLogs = [
    NoteLog(
      id: 'n1',
      userId: 'u1',
      date: 'Thursday, September 25, 2026',
      mood: 'Good',
      mealNote: 'I enjoyed my lunch today. It was delicious and kept me full for the rest of the day.',
      additionalNote: 'Stay consistent and keep choosing healthy foods!',
    ),
  ];

  // READ MEALS FOR ACTIVE USER
  List<Meal> mealsForUser(String userId) =>
      _meals.where((m) => m.userId == userId).toList();

  // CREATE MEAL / REMINDER
  void addMeal(Meal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  // UPDATE MEAL / REMINDER
  void updateMeal(String id, {String? category, String? foods, String? time, String? iconEmoji, bool? isReminderOn}) {
    final index = _meals.indexWhere((m) => m.id == id);
    if (index != -1) {
      if (category != null) _meals[index].category = category;
      if (foods != null) _meals[index].foods = foods;
      if (time != null) _meals[index].time = time;
      if (iconEmoji != null) _meals[index].iconEmoji = iconEmoji;
      if (isReminderOn != null) _meals[index].isReminderOn = isReminderOn;
      notifyListeners();
    }
  }

  void toggleMealCompletion(String id) {
    final index = _meals.indexWhere((m) => m.id == id);
    if (index != -1) {
      _meals[index].isCompleted = !_meals[index].isCompleted;
      notifyListeners();
    }
  }

  void toggleReminder(String id) {
    final index = _meals.indexWhere((m) => m.id == id);
    if (index != -1) {
      _meals[index].isReminderOn = !_meals[index].isReminderOn;
      notifyListeners();
    }
  }

  // DELETE MEAL / REMINDER
  void deleteMeal(String id) {
    _meals.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // READ NOTES FOR ACTIVE USER
  List<NoteLog> logsForUser(String userId) =>
      _noteLogs.where((n) => n.userId == userId).toList();

  // CREATE NOTE LOG
  void addNoteLog(NoteLog log) {
    _noteLogs.insert(0, log);
    notifyListeners();
  }

  // UPDATE NOTE LOG
  void updateNoteLog(String id, {required String mood, required String mealNote, required String additionalNote}) {
    final index = _noteLogs.indexWhere((n) => n.id == id);
    if (index != -1) {
      _noteLogs[index].mood = mood;
      _noteLogs[index].mealNote = mealNote;
      _noteLogs[index].additionalNote = additionalNote;
      notifyListeners();
    }
  }

  // DELETE NOTE LOG
  void deleteNoteLog(String id) {
    _noteLogs.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}