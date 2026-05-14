import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<RecommendationEntity> getRecommendations() async {
    return await _remoteDataSource.getRecommendations();
  }
}
