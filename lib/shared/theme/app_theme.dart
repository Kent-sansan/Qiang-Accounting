import 'package:flutter/material.dart';

class AppTheme {
  static const _accent = Color(0xFFa78bfa);
  static const _income = Color(0xFF4ade80);
  static const _expense = Color(0xFFf87171);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: _accent,
      fontFamily: 'NotoSansSC',
      scaffoldBackgroundColor: const Color(0xFFfafafa),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xE6fafafa),
        indicatorColor: Color(0xFFe8e0ff),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: _accent,
      fontFamily: 'NotoSansSC',
      scaffoldBackgroundColor: const Color(0xFF09090b),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xE609090b),
        indicatorColor: Color(0xFF2d2545),
      ),
    );
  }

  static Color get accent => _accent;
  static Color get income => _income;
  static Color get expense => _expense;
}
