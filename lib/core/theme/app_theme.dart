import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4D9B63);

  static const Color secondary = Color(0xFF2E6E44);

  static const Color background = Color(0xFFFFFFFF);

  static const Color white = Colors.white;

  static const Color textPrimary = Color(0xFF1F2937);

  static const Color textSecondary = Color(0xFF6B7280);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(seedColor: primary),

      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: white,
        centerTitle: true,
      ),
    );
  }
}
