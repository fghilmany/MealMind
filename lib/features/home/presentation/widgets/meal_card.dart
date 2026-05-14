import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    required this.rating,
    required this.whyYoullLoveIt,
    this.mealType,
    this.onTap,
  });

  final String title;
  final String category;
  final Color categoryColor;
  final String imageUrl;
  final double rating;
  final String whyYoullLoveIt;
  final String? mealType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rating badge
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.neutral200,
                      child: const Icon(Icons.restaurant, size: 48, color: AppColors.neutral400),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MealType pill (Sarapan / Makan Siang / Makan Malam)
                  if (mealType != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        mealType!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Category label
                  Text(
                    category.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  // Why you'll love it
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.favorite_outline_rounded,
                                      size: 13, color: AppColors.neutral500),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Why you\'ll love it:',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                whyYoullLoveIt,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
