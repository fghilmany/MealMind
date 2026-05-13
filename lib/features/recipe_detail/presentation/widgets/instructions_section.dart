import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class InstructionStep {
  const InstructionStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  final int stepNumber;
  final String title;
  final String description;
  final String? imageUrl;
}

class InstructionsSection extends StatelessWidget {
  const InstructionsSection({super.key, required this.steps});

  final List<InstructionStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructions', style: AppTextStyles.titleLarge),
        const SizedBox(height: 20),
        ...steps.map((step) => _StepItem(step: step)),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step});

  final InstructionStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number + title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${step.stepNumber}',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(step.title, style: AppTextStyles.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            step.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          // Optional image
          if (step.imageUrl != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                step.imageUrl!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: AppColors.neutral200,
                  child: const Icon(Icons.restaurant, size: 48, color: AppColors.neutral400),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
