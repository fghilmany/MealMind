import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/recipe_hero_section.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/nutrition_facts_section.dart';
import '../widgets/instructions_section.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  static final List<String> _ingredients = const [
    '400ml Full-fat Coconut Milk',
    '3 tbsp Green Curry Paste',
    '300g Chicken Breast (sliced)',
    '1 cup Bamboo Shoots',
    'Fresh Thai Basil & Lime',
  ];

  static final List<InstructionStep> _steps = const [
    InstructionStep(
      stepNumber: 1,
      title: 'Bloom the Paste',
      description:
          'Heat a tablespoon of oil in a large pan over medium heat. Add the green curry paste and sauté for about 2 minutes. This crucial step "blooms" the spices, releasing their full aromatic potential and essential oils into the pan.',
      imageUrl:
          'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800&auto=format&fit=crop',
    ),
    InstructionStep(
      stepNumber: 2,
      title: 'Build the Broth',
      description:
          'Slowly pour in the coconut milk while stirring continuously to blend it smoothly with the bloomed paste. Bring the mixture to a gentle simmer. Do not let it boil rapidly to prevent the coconut milk from splitting.',
    ),
    InstructionStep(
      stepNumber: 3,
      title: 'Simmer & Serve',
      description:
          'Add the sliced chicken breast and bamboo shoots to the simmering broth. Cook for 8–10 minutes until the chicken is cooked through. Remove from heat and stir in fresh basil leaves and a squeeze of lime juice right before serving.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Scrollable content
            CustomScrollView(
              slivers: [
                // Hero image sliver
                SliverToBoxAdapter(
                  child: RecipeHeroSection(
                    title: 'Authentic Thai\nGreen Curry',
                    imageUrl:
                        'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&auto=format&fit=crop',
                    prepTime: '45 Min',
                    servings: '4 Servings',
                    calories: '450 kcal',
                    badges: const [
                      RecipeBadge(label: 'Dairy-Free', color: AppColors.primary),
                      RecipeBadge(label: 'Spicy', color: AppColors.secondary),
                    ],
                  ),
                ),
                // Back button overlay
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IngredientsSection(
                          ingredients: _ingredients,
                          onAdjustServings: () {},
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),
                        const NutritionFactsSection(
                          calories: '450',
                          protein: '32g',
                          carbs: '12g',
                          fat: '28g',
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),
                        InstructionsSection(steps: _steps),
                        // Bottom padding for FAB
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        // Start Cooking Mode FAB
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Start Cooking Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neutral,
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
