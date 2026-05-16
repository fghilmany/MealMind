import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getRecommendations) : super(const HomeInitial()) {
    on<FetchRecommendationsEvent>(_onFetchRecommendations);
  }

  final GetRecommendationsUseCase _getRecommendations;

  Future<void> _onFetchRecommendations(
    FetchRecommendationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final result = await _getRecommendations(forceRefresh: event.forceRefresh);
      emit(HomeLoaded(result));
    } catch (e, st) {
      // ignore: avoid_print
      print('HomeBloc error: $e\n$st');
      emit(HomeError(e.toString()));
    }
  }
}
