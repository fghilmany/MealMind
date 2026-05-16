import 'package:equatable/equatable.dart';

class PlannerMealEntity extends Equatable {
  const PlannerMealEntity({
    required this.mealType,
    required this.title,
    required this.category,
    required this.prepTime,
    required this.calories,
  });

  final String mealType;
  final String title;
  final String category;
  final String prepTime;
  final String calories;

  factory PlannerMealEntity.fromJson(Map<String, dynamic> json) => PlannerMealEntity(
        mealType: json['mealType'] as String? ?? '',
        title: json['title'] as String? ?? '',
        category: json['category'] as String? ?? '',
        prepTime: json['prepTime'] as String? ?? '',
        calories: json['calories'] as String? ?? '',
      );

  @override
  List<Object?> get props => [mealType, title, category, prepTime, calories];
}

class PlannerDayEntity extends Equatable {
  const PlannerDayEntity({required this.day, required this.meals});

  final String day;
  final List<PlannerMealEntity> meals;

  factory PlannerDayEntity.fromJson(Map<String, dynamic> json) => PlannerDayEntity(
        day: json['day'] as String? ?? '',
        meals: (json['meals'] as List? ?? [])
            .map((m) => PlannerMealEntity.fromJson(m as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [day, meals];
}

class PlannerPlanEntity extends Equatable {
  const PlannerPlanEntity({required this.days});

  final List<PlannerDayEntity> days;

  @override
  List<Object?> get props => [days];
}
