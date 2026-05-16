import '../../../../core/database/app_database.dart';

class HomeLocalDataSource {
  HomeLocalDataSource(this._db);

  final AppDatabase _db;

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<String?> getCachedJson() async {
    return _db.getCachedRecommendation(_todayKey());
  }

  Future<void> cacheJson(String json) async {
    await _db.cacheRecommendation(json, _todayKey());
  }

  Future<void> clearCache() async {
    await _db.clearRecommendationCache();
  }
}
