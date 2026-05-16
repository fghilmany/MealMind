
import '../../../../core/database/app_database.dart';
import '../../domain/entities/user_preference_entity.dart';

class HomeLocalDataSource {
  HomeLocalDataSource(this._db);

  final AppDatabase _db;

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// A simple fingerprint of the preference so we can detect changes.
  String _preferenceKey(UserPreferenceEntity pref) {
    final themes = (List<String>.from(pref.foodThemes)..sort()).join(',');
    return '${themes}|${pref.mealTime}|${pref.course}|${pref.halalOnly}|${pref.additionalNotes.trim()}';
  }

  /// Returns cached JSON only if date AND preference fingerprint both match.
  Future<String?> getCachedJson({UserPreferenceEntity? preference}) async {
    final json = await _db.getCachedRecommendation(_todayKey());
    if (json == null) return null;
    if (preference != null) {
      final cachedPrefKey = await _db.getCachedPreferenceKey();
      if (cachedPrefKey != _preferenceKey(preference)) return null;
    }
    return json;
  }

  Future<void> cacheJson(String json, {UserPreferenceEntity? preference}) async {
    await _db.cacheRecommendation(json, _todayKey());
    if (preference != null) {
      await _db.cachePreferenceKey(_preferenceKey(preference));
    }
  }

  Future<void> clearCache() async {
    await _db.clearRecommendationCache();
  }
}
