import '../../domain/entities/recommendation_entity.dart';

class NutritionModel extends NutritionEntity {
  const NutritionModel({
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) => NutritionModel(
        calories: json['calories'] as String? ?? '0',
        protein: json['protein'] as String? ?? '0g',
        carbs: json['carbs'] as String? ?? '0g',
        fat: json['fat'] as String? ?? '0g',
      );
}

class RecipeStepModel extends RecipeStepEntity {
  const RecipeStepModel({required super.stepNumber, required super.description});

  factory RecipeStepModel.fromRaw(int index, String description) =>
      RecipeStepModel(stepNumber: index + 1, description: description);
}

class MealModel extends MealEntity {
  const MealModel({
    required super.mealType,
    required super.title,
    required super.category,
    required super.rating,
    required super.whyYoullLoveIt,
    required super.prepTime,
    required super.servings,
    required super.badges,
    required super.ingredients,
    required super.nutrition,
    required super.steps,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as String? ?? 'Nusantara';
    final stepsRaw = json['steps'] as List<dynamic>? ?? [];
    final ingredientsRaw = json['ingredients'] as List<dynamic>? ?? [];
    final badgesRaw = json['badges'] as List<dynamic>? ?? [category];
    final nutritionJson = json['nutrition'] as Map<String, dynamic>? ?? {};

    return MealModel(
      mealType: json['mealType'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: category,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      whyYoullLoveIt: json['whyYoullLoveIt'] as String? ?? '',
      prepTime: json['prepTime'] as String? ?? '30 Menit',
      servings: json['servings'] as String? ?? '2 Porsi',
      badges: badgesRaw.map((e) => e as String).toList(),
      ingredients: ingredientsRaw.map((e) => e as String).toList(),
      nutrition: NutritionModel.fromJson(nutritionJson),
      steps: stepsRaw
          .asMap()
          .entries
          .map((e) => RecipeStepModel.fromRaw(e.key, e.value as String? ?? ''))
          .toList(),
    );
  }
}

class HeroDetailModel extends HeroDetailEntity {
  const HeroDetailModel({
    required super.prepTime,
    required super.servings,
    required super.badges,
    required super.ingredients,
    required super.nutrition,
    required super.steps,
  });

  factory HeroDetailModel.fromJson(Map<String, dynamic> json, String fallbackPrepTime) {
    final stepsRaw = json['steps'] as List<dynamic>? ?? [];
    final ingredientsRaw = json['ingredients'] as List<dynamic>? ?? [];
    final badgesRaw = json['badges'] as List<dynamic>? ?? [];
    final nutritionJson = json['nutrition'] as Map<String, dynamic>? ?? {};

    return HeroDetailModel(
      prepTime: json['prepTime'] as String? ?? fallbackPrepTime,
      servings: json['servings'] as String? ?? '2 Porsi',
      badges: badgesRaw.map((e) => e as String).toList(),
      ingredients: ingredientsRaw.map((e) => e as String).toList(),
      nutrition: NutritionModel.fromJson(nutritionJson),
      steps: stepsRaw
          .asMap()
          .entries
          .map((e) => RecipeStepModel.fromRaw(e.key, e.value as String? ?? ''))
          .toList(),
    );
  }
}

class HeroModel extends HeroEntity {
  const HeroModel({
    required super.title,
    required super.prepTime,
    required super.badge,
    required super.detail,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    final detailJson = json['detail'] as Map<String, dynamic>? ?? {};
    final prepTime = json['prepTime'] as String? ?? '20 Menit';

    return HeroModel(
      title: json['title'] as String? ?? '',
      prepTime: prepTime,
      badge: json['badge'] as String? ?? 'Pilihan Terbaik AI',
      detail: HeroDetailModel.fromJson(detailJson, prepTime),
    );
  }
}

class RecommendationModel extends RecommendationEntity {
  const RecommendationModel({
    required super.greeting,
    required super.subtitle,
    required super.hero,
    required super.meals,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    final heroJson = json['hero'] as Map<String, dynamic>? ?? {};
    final recsJson = json['recommendations'] as List<dynamic>? ?? [];

    return RecommendationModel(
      greeting: json['greeting'] as String? ?? 'Selamat Datang!',
      subtitle: json['subtitle'] as String? ?? '',
      hero: HeroModel.fromJson(heroJson),
      meals: recsJson.map((e) => MealModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
