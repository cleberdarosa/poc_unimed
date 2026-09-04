import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/design_system.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.bottomNavBackground,
      selectedItemColor: AppTheme.bottomNavSelected,
      unselectedItemColor: AppTheme.bottomNavUnselected,
      selectedLabelStyle: AppTheme.bottomNavLabel,
      unselectedLabelStyle: AppTheme.bottomNavLabel,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: DS.navIconSize),
          activeIcon: Icon(Icons.home, size: DS.navIconSize),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.science_outlined, size: DS.navIconSize),
          activeIcon: Icon(Icons.science, size: DS.navIconSize),
          label: 'Exames',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined, size: DS.navIconSize),
          activeIcon: Icon(Icons.menu_book, size: DS.navIconSize),
          label: 'Guia Médico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: DS.navIconSize),
          activeIcon: Icon(Icons.person, size: DS.navIconSize),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, size: DS.navIconSize),
          label: 'Menu',
        ),
      ],
    );
  }

  void _navigate(BuildContext context, int index) {
    onTap?.call(index);

    if (index == 4) {
      context.go('/menu');
      return;
    }

    // Rotas temporarias: Inicio, Exames, Guia Medico e Perfil levam a Home.
    context.go('/home');
  }
}
