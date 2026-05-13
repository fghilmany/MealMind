import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MealItemCard extends StatelessWidget {
  const MealItemCard({
    super.key,
    required this.mealType,
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    required this.tag,
    required this.tagColor,
    this.onTap,
  });

  final String mealType;
  final String title;
  final String imageUrl;
  final String prepTime;
  final String tag;
  final Color tagColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.neutral200,
                    child: const Icon(Icons.restaurant, color: AppColors.neutral400),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: AppTextStyles.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Prep time pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          prepTime,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.neutral700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cuisine tag pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: tagColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
