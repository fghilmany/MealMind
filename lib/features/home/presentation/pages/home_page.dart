import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../widgets/hero_meal_card.dart';
import '../widgets/meal_card.dart';

class _CravingFilter {
  const _CravingFilter(this.label, this.color);
  final String label;
  final Color color;
}

class _MealItem {
  const _MealItem({
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    required this.rating,
    required this.whyYoullLoveIt,
  });
  final String title;
  final String category;
  final Color categoryColor;
  final String imageUrl;
  final double rating;
  final String whyYoullLoveIt;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCraving = 0;

  final List<_CravingFilter> _cravingFilters = const [
    _CravingFilter('All', AppColors.primary),
    _CravingFilter('Nusantara', AppColors.secondary),
    _CravingFilter('Western', Color(0xFF1E88E5)),
    _CravingFilter('Thai', Color(0xFFE53935)),
  ];

  final List<_MealItem> _meals = const [
    _MealItem(
      title: 'Ayam Betutu Modernist',
      category: 'Nusantara',
      categoryColor: AppColors.secondary,
      imageUrl:
          'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&auto=format&fit=crop',
      rating: 4.9,
      whyYoullLoveIt:
          'Rich, slow-roasted spices balanced with a fresh lemongrass sambal that perfectly satisfies savory cravings without heaviness.',
    ),
    _MealItem(
      title: 'Zesty Green Curry Bowl',
      category: 'Thai',
      categoryColor: Color(0xFFE53935),
      imageUrl:
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&auto=format&fit=crop',
      rating: 4.8,
      whyYoullLoveIt:
          'A fragrant burst of basil and coconut milk that delivers immediate comfort, paired with lean protein for sustained afternoon energy.',
    ),
    _MealItem(
      title: 'Mediterranean Sear',
      category: 'Western',
      categoryColor: Color(0xFF1E88E5),
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&auto=format&fit=crop',
      rating: 4.7,
      whyYoullLoveIt:
          'Incredibly fast to prep. The sharp balsamic reduction cuts through the savory chicken, making every bite feel like a premium dining experience.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
      title: Text(
        'MealMind',
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: AppColors.neutral700),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.neutral200,
              child: Icon(Icons.person_outline, size: 20, color: AppColors.neutral600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Greeting
          Text('Good morning, Chef!', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text(
            "Here are today's fresh ideas to fuel your vitality.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          // Hero card
          HeroMealCard(
            title: 'Vitality Salmon &\nQuinoa Bowl',
            imageUrl:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&auto=format&fit=crop',
            prepTime: '25',
            badge: "Chef's Pick",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeDetailPage()),
            ),
          ),
          const SizedBox(height: 28),
          // Section title
          Text('Explore by Craving', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          // Craving filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_cravingFilters.length, (index) {
                final filter = _cravingFilters[index];
                final isSelected = _selectedCraving == index;
                return Padding(
                  padding: EdgeInsets.only(right: index < _cravingFilters.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCraving = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? filter.color : AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: isSelected ? filter.color : AppColors.neutral300,
                        ),
                      ),
                      child: Text(
                        filter.label,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          // Meal cards
          ..._meals.map(
            (meal) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MealCard(
                title: meal.title,
                category: meal.category,
                categoryColor: meal.categoryColor,
                imageUrl: meal.imageUrl,
                rating: meal.rating,
                whyYoullLoveIt: meal.whyYoullLoveIt,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipeDetailPage()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Refine preferences button
          AppButton(
            label: 'Refine Preferences',
            variant: AppButtonVariant.inverted,
            icon: Icons.tune_rounded,
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
