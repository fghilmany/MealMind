import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'app_shell.dart';

void main() {
  runApp(const MealMindApp());
}

class MealMindApp extends StatelessWidget {
  const MealMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
