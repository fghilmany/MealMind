import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_preference_entity.dart';

class PreferenceLocalDataSource {
  static const _boxName = 'user_preferences';
  static const _keyPreference = 'preference';

  Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  Future<UserPreferenceEntity> getPreference() async {
    final box = await _box();
    final raw = box.get(_keyPreference) as String?;
    if (raw == null) return const UserPreferenceEntity();
    try {
      return UserPreferenceEntity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserPreferenceEntity();
    }
  }

  Future<void> savePreference(UserPreferenceEntity preference) async {
    final box = await _box();
    await box.put(_keyPreference, jsonEncode(preference.toJson()));
  }
}
