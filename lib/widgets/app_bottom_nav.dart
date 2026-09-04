import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/design_system.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      selectedItemColor:
          AppTheme.navSelected,

      unselectedItemColor:
          AppTheme.navUnselected,

      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: DS.navIconSize,
          ),
          activeIcon: Icon(
            Icons.home,
            size: DS.navIconSize,
          ),
          label: 'Início',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.science_outlined,
            size: DS.navIconSize,
          ),
          label: 'Exames',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
            size: DS.navIconSize,
          ),
          label: 'Guia',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: DS.navIconSize,
          ),
          label: 'Perfil',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu,
            size: DS.navIconSize,
          ),
          label: 'Menu',
        ),
      ],
    );
  }
}