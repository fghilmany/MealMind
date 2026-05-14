import '../entities/recommendation_entity.dart';
import '../repositories/home_repository.dart';

class GetRecommendationsUseCase {
  const GetRecommendationsUseCase(this._repository);

  final HomeRepository _repository;

  Future<RecommendationEntity> call() => _repository.getRecommendations();
}
