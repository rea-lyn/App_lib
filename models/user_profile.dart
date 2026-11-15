class UserProfile {
  final String id;
  String name;
  String dietaryGoal;
  String avatarEmoji;

  UserProfile({
    required this.id,
    required this.name,
    required this.dietaryGoal,
    this.avatarEmoji = '🥗',
  });
}
