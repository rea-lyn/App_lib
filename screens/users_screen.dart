import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/user_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  void _openUserDialog(BuildContext context, {UserProfile? existingUser}) {
    final nameCtrl = TextEditingController(text: existingUser?.name ?? '');
    final goalCtrl = TextEditingController(
      text: existingUser?.dietaryGoal ?? '',
    );
    String emoji = existingUser?.avatarEmoji ?? '🥗';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          existingUser == null ? 'Add Group Member' : 'Edit Member Profile',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: goalCtrl,
              decoration: const InputDecoration(labelText: 'Dietary Goal'),
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
              if (nameCtrl.text.trim().isEmpty) return;
              final provider = context.read<UserProvider>();
              if (existingUser == null) {
                provider.addUser(
                  nameCtrl.text.trim(),
                  goalCtrl.text.trim(),
                  emoji,
                );
              } else {
                provider.updateUser(
                  existingUser.id,
                  nameCtrl.text.trim(),
                  goalCtrl.text.trim(),
                  emoji,
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
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];
          final isActive = user.id == userProvider.activeUser.id;
          return Card(
            color: isActive ? const Color(0xFFE6F3FC) : Colors.white,
            child: ListTile(
              onTap: () => userProvider.selectUser(user.id),
              leading: CircleAvatar(child: Text(user.avatarEmoji)),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.dietaryGoal),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF0B68B3)),
                    onPressed: () =>
                        _openUserDialog(context, existingUser: user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => userProvider.deleteUser(user.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0B68B3),
        foregroundColor: Colors.white,
        onPressed: () => _openUserDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
    );
  }
}
