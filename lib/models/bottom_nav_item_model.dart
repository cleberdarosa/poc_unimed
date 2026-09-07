class BottomNavItemModel {
  final String id;
  final String label;
  final String icon;
  final String activeIcon;
  final String route;
  final bool enabled;
  final int order;

  const BottomNavItemModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.enabled,
    required this.order,
  });

  factory BottomNavItemModel.fromJson(Map<String, dynamic> json) {
    return BottomNavItemModel(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      activeIcon: json['activeIcon'] as String? ?? json['icon'] as String,
      route: json['route'] as String,
      enabled: json['enabled'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'activeIcon': activeIcon,
      'route': route,
      'enabled': enabled,
      'order': order,
    };
  }
}

class BottomNavigationResponseModel {
  final int version;
  final List<BottomNavItemModel> items;

  const BottomNavigationResponseModel({
    required this.version,
    required this.items,
  });

  factory BottomNavigationResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];

    return BottomNavigationResponseModel(
      version: json['version'] as int? ?? 1,
      items: rawItems
          .map(
            (item) => BottomNavItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}
