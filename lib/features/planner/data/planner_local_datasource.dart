import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/planner_entities.dart';

class PlannerLocalDataSource {
  static const _boxName = 'planner_cache';
  static const _keyPlan = 'plan';

  Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  Future<PlannerPlanEntity?> loadPlan() async {
    final box = await _box();
    final raw = box.get(_keyPlan) as String?;
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final days = (decoded['days'] as List)
          .map((d) => PlannerDayEntity.fromJson(d as Map<String, dynamic>))
          .toList();
      return PlannerPlanEntity(days: days);
    } catch (_) {
      return null;
    }
  }

  Future<void> savePlan(PlannerPlanEntity plan) async {
    final box = await _box();
    final json = jsonEncode({
      'days': plan.days
          .map((d) => {
                'day': d.day,
                'meals': d.meals
                    .map((m) => {
                          'mealType': m.mealType,
                          'title': m.title,
                          'category': m.category,
                          'prepTime': m.prepTime,
                          'calories': m.calories,
                        })
                    .toList(),
              })
          .toList(),
    });
    await box.put(_keyPlan, json);
  }

  Future<void> clearPlan() async {
    final box = await _box();
    await box.delete(_keyPlan);
  }
}
