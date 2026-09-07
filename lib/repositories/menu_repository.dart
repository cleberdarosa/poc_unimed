import '../models/menu_item_model.dart';
import '../services/menu_data_source.dart';

class MenuRepository {
  final MenuDataSource primaryDataSource;
  final MenuDataSource? fallbackDataSource;

  const MenuRepository({
    required this.primaryDataSource,
    this.fallbackDataSource,
  });

  factory MenuRepository.mock() {
    return const MenuRepository(primaryDataSource: AssetMenuDataSource());
  }

  factory MenuRepository.apiWithMockFallback({
    required Future<Map<String, dynamic>> Function() requestMenu,
  }) {
    return MenuRepository(
      primaryDataSource: ApiMenuDataSource(requestMenu: requestMenu),
      fallbackDataSource: const AssetMenuDataSource(),
    );
  }

  Future<List<MenuItemModel>> getMenu() async {
    try {
      final response = await primaryDataSource.getMenu();
      return _onlyEnabled(response.items);
    } catch (_) {
      final fallback = fallbackDataSource;
      if (fallback == null) rethrow;

      final response = await fallback.getMenu();
      return _onlyEnabled(response.items);
    }
  }

  List<MenuItemModel> _onlyEnabled(List<MenuItemModel> items) {
    return items
        .where((item) => item.enabled)
        .map((item) => item.copyWith(children: _onlyEnabled(item.children)))
        .toList(growable: false);
  }
}
