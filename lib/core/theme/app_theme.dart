import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Paleta base
  static const Color primary = Color(0xFF00995D);
  static const Color secondary = Color(0xFF006B57);
  static const Color background = Color(0xFFF4F4F4);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;

  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF22252D);
  static const Color textSecondary = Color(0xFF777777);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color lime = Color(0xFFD1DF48);
  static const Color lightLime = Color(0xFFA8CF45);
  static const Color lightGreen = Color(0xFF85B965);
  static const Color terracotta = Color(0xFFB66E5A);
  static const Color blue = Color(0xFF4B9EAD);
  static const Color rose = Color(0xFFD47C82);
  static const Color orange = Color(0xFFFFB52E);

  static const Color warningBackground = Color(0xFFFFC62C);
  static const Color warningBorder = Color(0xFFFF8A00);
  static const Color warningIcon = Color(0xFFFF7900);

  static const Color shadow = Color(0x1A000000);
  static const Color submenuBackground = Color(0xFFF6F8F7);
  static const Color divider = Color(0xFFD9DEE2);

  // Cores semânticas gerais
  static const Color cardBackground = secondary;
  static const Color cardBadge = lime;

  static const Color navSelected = primary;
  static const Color navUnselected = textMuted;

  // Bottom Navigation
  static const Color bottomNavBackground = secondary;
  static const Color bottomNavSelected = lime;
  static const Color bottomNavUnselected = white;

  // Cartão virtual
  static const Color virtualCardHeader = primary;
  static const Color virtualCardDetails = lime;
  static const Color virtualCardText = textPrimary;
  static const Color virtualCardTabText = textPrimary;
  static const Color virtualCardMutedText = textSecondary;
  static const Color virtualCardSwitch = textSecondary;

  static const Color virtualCardInfoBackground = warningBackground;
  static const Color virtualCardInfoBorder = warningBorder;
  static const Color virtualCardInfoIcon = warningIcon;
  static const Color virtualCardShadow = shadow;

  // Menu
  static const Color menuBackground = primary;
  static const Color menuGreen = primary;
  static const Color menuLime = lightLime;
  static const Color menuTerracotta = terracotta;
  static const Color menuLightGreen = lightGreen;
  static const Color menuBlue = blue;
  static const Color menuRose = rose;
  static const Color menuOrange = orange;
  static const Color menuDivider = divider;
  static const Color menuSubmenuBackground = submenuBackground;

  // Estilos de texto gerais
  static const TextStyle titleLarge = TextStyle(
    color: textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle actionTitle = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headerGreeting = TextStyle(
    color: white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerAction = TextStyle(
    color: black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardNumber = TextStyle(
    color: white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardName = TextStyle(color: white, fontSize: 18);

  static const TextStyle cardTag = TextStyle(
    color: textPrimary,
    fontWeight: FontWeight.bold,
  );

  // Estilos do cartão virtual
  static const TextStyle virtualCardBack = TextStyle(
    color: virtualCardText,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardPageTitle = TextStyle(
    color: white,
    fontSize: 23,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardTabSelected = TextStyle(
    color: virtualCardTabText,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardTabUnselected = TextStyle(
    color: virtualCardTabText,
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle virtualCardTabPlaceholder = TextStyle(
    color: virtualCardText,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardLogo = TextStyle(
    color: white,
    fontSize: 42,
    fontWeight: FontWeight.w800,
    height: 1,
    letterSpacing: -1.5,
  );

  static const TextStyle virtualCardUnit = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardPlan = TextStyle(
    color: white,
    fontSize: 15,
    height: 1.25,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardContract = TextStyle(
    color: white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardNumber = TextStyle(
    color: virtualCardText,
    fontSize: 23,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.8,
  );

  static const TextStyle virtualCardValue = TextStyle(
    color: black,
    fontSize: 14,
    height: 1.15,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle virtualCardLabel = TextStyle(
    color: black,
    fontSize: 11,
    height: 1.15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle virtualCardStatus = TextStyle(
    color: virtualCardText,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle virtualCardMoreInfo = TextStyle(
    color: virtualCardText,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle virtualCardFront = TextStyle(
    color: primary,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle virtualCardBackSide = TextStyle(
    color: virtualCardMutedText,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  // Estilos do menu
  static const TextStyle menuGreeting = TextStyle(
    color: white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle menuChangeUser = TextStyle(
    color: secondary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle menuSearchText = TextStyle(
    color: textPrimary,
    fontSize: 18,
  );

  static const TextStyle menuSearchHint = TextStyle(
    color: textMuted,
    fontSize: 18,
  );

  static const TextStyle menuItemTitle = TextStyle(
    color: textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle menuSubItemTitle = TextStyle(
    color: textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle menuEmptyText = TextStyle(
    color: white,
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
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: white,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bottomNavBackground,
        selectedItemColor: bottomNavSelected,
        unselectedItemColor: bottomNavUnselected,
        selectedLabelStyle: bottomNavLabel,
        unselectedLabelStyle: bottomNavLabel,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(color: divider),
    );
  }
}
