import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SHTheadsApp());
}

class SHTheadsApp extends StatelessWidget {
  const SHTheadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHTheads',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
