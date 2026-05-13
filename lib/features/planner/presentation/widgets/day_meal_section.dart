import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import 'meal_item_card.dart';

class MealEntry {
  const MealEntry({
    required this.mealType,
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    required this.tag,
    required this.tagColor,
  });
  final String mealType;
  final String title;
  final String imageUrl;
  final String prepTime;
  final String tag;
  final Color tagColor;
}

class DayMealSection extends StatelessWidget {
  const DayMealSection({
    super.key,
    required this.dayName,
    required this.meals,
    this.onAdjust,
  });

  final String dayName;
  final List<MealEntry> meals;
  final VoidCallback? onAdjust;

  static MealEntry meal({
    required String mealType,
    required String title,
    required String imageUrl,
    required String prepTime,
    required String tag,
    required Color tagColor,
  }) =>
      MealEntry(
        mealType: mealType,
        title: title,
        imageUrl: imageUrl,
        prepTime: prepTime,
        tag: tag,
        tagColor: tagColor,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dayName, style: AppTextStyles.headlineSmall),
            GestureDetector(
              onTap: onAdjust,
              child: const Icon(Icons.tune_rounded, color: AppColors.secondary, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Meal cards
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            children: List.generate(meals.length, (index) {
              final meal = meals[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecipeDetailPage(),
                        ),
                      ),
                      child: MealItemCard(
                        mealType: meal.mealType,
                        title: meal.title,
                        imageUrl: meal.imageUrl,
                        prepTime: meal.prepTime,
                        tag: meal.tag,
                        tagColor: meal.tagColor,
                      ),
                    ),
                  ),
                  if (index < meals.length - 1)
                    const Divider(height: 1, indent: 12, endIndent: 12),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
