import 'package:flutter/material.dart';

class AppColors {
  // 기본 색상
  static const Color primary = Color(0xFF00FF94);
  static const Color accent = Color(0xFF00E5FF);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color inactive = Color(0xFF666666);

  // 네온 효과 색상
  static const Color neonRed = Color(0xFFFF0000);
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonPink = Color(0xFFFF00E5);
  static const Color neonGreen = Color(0xFF00FF94);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color neonYellow = Color(0xFFFFFF00);

  // 그라데이션
  static const List<Color> primaryGradient = [
    Color(0xFF00FF94),
    Color(0xFF00E5FF),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00E5FF),
    Color(0xFF9D00FF),
  ];

  // 글래스모피즘 효과
  static Color glassBackground = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}
