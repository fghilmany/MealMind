import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NutritionFactsSection extends StatelessWidget {
  const NutritionFactsSection({
    super.key,
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nutrition Facts', style: AppTextStyles.titleLarge),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _NutritionTile(value: calories, label: 'Calories', color: AppColors.primary),
            _NutritionTile(value: protein, label: 'Protein', color: AppColors.primary),
            _NutritionTile(value: carbs, label: 'Carbs', color: AppColors.secondary),
            _NutritionTile(value: fat, label: 'Fat', color: AppColors.secondary),
          ],
        ),
      ],
    );
  }
}

class _NutritionTile extends StatelessWidget {
  const _NutritionTile({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
