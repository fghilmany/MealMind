import 'package:equatable/equatable.dart';
import '../../domain/entities/user_preference_entity.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationsEvent extends HomeEvent {
  const FetchRecommendationsEvent({
    this.forceRefresh = false,
    this.preference,
  });

  final bool forceRefresh;
  final UserPreferenceEntity? preference;

  @override
  List<Object?> get props => [forceRefresh, preference];
}
