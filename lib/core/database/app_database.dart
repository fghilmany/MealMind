import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  AppDatabase._();

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  static const _boxName = 'recommendation_cache';
  static const _keyJson = 'json';
  static const _keyDate = 'date';

  Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  Future<String?> getCachedRecommendation(String dateKey) async {
    final box = await _box();
    final storedDate = box.get(_keyDate) as String?;
    if (storedDate != dateKey) return null;
    return box.get(_keyJson) as String?;
  }

  Future<void> cacheRecommendation(String json, String dateKey) async {
    final box = await _box();
    await box.put(_keyJson, json);
    await box.put(_keyDate, dateKey);
  }

  Future<void> clearRecommendationCache() async {
    final box = await _box();
    await box.delete(_keyJson);
    await box.delete(_keyDate);
  }
}
