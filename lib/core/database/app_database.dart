import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  AppDatabase._();

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  static const _boxName = 'recommendation_cache';
  static const _keyJson = 'json';
  static const _keyDate = 'date';
  static const _keyPrefKey = 'pref_key';

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

  Future<String?> getCachedPreferenceKey() async {
    final box = await _box();
    return box.get(_keyPrefKey) as String?;
  }

  Future<void> cachePreferenceKey(String prefKey) async {
    final box = await _box();
    await box.put(_keyPrefKey, prefKey);
  }

  Future<void> clearRecommendationCache() async {
    final box = await _box();
    await box.delete(_keyJson);
    await box.delete(_keyDate);
    await box.delete(_keyPrefKey);
  }
}
