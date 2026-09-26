import 'package:flutter/material.dart';

class AppColors {
  static const Color night = Color(0xFF0B1025);
  static const Color night2 = Color(0xFF141B38);
  static const Color violet = Color(0xFF5D4FE8);
  static const Color violetSoft = Color(0xFF8F6BFF);
  static const Color blue = Color(0xFF3AA1FF);
  static const Color pink = Color(0xFFFF66BB);
  static const Color green = Color(0xFF29C589);
  static const Color card = Color(0xFFF9F9FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1E2338);
  static const Color muted = Color(0xFF7B8096);
  static const Color line = Color(0xFFE7E5F3);
  static const Color gold = Color(0xFFFFD48B);
  static const Color shadow = Color(0x1A0B1025);

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [
      Color(0xFF6A56FF),
      Color(0xFF4DA8FF),
      Color(0xFFFF5FB7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient selectedDayGradient = LinearGradient(
    colors: [
      Color(0xFF6E5BEF),
      Color(0xFF8B5EF6),
      Color(0xFFB86BFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
