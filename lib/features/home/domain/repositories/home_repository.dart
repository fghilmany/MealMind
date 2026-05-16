import '../entities/recommendation_entity.dart';
import '../entities/user_preference_entity.dart';

abstract class HomeRepository {
  Future<RecommendationEntity> getRecommendations({
    bool forceRefresh = false,
    UserPreferenceEntity? preference,
  });
}
