import '../models/bottom_nav_item_model.dart';
import '../services/bottom_nav_data_source.dart';

class BottomNavRepository {
  final BottomNavDataSource primaryDataSource;
  final BottomNavDataSource? fallbackDataSource;

  List<BottomNavItemModel>? _cache;

  BottomNavRepository({
    required this.primaryDataSource,
    this.fallbackDataSource,
  });

  factory BottomNavRepository.mock() {
    return BottomNavRepository(
      primaryDataSource: const AssetBottomNavDataSource(),
    );
  }

  factory BottomNavRepository.apiWithMockFallback({
    required Future<Map<String, dynamic>> Function() requestBottomNavigation,
  }) {
    return BottomNavRepository(
      primaryDataSource: ApiBottomNavDataSource(
        requestBottomNavigation: requestBottomNavigation,
      ),
      fallbackDataSource: const AssetBottomNavDataSource(),
    );
  }

  Future<List<BottomNavItemModel>> getBottomNavigation({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache != null) {
      return _cache!;
    }

    try {
      final response = await primaryDataSource.getBottomNavigation();
      return _saveCache(response.items);
    } catch (_) {
      final fallback = fallbackDataSource;

      if (fallback == null) {
        rethrow;
      }

      final response = await fallback.getBottomNavigation();
      return _saveCache(response.items);
    }
  }

  List<BottomNavItemModel> _saveCache(List<BottomNavItemModel> items) {
    final result = items.where((item) => item.enabled).toList()
      ..sort((first, second) => first.order.compareTo(second.order));

    _cache = List<BottomNavItemModel>.unmodifiable(result);
    return _cache!;
  }

  void clearCache() {
    _cache = null;
  }
}
