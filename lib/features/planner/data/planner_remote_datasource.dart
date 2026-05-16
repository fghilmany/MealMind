import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import '../domain/planner_entities.dart';
import '../domain/planner_preference_entity.dart';
import 'planner_prompts.dart';

class PlannerRemoteDataSource {
  Future<PlannerPlanEntity> generatePlan(PlannerPreferenceEntity preference) async {
    final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
    final response = await model.generateContent([
      Content.text(PlannerPrompts.generatePlan(preference)),
    ]);

    final raw = response.text ?? '';
    // ignore: avoid_print
    print('=== PLANNER AI RESPONSE ===\n$raw\n===========================');

    final cleaned = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
    final days = (decoded['days'] as List)
        .map((d) => PlannerDayEntity.fromJson(d as Map<String, dynamic>))
        .toList();

    return PlannerPlanEntity(days: days);
  }
}
