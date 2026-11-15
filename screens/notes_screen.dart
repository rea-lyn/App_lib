import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_log.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _mood = 'Good';
  String? _editingLogId;
  final _mealNoteCtrl = TextEditingController();
  final _additionalNoteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().activeUser.id;
    final mealProvider = context.watch<MealProvider>();
    final logs = mealProvider.logsForUser(userId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily Eating Notes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Text('How was your day?', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Good', 'Okay', 'Not Good'].map((m) {
              final selected = _mood == m;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Center(child: Text(m)),
                    selected: selected,
                    onSelected: (_) => setState(() => _mood = m),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _mealNoteCtrl,
            maxLength: 200,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Meal Notes', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _additionalNoteCtrl,
            maxLength: 200,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Additional Note', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B9A57),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (_editingLogId == null) {
                  mealProvider.addNoteLog(NoteLog(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: userId,
                    date: 'Thursday, September 25, 2026',
                    mood: _mood,
                    mealNote: _mealNoteCtrl.text,
                    additionalNote: _additionalNoteCtrl.text,
                  ));
                } else {
                  mealProvider.updateNoteLog(
                    _editingLogId!,
                    mood: _mood,
                    mealNote: _mealNoteCtrl.text,
                    additionalNote: _additionalNoteCtrl.text,
                  );
                  setState(() => _editingLogId = null);
                }
                _mealNoteCtrl.clear();
                _additionalNoteCtrl.clear();
              },
              icon: const Icon(Icons.save),
              label: Text(_editingLogId == null ? 'Save Log' : 'Update Log'),
            ),
          ),
          const Divider(height: 32),
          const Text('Saved Logs', style: TextStyle(fontWeight: FontWeight.bold)),
          ...logs.map((log) => Card(
                child: ListTile(
                  title: Text('${log.mood} • ${log.date}'),
                  subtitle: Text(log.mealNote),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF0B68B3)),
                        onPressed: () => setState(() {
                          _editingLogId = log.id;
                          _mood = log.mood;
                          _mealNoteCtrl.text = log.mealNote;
                          _additionalNoteCtrl.text = log.additionalNote;
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => mealProvider.deleteNoteLog(log.id),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}