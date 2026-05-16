import 'package:equatable/equatable.dart';
import '../../domain/planner_preference_entity.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();
  @override
  List<Object?> get props => [];
}

class LoadSavedPlanEvent extends PlannerEvent {
  const LoadSavedPlanEvent();
}

class GeneratePlanEvent extends PlannerEvent {
  const GeneratePlanEvent(this.preference);
  final PlannerPreferenceEntity preference;
  @override
  List<Object?> get props => [preference];
}
