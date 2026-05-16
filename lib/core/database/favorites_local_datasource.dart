import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../features/recipe_detail/presentation/widgets/instructions_section.dart';

class FavoriteItem {
  const FavoriteItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.prepTime,
    required this.calories,
    required this.rating,
    required this.recipeData,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String prepTime;
  final String calories;
  final double rating;
  final RecipeData recipeData;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'category': category,
        'prepTime': prepTime,
        'calories': calories,
        'rating': rating,
        'recipe': {
          'title': recipeData.title,
          'imageUrl': recipeData.imageUrl,
          'prepTime': recipeData.prepTime,
          'servings': recipeData.servings,
          'badges': recipeData.badges,
          'ingredients': recipeData.ingredients,
          'nutrition': {
            'calories': recipeData.nutrition.calories,
            'protein': recipeData.nutrition.protein,
            'carbs': recipeData.nutrition.carbs,
            'fat': recipeData.nutrition.fat,
          },
          'steps': recipeData.steps
              .map((s) => {
                    'stepNumber': s.stepNumber,
                    'title': s.title,
                    'description': s.description,
                    'imageUrl': s.imageUrl,
                  })
              .toList(),
        },
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final r = json['recipe'] as Map<String, dynamic>;
    final nutrition = r['nutrition'] as Map<String, dynamic>;
    final steps = (r['steps'] as List)
        .map((s) => InstructionStep(
              stepNumber: s['stepNumber'] as int,
              title: s['title'] as String? ?? '',
              description: s['description'] as String,
              imageUrl: s['imageUrl'] as String?,
            ))
        .toList();

    return FavoriteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      prepTime: json['prepTime'] as String,
      calories: json['calories'] as String,
      rating: (json['rating'] as num).toDouble(),
      recipeData: RecipeData(
        title: r['title'] as String,
        imageUrl: r['imageUrl'] as String,
        prepTime: r['prepTime'] as String,
        servings: r['servings'] as String,
        badges: (r['badges'] as List).cast<String>(),
        ingredients: (r['ingredients'] as List).cast<String>(),
        nutrition: RecipeNutrition(
          calories: nutrition['calories'] as String,
          protein: nutrition['protein'] as String,
          carbs: nutrition['carbs'] as String,
          fat: nutrition['fat'] as String,
        ),
        steps: steps,
      ),
    );
  }
}

class FavoritesLocalDataSource {
  static const _boxName = 'favorites';

  /// Increments whenever favorites change. Listen to this for real-time updates.
  static final changesNotifier = ValueNotifier<int>(0);

  static void _notifyChange() => changesNotifier.value++;

  Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  Future<List<FavoriteItem>> getAll() async {
    final box = await _box();
    return box.values
        .map((v) => FavoriteItem.fromJson(jsonDecode(v as String) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isFavorite(String id) async {
    final box = await _box();
    return box.containsKey(id);
  }

  Future<void> add(FavoriteItem item) async {
    final box = await _box();
    await box.put(item.id, jsonEncode(item.toJson()));
    _notifyChange();
  }

  Future<void> remove(String id) async {
    final box = await _box();
    await box.delete(id);
    _notifyChange();
  }

  Future<void> toggle(FavoriteItem item) async {
    if (await isFavorite(item.id)) {
      await remove(item.id);
    } else {
      await add(item);
    }
  }
}
