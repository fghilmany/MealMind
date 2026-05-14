import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import '../models/recommendation_model.dart';
import '../home_prompts.dart';

abstract class HomeRemoteDataSource {
  Future<RecommendationModel> getRecommendations();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl();

  @override
  Future<RecommendationModel> getRecommendations() async {
    final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
    final response = await model.generateContent([Content.text(HomePrompts.recommendation)]);
    final raw = response.text ?? '';

    final cleaned = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;
    return RecommendationModel.fromJson(json);
  }
}
