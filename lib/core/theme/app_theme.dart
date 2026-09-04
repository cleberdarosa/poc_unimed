import 'package:flutter/material.dart';

class AppTheme {
  // Colors

  static const Color primary =
      Color(0xFF00995D);

  static const Color secondary =
      Color(0xFF006B57);

  static const Color background =
      Color(0xFFF4F4F4);

  static const Color white =
      Colors.white;

  static const Color border =
      Color(0xFFE5E7EB);

  static const Color cardBackground =
      Color(0xFF006B57);

  static const Color cardBadge =
      Color(0xFFD1DF48);

  static const Color navSelected =
      primary;

  static const Color navUnselected =
      Color(0xFF9CA3AF);

  // Text Styles

  static const TextStyle titleLarge =
      TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle titleMedium =
      TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle actionTitle =
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static const TextStyle headerGreeting =
      TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle headerAction =
      TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static const TextStyle cardNumber =
      TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle cardName =
      TextStyle(
        color: Colors.white,
        fontSize: 18,
      );

  static const TextStyle cardTag =
      TextStyle(
        fontWeight: FontWeight.bold,
      );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor:
          background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: white,
        centerTitle: true,
      ),
    );
  }
}
