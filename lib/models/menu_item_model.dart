class MenuItemModel {
  final String id;
  final String title;
  final String? icon;
  final String? color;
  final String? route;
  final bool enabled;
  final List<MenuItemModel> children;

  const MenuItemModel({
    required this.id,
    required this.title,
    this.icon,
    this.color,
    this.route,
    this.enabled = true,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;
  bool get isNavigable => enabled && !hasChildren && route != null;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List<dynamic>? ?? const [];

    return MenuItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      route: json['route'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      children: rawChildren
          .map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (route != null) 'route': route,
      'enabled': enabled,
      'children': children.map((item) => item.toJson()).toList(),
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? title,
    String? icon,
    String? color,
    String? route,
    bool? enabled,
    List<MenuItemModel>? children,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      route: route ?? this.route,
      enabled: enabled ?? this.enabled,
      children: children ?? this.children,
    );
  }
}

class MenuResponseModel {
  final int version;
  final List<MenuItemModel> items;

  const MenuResponseModel({required this.version, required this.items});

  factory MenuResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];

    return MenuResponseModel(
      version: json['version'] as int? ?? 1,
      items: rawItems
          .map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
