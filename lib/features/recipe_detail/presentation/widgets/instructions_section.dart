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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${step.stepNumber}',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Instruction text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                step.description,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
