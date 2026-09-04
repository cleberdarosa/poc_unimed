import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../widgets/app_bottom_nav.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _expandedItems = <String>{};

  String _query = '';

  static const List<MenuItemModel> _menuItems = [
    MenuItemModel(
      id: 'medical-network',
      title: 'Encontre um Médico e Rede Credenciada',
      icon: Icons.menu_book_outlined,
      iconColor: AppTheme.menuGreen,
    ),
    MenuItemModel(
      id: 'service-channels',
      title: 'Canais de Atendimento',
      icon: Icons.phone,
      iconColor: AppTheme.menuGreen,
    ),
    MenuItemModel(
      id: 'medical-appointments',
      title: 'Consultas Médicas',
      icon: Icons.medical_services_outlined,
      iconColor: AppTheme.menuLime,
      children: [
        MenuItemModel(
          id: 'medical-appointments-schedule',
          title: 'Agendar consulta',
          children: [
            MenuItemModel(
              id: 'medical-appointments-schedule-presential',
              title: 'Consulta presencial',
            ),
            MenuItemModel(
              id: 'medical-appointments-schedule-telemedicine',
              title: 'Telemedicina',
            ),
            MenuItemModel(
              id: 'medical-appointments-schedule-digital-care',
              title: 'Pronto atendimento digital',
            ),
          ],
        ),
        MenuItemModel(
          id: 'medical-appointments-next',
          title: 'Próximas consultas',
          children: [
            MenuItemModel(
              id: 'medical-appointments-next-confirmed',
              title: 'Consultas confirmadas',
            ),
            MenuItemModel(
              id: 'medical-appointments-next-pending',
              title: 'Consultas pendentes',
            ),
          ],
        ),
        MenuItemModel(
          id: 'medical-appointments-history',
          title: 'Histórico de consultas',
        ),
      ],
    ),
    MenuItemModel(
      id: 'schedules',
      title: 'Agendamentos',
      icon: Icons.calendar_month_outlined,
      iconColor: AppTheme.menuTerracotta,
      children: [
        MenuItemModel(
          id: 'schedules-new',
          title: 'Novo agendamento',
          children: [
            MenuItemModel(id: 'schedules-new-exam', title: 'Agendar exame'),
            MenuItemModel(
              id: 'schedules-new-procedure',
              title: 'Agendar procedimento',
            ),
          ],
        ),
        MenuItemModel(id: 'schedules-next', title: 'Próximos agendamentos'),
        MenuItemModel(id: 'schedules-history', title: 'Histórico'),
        MenuItemModel(id: 'schedules-cancel', title: 'Cancelar agendamento'),
      ],
    ),
    MenuItemModel(
      id: 'financial',
      title: 'Financeiro',
      icon: Icons.monetization_on_outlined,
      iconColor: AppTheme.menuLightGreen,
      children: [
        MenuItemModel(
          id: 'financial-invoices',
          title: 'Boletos',
          children: [
            MenuItemModel(
              id: 'financial-invoices-open',
              title: 'Boletos em aberto',
            ),
            MenuItemModel(
              id: 'financial-invoices-paid',
              title: 'Boletos pagos',
            ),
            MenuItemModel(id: 'financial-invoices-copy', title: 'Segunda via'),
          ],
        ),
        MenuItemModel(id: 'financial-coparticipation', title: 'Coparticipação'),
        MenuItemModel(id: 'financial-statement', title: 'Extrato financeiro'),
      ],
    ),
    MenuItemModel(
      id: 'exams',
      title: 'Exames e Solicitações',
      icon: Icons.science_outlined,
      iconColor: AppTheme.menuBlue,
      children: [
        MenuItemModel(
          id: 'exams-results',
          title: 'Resultados de exames',
          children: [
            MenuItemModel(
              id: 'exams-results-laboratory',
              title: 'Exames laboratoriais',
            ),
            MenuItemModel(id: 'exams-results-image', title: 'Exames de imagem'),
          ],
        ),
        MenuItemModel(
          id: 'exams-authorizations',
          title: 'Autorizações',
          children: [
            MenuItemModel(
              id: 'exams-authorizations-request',
              title: 'Solicitar autorização',
            ),
            MenuItemModel(
              id: 'exams-authorizations-status',
              title: 'Consultar autorização',
            ),
          ],
        ),
        MenuItemModel(id: 'exams-requests', title: 'Minhas solicitações'),
      ],
    ),
    MenuItemModel(
      id: 'my-plan',
      title: 'Meu Plano',
      icon: Icons.badge_outlined,
      iconColor: AppTheme.menuRose,
      children: [
        MenuItemModel(id: 'my-plan-card', title: 'Cartão virtual'),
        MenuItemModel(
          id: 'my-plan-data',
          title: 'Dados do plano',
          children: [
            MenuItemModel(id: 'my-plan-data-coverage', title: 'Coberturas'),
            MenuItemModel(
              id: 'my-plan-data-waiting-period',
              title: 'Carências',
            ),
            MenuItemModel(id: 'my-plan-data-contract', title: 'Contrato'),
          ],
        ),
        MenuItemModel(id: 'my-plan-beneficiaries', title: 'Beneficiários'),
      ],
    ),
    MenuItemModel(
      id: 'others',
      title: 'Outros',
      icon: Icons.hexagon_outlined,
      iconColor: AppTheme.menuOrange,
      children: [
        MenuItemModel(id: 'others-documents', title: 'Documentos'),
        MenuItemModel(
          id: 'others-settings',
          title: 'Configurações',
          children: [
            MenuItemModel(
              id: 'others-settings-notifications',
              title: 'Notificações',
            ),
            MenuItemModel(id: 'others-settings-security', title: 'Segurança'),
          ],
        ),
        MenuItemModel(id: 'others-faq', title: 'Dúvidas frequentes'),
      ],
    ),
    MenuItemModel(
      id: 'well-being',
      title: 'Viver Bem',
      icon: Icons.favorite_border,
      iconColor: AppTheme.menuLightGreen,
    ),
    MenuItemModel(
      id: 'own-services',
      title: 'Serviços Próprios',
      icon: Icons.local_hospital_outlined,
      iconColor: AppTheme.menuLightGreen,
      children: [
        MenuItemModel(
          id: 'own-services-hospitals',
          title: 'Hospitais',
          children: [
            MenuItemModel(
              id: 'own-services-hospitals-list',
              title: 'Lista de hospitais',
            ),
            MenuItemModel(
              id: 'own-services-hospitals-emergency',
              title: 'Pronto atendimento',
            ),
          ],
        ),
        MenuItemModel(id: 'own-services-laboratories', title: 'Laboratórios'),
        MenuItemModel(id: 'own-services-clinics', title: 'Centros clínicos'),
      ],
    ),
    MenuItemModel(
      id: 'additional-products',
      title: 'Produtos Complementares',
      icon: Icons.add_box_outlined,
      iconColor: AppTheme.menuLightGreen,
      children: [
        MenuItemModel(id: 'additional-products-dental', title: 'Odontologia'),
        MenuItemModel(id: 'additional-products-pharmacy', title: 'Farmácia'),
        MenuItemModel(
          id: 'additional-products-benefits',
          title: 'Benefícios',
          children: [
            MenuItemModel(
              id: 'additional-products-benefits-discounts',
              title: 'Descontos',
            ),
            MenuItemModel(
              id: 'additional-products-benefits-partners',
              title: 'Empresas parceiras',
            ),
          ],
        ),
      ],
    ),
    MenuItemModel(
      id: 'enjoy',
      title: 'Aproveita',
      icon: Icons.verified_outlined,
      iconColor: AppTheme.menuGreen,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: AppTheme.menuBackground,
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(),
            Expanded(
              child: filteredItems.isEmpty
                  ? const _EmptySearch()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        DS.spaceMd,
                        DS.spaceSm,
                        DS.spaceMd,
                        DS.spaceLg,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildRootItem(filteredItems[index]);
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
                  onPressed: _goHome,
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
            onPressed: _focusSearch,
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
        onChanged: _onSearchChanged,
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
        onLeafTap: _goHome,
      ),
    );
  }

  List<MenuItemModel> get _filteredItems {
    if (_query.isEmpty) {
      return _menuItems;
    }

    final normalizedQuery = _normalize(_query);

    return _menuItems
        .map((item) => _filterItem(item, normalizedQuery))
        .whereType<MenuItemModel>()
        .toList();
  }

  MenuItemModel? _filterItem(MenuItemModel item, String normalizedQuery) {
    final titleMatches = _normalize(item.title).contains(normalizedQuery);

    final filteredChildren = item.children
        .map((child) => _filterItem(child, normalizedQuery))
        .whereType<MenuItemModel>()
        .toList();

    if (!titleMatches && filteredChildren.isEmpty) {
      return null;
    }

    return item.copyWith(
      children: titleMatches ? item.children : filteredChildren,
    );
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
      if (!_expandedItems.add(id)) {
        _expandedItems.remove(id);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim();

      if (_query.isNotEmpty) {
        _expandSearchResults(_filteredItems);
      }
    });
  }

  void _expandSearchResults(List<MenuItemModel> items) {
    for (final item in items) {
      if (item.children.isNotEmpty) {
        _expandedItems.add(item.id);
        _expandSearchResults(item.children);
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
      _expandedItems.clear();
    });
  }

  void _focusSearch() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _goHome() {
    context.go('/home');
  }
}

