import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HeroMealCard extends StatelessWidget {
  const HeroMealCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    this.badge = "Chef's Pick",
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final String prepTime;
  final String badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.neutral200,
                  child: const Icon(Icons.restaurant, size: 48, color: AppColors.neutral400),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              // Badges top-left
              Positioned(
                top: 14,
                left: 14,
                child: Row(
                  children: [
                    _Badge(
                      label: badge,
                      icon: Icons.restaurant_menu,
                      backgroundColor: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      label: '$prepTime Min Prep',
                      backgroundColor: Colors.black54,
                    ),
                  ],
                ),
              ),
              // Title bottom-left
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.icon,
    required this.backgroundColor,
  });

  final String label;
  final IconData? icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
