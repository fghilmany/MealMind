import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class QuickSuggestionChips extends StatelessWidget {
  const QuickSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = suggestions[index];
          return GestureDetector(
            onTap: () => onSelected(label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.neutral300),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
