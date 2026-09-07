import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../models/menu_item_model.dart';
import '../../repositories/menu_repository.dart';
import '../../widgets/app_bottom_nav.dart';

class MenuPage extends StatefulWidget {
  final MenuRepository? repository;

  const MenuPage({super.key, this.repository});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Set<String> _expandedItems = <String>{};

  late final MenuRepository _repository;
  late Future<List<MenuItemModel>> _menuFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MenuRepository.mock();
    _menuFuture = _repository.getMenu();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.menuBackground,
      bottomNavigationBar: const AppBottomNav(currentItemId: 'home'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(),
            Expanded(
              child: FutureBuilder<List<MenuItemModel>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return _MenuError(onRetry: _reloadMenu);
                  }

                  final items = _filterItems(snapshot.data ?? const []);
                  if (items.isEmpty) return const _EmptySearch();

                  return RefreshIndicator(
                    onRefresh: _reloadMenu,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        DS.spaceMd,
                        DS.spaceSm,
                        DS.spaceMd,
                        DS.spaceLg,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildRootItem(items[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceMd,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: DS.menuAvatarRadius,
            backgroundColor: AppTheme.white,
            child: CircleAvatar(
              radius: DS.menuAvatarInnerRadius,
              backgroundColor: AppTheme.menuBackground,
              child: Icon(
                Icons.person,
                color: AppTheme.white,
                size: DS.menuHeaderIconSize,
              ),
            ),
          ),
          const SizedBox(width: DS.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Olá, Cleber', style: AppTheme.menuGreeting),
                const SizedBox(height: DS.spaceSm),
                FilledButton.icon(
                  onPressed: () => context.go('/home'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DS.spaceMd,
                      vertical: DS.spaceSm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DS.radiusSm),
                    ),
                  ),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text(
                    'Alterar usuário',
                    style: AppTheme.menuChangeUser,
                  ),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            onPressed: _searchFocusNode.requestFocus,
            style: IconButton.styleFrom(
              foregroundColor: AppTheme.white,
              side: const BorderSide(color: AppTheme.white),
              minimumSize: const Size.square(DS.menuSearchButtonSize),
            ),
            icon: const Icon(Icons.search, size: DS.menuHeaderIconSize),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DS.spaceMd,
        DS.spaceMd,
        DS.spaceMd,
        DS.spaceSm,
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (value) => setState(() => _query = value.trim()),
        textInputAction: TextInputAction.search,
        style: AppTheme.menuSearchText,
        decoration: InputDecoration(
          hintText: 'Faça sua busca',
          hintStyle: AppTheme.menuSearchHint,
          filled: true,
          fillColor: AppTheme.white,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DS.spaceMd,
            vertical: DS.spaceMd,
          ),
          border: _searchBorder(),
          enabledBorder: _searchBorder(),
          focusedBorder: _searchBorder(
            color: AppTheme.secondary,
            width: DS.menuFocusedBorderWidth,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _searchBorder({
    Color color = AppTheme.menuDivider,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(DS.radiusSm),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildRootItem(MenuItemModel item) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.menuDivider)),
      ),
      child: _RecursiveMenuTile(
        item: item,
        level: 0,
        expandedItems: _expandedItems,
        onToggle: _toggleExpanded,
        onLeafTap: _navigateToItem,
      ),
    );
  }

  List<MenuItemModel> _filterItems(List<MenuItemModel> items) {
    if (_query.isEmpty) return items;

    final normalizedQuery = _normalize(_query);
    final filtered = items
        .map((item) => _filterItem(item, normalizedQuery))
        .whereType<MenuItemModel>()
        .toList();

    _scheduleExpandSearchResults(filtered);
    return filtered;
  }

  MenuItemModel? _filterItem(MenuItemModel item, String query) {
    final matches = _normalize(item.title).contains(query);
    final children = item.children
        .map((child) => _filterItem(child, query))
        .whereType<MenuItemModel>()
        .toList();

    if (!matches && children.isEmpty) return null;
    return item.copyWith(children: matches ? item.children : children);
  }

  void _scheduleExpandSearchResults(List<MenuItemModel> items) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _query.isEmpty) return;
      final ids = <String>{};
      _collectParentIds(items, ids);
      if (ids.difference(_expandedItems).isNotEmpty) {
        setState(() => _expandedItems.addAll(ids));
      }
    });
  }

  void _collectParentIds(List<MenuItemModel> items, Set<String> ids) {
    for (final item in items) {
      if (item.hasChildren) {
        ids.add(item.id);
        _collectParentIds(item.children, ids);
      }
    }
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp('[áàãâä]'), 'a')
        .replaceAll(RegExp('[éèêë]'), 'e')
        .replaceAll(RegExp('[íìîï]'), 'i')
        .replaceAll(RegExp('[óòõôö]'), 'o')
        .replaceAll(RegExp('[úùûü]'), 'u')
        .replaceAll('ç', 'c');
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (!_expandedItems.add(id)) _expandedItems.remove(id);
    });
  }

  void _navigateToItem(MenuItemModel item) {
    context.go(item.route ?? '/home');
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _query = '';
      _expandedItems.clear();
    });
  }

  Future<void> _reloadMenu() async {
    final future = _repository.getMenu();
    setState(() => _menuFuture = future);
    await future;
  }
}

