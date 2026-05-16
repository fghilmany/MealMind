import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import '../models/recommendation_model.dart';
import '../home_prompts.dart';

abstract class HomeRemoteDataSource {
  Future<String> fetchRecommendationsJson();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl();

  @override
  Future<String> fetchRecommendationsJson() async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
      final response = await model.generateContent([Content.text(HomePrompts.recommendation)]);
      final raw = response.text ?? '';

      // ignore: avoid_print
      print('=== AI RAW RESPONSE ===\n$raw\n=======================');

      final cleaned = raw
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      // Validate JSON before returning
      jsonDecode(cleaned);
      return cleaned;
    } catch (e, st) {
      // ignore: avoid_print
      print('fetchRecommendationsJson error: $e\n$st');
      rethrow;
    }
  }
}

RecommendationModel parseRecommendationJson(String json) {
  final decoded = jsonDecode(json) as Map<String, dynamic>;
  return RecommendationModel.fromJson(decoded);
}