class _RecursiveMenuTile extends StatelessWidget {
  final MenuItemModel item;
  final int level;
  final Set<String> expandedItems;
  final ValueChanged<String> onToggle;
  final VoidCallback onLeafTap;

  const _RecursiveMenuTile({
    required this.item,
    required this.level,
    required this.expandedItems,
    required this.onToggle,
    required this.onLeafTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasChildren = item.children.isNotEmpty;
    final isExpanded = expandedItems.contains(item.id);

    return Column(
      children: [
        Material(
          color: _backgroundColor,
          child: ListTile(
            minTileHeight: _tileHeight,
            contentPadding: EdgeInsets.only(
              left: _leftPadding,
              right: DS.spaceMd,
            ),
            leading: _buildLeading(),
            title: Text(item.title, style: _titleStyle),
            trailing: hasChildren
                ? AnimatedRotation(
                    duration: DS.menuAnimationDuration,
                    turns: isExpanded ? DS.menuArrowTurns : 0,
                    child: const Icon(Icons.keyboard_arrow_down),
                  )
                : const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: hasChildren ? () => onToggle(item.id) : onLeafTap,
          ),
        ),
        AnimatedCrossFade(
          duration: DS.menuAnimationDuration,
          crossFadeState: isExpanded
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
    if (level == 0 && item.icon != null) {
      return Icon(item.icon, color: item.iconColor, size: DS.menuItemIconSize);
    }

    if (level == 1) {
      return const Icon(
        Icons.subdirectory_arrow_right,
        color: AppTheme.primary,
        size: DS.navIconSize,
      );
    }

    if (level >= 2) {
      return const Icon(
        Icons.circle,
        color: AppTheme.primary,
        size: DS.spaceSm,
      );
    }

    return null;
  }

  Color get _backgroundColor {
    if (level == 0) {
      return AppTheme.white;
    }

    return AppTheme.menuSubmenuBackground;
  }

  double get _tileHeight {
    if (level == 0) {
      return DS.menuItemHeight;
    }

    return DS.menuSubItemHeight;
  }

  double get _leftPadding {
    if (level == 0) {
      return DS.spaceMd;
    }

    if (level == 1) {
      return DS.spaceLg;
    }

    return DS.menuSubItemLeftPadding;
  }

  TextStyle get _titleStyle {
    if (level == 0) {
      return AppTheme.menuItemTitle;
    }

    return AppTheme.menuSubItemTitle;
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

class MenuItemModel {
  final String id;
  final String title;
  final IconData? icon;
  final Color iconColor;
  final List<MenuItemModel> children;

  const MenuItemModel({
    required this.id,
    required this.title,
    this.icon,
    this.iconColor = AppTheme.primary,
    this.children = const [],
  });

  MenuItemModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    Color? iconColor,
    List<MenuItemModel>? children,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      children: children ?? this.children,
    );
  }
}
