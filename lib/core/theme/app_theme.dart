import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Core colors
  static const Color primary = Color(0xFF00995D);
  static const Color secondary = Color(0xFF006B57);
  static const Color background = Color(0xFFF4F4F4);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color border = Color(0xFFE5E7EB);
  static const Color cardBackground = Color(0xFF006B57);
  static const Color cardBadge = Color(0xFFD1DF48);
  static const Color navSelected = Color(0xFF00995D);
  static const Color navUnselected = Color(0xFF9CA3AF);

  // Bottom navigation colors
  static const Color bottomNavBackground = Color(0xFF006B57);
  static const Color bottomNavSelected = Color(0xFFD1DF48);
  static const Color bottomNavUnselected = Colors.white;

  // Virtual card colors
  static const Color virtualCardHeader = Color(0xFF00995D);
  static const Color virtualCardDetails = Color(0xFFD1DF48);
  static const Color virtualCardText = Color(0xFF22252D);
  static const Color virtualCardTabText = Color(0xFF202229);
  static const Color virtualCardMutedText = Color(0xFF777777);
  static const Color virtualCardSwitch = Color(0xFF747A80);
  static const Color virtualCardInfoBackground = Color(0xFFFFC62C);
  static const Color virtualCardInfoBorder = Color(0xFFFF8A00);
  static const Color virtualCardInfoIcon = Color(0xFFFF7900);
  static const Color virtualCardShadow = Color(0x1A000000);

  // Menu colors
  static const Color menuBackground = Color(0xFF00995D);
  static const Color menuGreen = Color(0xFF00995D);
  static const Color menuLime = Color(0xFFA8CF45);
  static const Color menuTerracotta = Color(0xFFB66E5A);
  static const Color menuLightGreen = Color(0xFF85B965);
  static const Color menuBlue = Color(0xFF4B9EAD);
  static const Color menuRose = Color(0xFFD47C82);
  static const Color menuOrange = Color(0xFFFFB52E);
  static const Color menuDivider = Color(0xFFD9DEE2);
  static const Color menuSubmenuBackground = Color(0xFFF6F8F7);

  // General text styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle actionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headerGreeting = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerAction = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardNumber = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardName = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static const TextStyle cardTag = TextStyle(fontWeight: FontWeight.bold);

  // Virtual card text styles
  static const TextStyle virtualCardBack = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardPageTitle = TextStyle(
    color: Colors.white,
    fontSize: 23,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardTabSelected = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardTabUnselected = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle virtualCardTabPlaceholder = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardLogo = TextStyle(
    color: Colors.white,
    fontSize: 42,
    fontWeight: FontWeight.w800,
    height: 1,
    letterSpacing: -1.5,
  );

  static const TextStyle virtualCardUnit = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardPlan = TextStyle(
    color: Colors.white,
    fontSize: 15,
    height: 1.25,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardContract = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardNumber = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 23,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.8,
  );

  static const TextStyle virtualCardValue = TextStyle(
    color: Colors.black,
    fontSize: 14,
    height: 1.15,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle virtualCardLabel = TextStyle(
    color: Colors.black,
    fontSize: 11,
    height: 1.15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardStatus = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardMoreInfo = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardFront = TextStyle(
    color: Color(0xFF00995D),
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle virtualCardBackSide = TextStyle(
    color: Color(0xFF777777),
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  // Menu text styles
  static const TextStyle menuGreeting = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle menuChangeUser = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle menuSearchText = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 18,
  );

  static const TextStyle menuSearchHint = TextStyle(
    color: Color(0xFF9CA3AF),
    fontSize: 18,
  );

  static const TextStyle menuItemTitle = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle menuSubItemTitle = TextStyle(
    color: Color(0xFF22252D),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle menuEmptyText = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bottomNavLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

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
