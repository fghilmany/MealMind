import '../entities/recommendation_entity.dart';
import '../entities/user_preference_entity.dart';
import '../repositories/home_repository.dart';

class GetRecommendationsUseCase {
  const GetRecommendationsUseCase(this._repository);

  final HomeRepository _repository;

  Future<RecommendationEntity> call({
    bool forceRefresh = false,
    UserPreferenceEntity? preference,
  }) =>
      _repository.getRecommendations(
        forceRefresh: forceRefresh,
        preference: preference,
      );
}
