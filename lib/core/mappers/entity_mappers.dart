import '../../features/recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../features/recipe_detail/presentation/widgets/instructions_section.dart';
import '../../features/home/domain/entities/recommendation_entity.dart';

extension NutritionEntityMapper on NutritionEntity {
  RecipeNutrition toRecipeNutrition() => RecipeNutrition(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
}

extension RecipeStepEntityMapper on RecipeStepEntity {
  InstructionStep toInstructionStep() => InstructionStep(
        stepNumber: stepNumber,
        title: '',
        description: description,
      );
}

extension HeroDetailEntityMapper on HeroDetailEntity {
  RecipeData toRecipeData(String title, String imageUrl) => RecipeData(
        title: title,
        imageUrl: imageUrl,
        prepTime: prepTime,
        servings: servings,
        badges: badges,
        ingredients: ingredients,
        nutrition: nutrition.toRecipeNutrition(),
        steps: steps.map((s) => s.toInstructionStep()).toList(),
      );
}

extension MealEntityMapper on MealEntity {
  RecipeData toRecipeData(String imageUrl) => RecipeData(
        title: title,
        imageUrl: imageUrl,
        prepTime: prepTime,
        servings: servings,
        badges: badges,
        ingredients: ingredients,
        nutrition: nutrition.toRecipeNutrition(),
        steps: steps.map((s) => s.toInstructionStep()).toList(),
      );
}
