import '../entities/recommendation_entity.dart';

abstract class HomeRepository {
  Future<RecommendationEntity> getRecommendations();
}
