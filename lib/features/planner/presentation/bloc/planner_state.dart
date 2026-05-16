import 'package:equatable/equatable.dart';
import '../../domain/planner_entities.dart';

abstract class PlannerState extends Equatable {
  const PlannerState();
  @override
  List<Object?> get props => [];
}

class PlannerInitial extends PlannerState {
  const PlannerInitial();
}

class PlannerLoading extends PlannerState {
  const PlannerLoading();
}

class PlannerLoaded extends PlannerState {
  const PlannerLoaded(this.plan);
  final PlannerPlanEntity plan;
  @override
  List<Object?> get props => [plan];
}

class PlannerError extends PlannerState {
  const PlannerError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
