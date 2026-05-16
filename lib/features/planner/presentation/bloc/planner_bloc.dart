import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/planner_local_datasource.dart';
import '../../data/planner_remote_datasource.dart';
import 'planner_event.dart';
import 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc(this._remoteDataSource, this._localDataSource)
      : super(const PlannerInitial()) {
    on<LoadSavedPlanEvent>(_onLoadSaved);
    on<GeneratePlanEvent>(_onGenerate);
    add(const LoadSavedPlanEvent());
  }

  final PlannerRemoteDataSource _remoteDataSource;
  final PlannerLocalDataSource _localDataSource;

  Future<void> _onLoadSaved(
    LoadSavedPlanEvent event,
    Emitter<PlannerState> emit,
  ) async {
    final saved = await _localDataSource.loadPlan();
    if (saved != null) emit(PlannerLoaded(saved));
  }

  Future<void> _onGenerate(
    GeneratePlanEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(const PlannerLoading());
    try {
      final plan = await _remoteDataSource.generatePlan(event.preference);
      await _localDataSource.savePlan(plan);
      emit(PlannerLoaded(plan));
    } catch (e, st) {
      // ignore: avoid_print
      print('PlannerBloc error: $e\n$st');
      emit(PlannerError(e.toString()));
    }
  }
}
