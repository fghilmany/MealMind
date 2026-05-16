import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  @override
  Future<RecommendationEntity> getRecommendations({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _localDataSource.getCachedJson();
      if (cached != null) return parseRecommendationJson(cached);
    }

    final json = await _remoteDataSource.fetchRecommendationsJson();
    await _localDataSource.cacheJson(json);
    return parseRecommendationJson(json);
  }
}
