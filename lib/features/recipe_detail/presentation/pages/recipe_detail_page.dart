import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/recipe_hero_section.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/nutrition_facts_section.dart';
import '../widgets/instructions_section.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

class RecipeNutrition {
  const RecipeNutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
}

class RecipeData {
  const RecipeData({
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    required this.servings,
    required this.badges,
    required this.ingredients,
    required this.nutrition,
    required this.steps,
  });
  final String title;
  final String imageUrl;
  final String prepTime;
  final String servings;
  final List<String> badges;
  final List<String> ingredients;
  final RecipeNutrition nutrition;
  final List<InstructionStep> steps;

  // Fallback dummy data
  static const RecipeData dummy = RecipeData(
    title: 'Authentic Thai\nGreen Curry',
    imageUrl:
        'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&auto=format&fit=crop',
    prepTime: '45 Menit',
    servings: '4 Porsi',
    badges: ['Sehat', 'Nusantara'],
    ingredients: [
      '400ml Santan Full-fat',
      '3 sdm Pasta Kari Hijau',
      '300g Dada Ayam (iris tipis)',
      '1 cangkir Rebung',
      'Daun Kemangi & Jeruk Nipis',
    ],
    nutrition: RecipeNutrition(
      calories: '450',
      protein: '32g',
      carbs: '12g',
      fat: '28g',
    ),
    steps: [
      InstructionStep(
        stepNumber: 1,
        title: 'Tumis Pasta',
        description:
            'Panaskan minyak di wajan, tumis pasta kari hijau selama 2 menit hingga harum.',
        imageUrl:
            'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800&auto=format&fit=crop',
      ),
      InstructionStep(
        stepNumber: 2,
        title: 'Buat Kuah',
        description:
            'Tuangkan santan perlahan sambil diaduk. Masak dengan api kecil hingga mendidih ringan.',
      ),
      InstructionStep(
        stepNumber: 3,
        title: 'Masak & Sajikan',
        description:
            'Masukkan ayam dan rebung. Masak 8–10 menit hingga ayam matang. Tambahkan kemangi dan perasan jeruk nipis sebelum disajikan.',
      ),
    ],
  );
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, this.recipe});

  final RecipeData? recipe;

  @override
  Widget build(BuildContext context) {
    final data = recipe ?? RecipeData.dummy;
    final badgeColors = [AppColors.primary, AppColors.secondary, AppColors.info];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: RecipeHeroSection(
                    title: data.title,
                    imageUrl: data.imageUrl,
                    prepTime: data.prepTime,
                    servings: data.servings,
                    calories: data.nutrition.calories,
                    badges: data.badges
                        .asMap()
                        .entries
                        .map((e) => RecipeBadge(
                              label: e.value,
                              color: badgeColors[e.key % badgeColors.length],
                            ))
                        .toList(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IngredientsSection(
                          ingredients: data.ingredients,
                          onAdjustServings: () {},
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),
                        NutritionFactsSection(
                          calories: data.nutrition.calories,
                          protein: data.nutrition.protein,
                          carbs: data.nutrition.carbs,
                          fat: data.nutrition.fat,
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),
                        InstructionsSection(steps: data.steps),
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
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Mulai Memasak'),
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
