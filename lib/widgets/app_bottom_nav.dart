import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/design_system.dart';
import '../repositories/bottom_nav_repository.dart';
import '../models/bottom_nav_item_model.dart';

class AppBottomNav extends StatefulWidget {
  final String currentItemId;
  final BottomNavRepository? repository;
  final ValueChanged<BottomNavItemModel>? onItemTap;

  const AppBottomNav({
    super.key,
    required this.currentItemId,
    this.repository,
    this.onItemTap,
  });

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  static final BottomNavRepository _defaultRepository =
      BottomNavRepository.mock();

  late BottomNavRepository _repository;
  late Future<List<BottomNavItemModel>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _configureRepository();
  }

  @override
  void didUpdateWidget(covariant AppBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.repository != widget.repository) {
      _configureRepository();
    }
  }

  void _configureRepository() {
    _repository = widget.repository ?? _defaultRepository;
    _itemsFuture = _repository.getBottomNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BottomNavItemModel>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildNavigationBar(context, snapshot.data!);
        }

        if (snapshot.hasError) {
          return _buildNavigationBar(context, _fallbackItems);
        }

        return const SizedBox(
          height: DS.bottomNavHeight,
          child: ColoredBox(
            color: AppTheme.bottomNavBackground,
            child: Center(
              child: SizedBox(
                width: DS.bottomNavLoadingSize,
                height: DS.bottomNavLoadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: DS.bottomNavLoadingStrokeWidth,
                  color: AppTheme.bottomNavSelected,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(
    BuildContext context,
    List<BottomNavItemModel> items,
  ) {
    final selectedIndex = _selectedIndex(items);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _handleTap(context, items[index]),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.bottomNavBackground,
      selectedItemColor: AppTheme.bottomNavSelected,
      unselectedItemColor: AppTheme.bottomNavUnselected,
      selectedLabelStyle: AppTheme.bottomNavLabel,
      unselectedLabelStyle: AppTheme.bottomNavLabel,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(_iconFromName(item.icon), size: DS.navIconSize),
              activeIcon: Icon(
                _iconFromName(item.activeIcon),
                size: DS.navIconSize,
              ),
              label: item.label,
            ),
          )
          .toList(growable: false),
    );
  }

  int _selectedIndex(List<BottomNavItemModel> items) {
    final index = items.indexWhere((item) => item.id == widget.currentItemId);

    return index >= 0 ? index : 0;
  }

  void _handleTap(BuildContext context, BottomNavItemModel item) {
    widget.onItemTap?.call(item);

    final currentLocation = GoRouterState.of(context).uri.path;
    if (currentLocation == item.route) {
      return;
    }

    context.go(item.route);
  }

  IconData _iconFromName(String name) {
    return switch (name) {
      'home' => Icons.home,
      'home_outlined' => Icons.home_outlined,
      'science' => Icons.science,
      'science_outlined' => Icons.science_outlined,
      'menu_book' => Icons.menu_book,
      'menu_book_outlined' => Icons.menu_book_outlined,
      'map' => Icons.map,
      'map_outlined' => Icons.map_outlined,
      'person' => Icons.person,
      'person_outline' => Icons.person_outline,
      'menu' => Icons.menu,
      'more_horiz' => Icons.more_horiz,
      _ => Icons.circle_outlined,
    };
  }

  static const List<BottomNavItemModel> _fallbackItems = [
    BottomNavItemModel(
      id: 'home',
      label: 'Início',
      icon: 'home_outlined',
      activeIcon: 'home',
      route: '/home',
      enabled: true,
      order: 1,
    ),
    BottomNavItemModel(
      id: 'exams',
      label: 'Exames',
      icon: 'science_outlined',
      activeIcon: 'science',
      route: '/home',
      enabled: true,
      order: 2,
    ),
    BottomNavItemModel(
      id: 'medical-guide',
      label: 'Guia Médico',
      icon: 'menu_book_outlined',
      activeIcon: 'menu_book',
      route: '/home',
      enabled: true,
      order: 3,
    ),
    BottomNavItemModel(
      id: 'profile',
      label: 'Perfil',
      icon: 'person_outline',
      activeIcon: 'person',
      route: '/home',
      enabled: true,
      order: 4,
    ),
    BottomNavItemModel(
      id: 'menu',
      label: 'Menu',
      icon: 'menu',
      activeIcon: 'menu',
      route: '/menu',
      enabled: true,
      order: 5,
    ),
  ];
}
