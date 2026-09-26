import 'package:flutter/material.dart';

import 'screens/calendar_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lúmina Calendar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750E8),
          surface: const Color(0xFFF8F7FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F2FA),
        fontFamily: 'Arial',
      ),
      home: const CalendarPage(),
    );
  }
}
