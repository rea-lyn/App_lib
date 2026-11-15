import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/users_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
      ],
      child: const MealistaApp(),
    ),
  );
}

class MealistaApp extends StatelessWidget {
  const MealistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mealista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0B68B3),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B9A57),
          primary: const Color(0xFF0B68B3),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainShellScreen(),
        '/home': (context) => const HomeScreen(),
        '/plan': (context) => const PlanScreen(),
        '/reminders': (context) => const RemindersScreen(),
        '/notes': (context) => const NotesScreen(),
        '/users': (context) => const UsersScreen(),
      },
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PlanScreen(),
    RemindersScreen(),
    NotesScreen(),
    UsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final activeUser = context.watch<UserProvider>().activeUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B68B3),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🍃 ', style: TextStyle(fontSize: 18)),
            Text('Mealista', style: TextStyle(fontWeight: FontWeight.w800)),
            Text(' 🍃', style: TextStyle(fontSize: 18)),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 4),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white24,
              child: Text(
                activeUser.avatarEmoji,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () => setState(() => _selectedIndex = 2),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B9A57),
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
