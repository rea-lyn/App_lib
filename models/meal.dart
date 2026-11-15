class Meal {
  final String id;
  final String userId;
  String category;
  String foods;
  String time;
  String iconEmoji;
  bool isCompleted;
  bool isReminderOn;

  Meal({
    required this.id,
    required this.userId,
    required this.category,
    required this.foods,
    required this.time,
    required this.iconEmoji,
    this.isCompleted = false,
    this.isReminderOn = true,
  });
}
