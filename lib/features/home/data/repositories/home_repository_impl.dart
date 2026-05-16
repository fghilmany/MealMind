import '../../domain/entities/recommendation_entity.dart';
import '../../domain/entities/user_preference_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../datasources/preference_local_datasource.dart';
import '../datasources/home_remote_datasource.dart' show parseRecommendationJson;

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._preferenceDataSource,
  );

  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;
  final PreferenceLocalDataSource _preferenceDataSource;

  @override
  Future<RecommendationEntity> getRecommendations({
    bool forceRefresh = false,
    UserPreferenceEntity? preference,
  }) async {
    final pref = preference ?? await _preferenceDataSource.getPreference();

    if (!forceRefresh) {
      final cached = await _localDataSource.getCachedJson(preference: pref);
      if (cached != null) return parseRecommendationJson(cached);
    }

    final json = await _remoteDataSource.fetchRecommendationsJson(pref);
    await _localDataSource.cacheJson(json, preference: pref);
    return parseRecommendationJson(json);
  }
}
