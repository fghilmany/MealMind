import 'package:equatable/equatable.dart';

class NutritionEntity extends Equatable {
  const NutritionEntity({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final String calories;
  final String protein;
  final String carbs;
  final String fat;

  @override
  List<Object?> get props => [calories, protein, carbs, fat];
}

class RecipeStepEntity extends Equatable {
  const RecipeStepEntity({required this.stepNumber, required this.description});

  final int stepNumber;
  final String description;

  @override
  List<Object?> get props => [stepNumber, description];
}

class MealEntity extends Equatable {
  const MealEntity({
    required this.mealType,
    required this.title,
    required this.category,
    required this.rating,
    required this.whyYoullLoveIt,
    required this.prepTime,
    required this.servings,
    required this.badges,
    required this.ingredients,
    required this.nutrition,
    required this.steps,
  });

  final String mealType;
  final String title;
  final String category;
  final double rating;
  final String whyYoullLoveIt;
  final String prepTime;
  final String servings;
  final List<String> badges;
  final List<String> ingredients;
  final NutritionEntity nutrition;
  final List<RecipeStepEntity> steps;

  @override
  List<Object?> get props => [mealType, title, category, rating];
}

class HeroDetailEntity extends Equatable {
  const HeroDetailEntity({
    required this.prepTime,
    required this.servings,
    required this.badges,
    required this.ingredients,
    required this.nutrition,
    required this.steps,
  });

  final String prepTime;
  final String servings;
  final List<String> badges;
  final List<String> ingredients;
  final NutritionEntity nutrition;
  final List<RecipeStepEntity> steps;

  @override
  List<Object?> get props => [prepTime, servings];
}

class HeroEntity extends Equatable {
  const HeroEntity({
    required this.title,
    required this.prepTime,
    required this.badge,
    required this.detail,
  });

  final String title;
  final String prepTime;
  final String badge;
  final HeroDetailEntity detail;

  @override
  List<Object?> get props => [title, prepTime];
}

class RecommendationEntity extends Equatable {
  const RecommendationEntity({
    required this.greeting,
    required this.subtitle,
    required this.hero,
    required this.meals,
  });

  final String greeting;
  final String subtitle;
  final HeroEntity hero;
  final List<MealEntity> meals;

  @override
  List<Object?> get props => [greeting, subtitle, hero, meals];
}
