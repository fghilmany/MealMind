import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class IngredientsSection extends StatefulWidget {
  const IngredientsSection({
    super.key,
    required this.ingredients,
    this.onAdjustServings,
  });

  final List<String> ingredients;
  final VoidCallback? onAdjustServings;

  @override
  State<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.ingredients.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ingredients', style: AppTextStyles.titleLarge),
            GestureDetector(
              onTap: widget.onAdjustServings,
              child: Text(
                'Adjust Servings',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Ingredient list
        ...List.generate(widget.ingredients.length, (index) {
          return GestureDetector(
            onTap: () => setState(() => _checked[index] = !_checked[index]),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _checked[index]
                            ? AppColors.primary
                            : AppColors.neutral400,
                        width: 1.5,
                      ),
                      color: _checked[index]
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: _checked[index]
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.ingredients[index],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _checked[index]
                            ? AppColors.textDisabled
                            : AppColors.textPrimary,
                        decoration: _checked[index]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
