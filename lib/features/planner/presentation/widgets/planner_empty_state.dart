import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class PlannerEmptyState extends StatelessWidget {
  const PlannerEmptyState({super.key, this.onGenerate});

  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No meals planned yet',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Let AI generate a personalized weekly meal plan for you based on your preferences.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Generate My Week',
              icon: Icons.auto_awesome_outlined,
              isFullWidth: true,
              onPressed: onGenerate,
            ),
          ],
        ),
      ),
    );
  }
}
