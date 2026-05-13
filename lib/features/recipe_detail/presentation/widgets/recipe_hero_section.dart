import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RecipeHeroSection extends StatelessWidget {
  const RecipeHeroSection({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    required this.servings,
    required this.calories,
    required this.badges,
  });

  final String title;
  final String imageUrl;
  final String prepTime;
  final String servings;
  final String calories;
  final List<RecipeBadge> badges;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.neutral300,
              child: const Icon(Icons.restaurant, size: 64, color: AppColors.neutral500),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.3, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges
                Row(
                  children: badges
                      .map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _HeroBadge(badge: b),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                // Meta row
                Row(
                  children: [
                    _MetaItem(icon: Icons.schedule_outlined, label: prepTime),
                    const SizedBox(width: 16),
                    _MetaItem(icon: Icons.restaurant_outlined, label: servings),
                  ],
                ),
                const SizedBox(height: 6),
                _MetaItem(icon: Icons.local_fire_department_outlined, label: calories),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeBadge {
  const RecipeBadge({required this.label, required this.color});
  final String label;
  final Color color;
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.badge});
  final RecipeBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badge.color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        badge.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white70),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
