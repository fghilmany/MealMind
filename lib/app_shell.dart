import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/planner/presentation/pages/planner_page.dart';
import 'features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'core/widgets/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    PlannerPage(),
    AiAssistantPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