class _RecursiveMenuTile extends StatelessWidget {
  final MenuItemModel item;
  final int level;
  final Set<String> expandedItems;
  final ValueChanged<String> onToggle;
  final ValueChanged<MenuItemModel> onLeafTap;

  const _RecursiveMenuTile({
    required this.item,
    required this.level,
    required this.expandedItems,
    required this.onToggle,
    required this.onLeafTap,
  });

  @override
  Widget build(BuildContext context) {
    final expanded = expandedItems.contains(item.id);

    return Column(
      children: [
        Material(
          color: level == 0 ? AppTheme.white : AppTheme.menuSubmenuBackground,
          child: ListTile(
            minTileHeight: level == 0
                ? DS.menuItemHeight
                : DS.menuSubItemHeight,
            contentPadding: EdgeInsets.only(
              left: _leftPadding,
              right: DS.spaceMd,
            ),
            leading: _buildLeading(),
            title: Text(
              item.title,
              style: level == 0
                  ? AppTheme.menuItemTitle
                  : AppTheme.menuSubItemTitle,
            ),
            trailing: item.hasChildren
                ? AnimatedRotation(
                    duration: DS.menuAnimationDuration,
                    turns: expanded ? DS.menuArrowTurns : 0,
                    child: const Icon(Icons.keyboard_arrow_down),
                  )
                : const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: item.hasChildren
                ? () => onToggle(item.id)
                : item.enabled
                ? () => onLeafTap(item)
                : null,
          ),
        ),
        AnimatedCrossFade(
          duration: DS.menuAnimationDuration,
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: item.children
                .map(
                  (child) => _RecursiveMenuTile(
                    item: child,
                    level: level + 1,
                    expandedItems: expandedItems,
                    onToggle: onToggle,
                    onLeafTap: onLeafTap,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget? _buildLeading() {
    if (level == 0) {
      return Icon(
        _iconFromName(item.icon),
        color: _colorFromName(item.color),
        size: DS.menuItemIconSize,
      );
    }

    if (level == 1) {
      return const Icon(
        Icons.subdirectory_arrow_right,
        color: AppTheme.primary,
        size: DS.navIconSize,
      );
    }

    return const Icon(Icons.circle, color: AppTheme.primary, size: DS.spaceSm);
  }

  double get _leftPadding {
    if (level == 0) return DS.spaceMd;
    if (level == 1) return DS.spaceLg;
    return DS.menuSubItemLeftPadding;
  }

  IconData _iconFromName(String? name) {
    return switch (name) {
      'menu_book' => Icons.menu_book_outlined,
      'phone' => Icons.phone,
      'medical_services' => Icons.medical_services_outlined,
      'calendar_month' => Icons.calendar_month_outlined,
      'monetization_on' => Icons.monetization_on_outlined,
      'science' => Icons.science_outlined,
      'badge' => Icons.badge_outlined,
      'hexagon' => Icons.hexagon_outlined,
      'favorite_border' => Icons.favorite_border,
      'local_hospital' => Icons.local_hospital_outlined,
      'add_box' => Icons.add_box_outlined,
      'verified' => Icons.verified_outlined,
      _ => Icons.chevron_right,
    };
  }

  Color _colorFromName(String? name) {
    return switch (name) {
      'menuGreen' => AppTheme.menuGreen,
      'menuLime' => AppTheme.menuLime,
      'menuTerracotta' => AppTheme.menuTerracotta,
      'menuLightGreen' => AppTheme.menuLightGreen,
      'menuBlue' => AppTheme.menuBlue,
      'menuRose' => AppTheme.menuRose,
      'menuOrange' => AppTheme.menuOrange,
      _ => AppTheme.primary,
    };
  }
}

class _MenuError extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _MenuError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DS.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Não foi possível carregar o menu.',
              style: AppTheme.menuEmptyText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DS.spaceMd),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(DS.spaceLg),
        child: Text(
          'Nenhum item encontrado.',
          style: AppTheme.menuEmptyText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
