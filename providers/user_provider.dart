import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  final List<UserProfile> _users = [
    UserProfile(
      id: 'u1',
      name: 'Realyn A. Maraña',
      dietaryGoal: 'Balanced Diet & Hydration',
      avatarEmoji: '🥗',
    ),
    UserProfile(
      id: 'u2',
      name: 'Christopher Vitaci',
      dietaryGoal: 'High Protein & Fitness',
      avatarEmoji: '🏃',
    ),
    UserProfile(
      id: 'u3',
      name: 'Group Member 3',
      dietaryGoal: 'Clean Eating & Wellness',
      avatarEmoji: '🥑',
    ),
  ];

  String _activeUserId = 'u1';

  List<UserProfile> get users => _users;

  UserProfile get activeUser => _users.firstWhere(
    (u) => u.id == _activeUserId,
    orElse: () => _users.first,
  );

  // SWITCH ACTIVE USER
  void selectUser(String userId) {
    _activeUserId = userId;
    notifyListeners();
  }

  // CREATE USER
  void addUser(String name, String dietaryGoal, String avatarEmoji) {
    final newUser = UserProfile(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      dietaryGoal: dietaryGoal,
      avatarEmoji: avatarEmoji,
    );
    _users.add(newUser);
    _activeUserId = newUser.id;
    notifyListeners();
  }

  // UPDATE USER
  void updateUser(
    String id,
    String name,
    String dietaryGoal,
    String avatarEmoji,
  ) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx].name = name;
      _users[idx].dietaryGoal = dietaryGoal;
      _users[idx].avatarEmoji = avatarEmoji;
      notifyListeners();
    }
  }

  // DELETE USER
  void deleteUser(String id) {
    if (_users.length <= 1) return;
    _users.removeWhere((u) => u.id == id);
    if (_activeUserId == id) {
      _activeUserId = _users.first.id;
    }
    notifyListeners();
  }
}
