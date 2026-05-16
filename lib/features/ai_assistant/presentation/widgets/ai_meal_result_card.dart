import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class AiMealResultCard extends StatelessWidget {
  const AiMealResultCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.tags,
    this.onApply,
    this.onRevise,
    this.onFavorite,
    this.onViewDetail,
  });

  final String title;
  final String imageUrl;
  final List<MealTag> tags;
  final VoidCallback? onApply;
  final VoidCallback? onRevise;
  final VoidCallback? onFavorite;
  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.neutral200,
                child: const Icon(Icons.restaurant, size: 48, color: AppColors.neutral400),
              ),
            ),
          ),
          // Card content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(title, style: AppTextStyles.headlineSmall),
                    ),
                    GestureDetector(
                      onTap: onFavorite,
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.neutral500,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tags row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: tags.map((tag) => _TagPill(tag: tag)).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                // View detail button
                if (onViewDetail != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onViewDetail,
                      icon: const Icon(Icons.menu_book_rounded, size: 16),
                      label: const Text('Lihat Detail Resep'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onApply,
                        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                        label: const Text('Apply to Plan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRevise,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text('Revise Further'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealTag {
  const MealTag({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.tag});
  final MealTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.icon != null) ...[
            Icon(tag.icon, size: 13, color: tag.color),
            const SizedBox(width: 4),
          ],
          Text(
            tag.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: tag.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
