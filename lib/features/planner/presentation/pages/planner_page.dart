import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/day_meal_section.dart';
import '../widgets/planner_empty_state.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  // Toggle this to preview empty state
  bool _hasData = true;

  // Sample weekly plan data
  final List<_DayPlan> _weeklyPlan = [
    _DayPlan(
      day: 'Monday',
      meals: [
        (
          mealType: 'Breakfast',
          title: 'Sourdough Avocado Toast',
          imageUrl:
              'https://images.unsplash.com/photo-1603046891740-2e0e2b2e1e5d?w=400&auto=format&fit=crop',
          prepTime: '15m',
          tag: 'Western',
          tagColor: AppColors.primary,
        ),
        (
          mealType: 'Lunch',
          title: 'Spicy Basil Chicken (Kra Pao)',
          imageUrl:
              'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400&auto=format&fit=crop',
          prepTime: '25m',
          tag: 'Thai',
          tagColor: AppColors.secondary,
        ),
        (
          mealType: 'Dinner',
          title: 'Lemon Garlic Seared Salmon',
          imageUrl:
              'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&auto=format&fit=crop',
          prepTime: '30m',
          tag: 'Pescatarian',
          tagColor: AppColors.primary,
        ),
      ],
    ),
    _DayPlan(
      day: 'Tuesday',
      meals: [
        (
          mealType: 'Breakfast',
          title: 'Mixed Berry Protein Parfait',
          imageUrl:
              'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&auto=format&fit=crop',
          prepTime: '5m',
          tag: 'Quick',
          tagColor: AppColors.primary,
        ),
        (
          mealType: 'Lunch',
          title: 'Heirloom Caprese Salad',
          imageUrl:
              'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5?w=400&auto=format&fit=crop',
          prepTime: '10m',
          tag: 'Vegetarian',
          tagColor: AppColors.primary,
        ),
        (
          mealType: 'Dinner',
          title: 'Authentic Green Curry Chicken',
          imageUrl:
              'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400&auto=format&fit=crop',
          prepTime: '45m',
          tag: 'Thai',
          tagColor: AppColors.secondary,
        ),
      ],
    ),
  ];

  String get _weekRange {
    // Current week range — static for UI demo
    return 'October 14 – October 20';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _hasData ? _buildWithData() : _buildEmpty(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.neutral200,
            child: Icon(Icons.person_outline, size: 20, color: AppColors.neutral600),
          ),
          const SizedBox(width: 10),
          Text(
            'MealMind',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: AppColors.neutral700),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildWithData() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Page title
          Text('Your Planner', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 4),
          Text(
            _weekRange,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          // Day sections
          ..._weeklyPlan.map(
            (dayPlan) => Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: DayMealSection(
                dayName: dayPlan.day,
                meals: dayPlan.meals
                    .map(
                      (m) => DayMealSection.meal(
                        mealType: m.mealType,
                        title: m.title,
                        imageUrl: m.imageUrl,
                        prepTime: m.prepTime,
                        tag: m.tag,
                        tagColor: m.tagColor,
                      ),
                    )
                    .toList(),
                onAdjust: () {},
              ),
            ),
          ),
          // AI Regenerate button
          AppButton(
            label: 'AI Regenerate Week',
            icon: Icons.auto_awesome_outlined,
            variant: AppButtonVariant.inverted,
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return PlannerEmptyState(
      onGenerate: () {
        setState(() => _hasData = true);
      },
    );
  }
}

class _DayPlan {
  const _DayPlan({required this.day, required this.meals});

  final String day;
  final List<
      ({
        String mealType,
        String title,
        String imageUrl,
        String prepTime,
        String tag,
        Color tagColor,
      })> meals;
}
