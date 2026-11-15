class NoteLog {
  final String id;
  final String userId;
  String date;
  String mood;
  String mealNote;
  String additionalNote;

  NoteLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    required this.mealNote,
    required this.additionalNote,
  });
}
