import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/mappers/entity_mappers.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/hero_meal_card.dart';
import '../widgets/meal_card.dart';

// ─── Craving filter model ─────────────────────────────────────────────────────

class _CravingFilter {
  const _CravingFilter(this.label, this.color);
  final String label;
  final Color color;
}

// ─── Category helpers ─────────────────────────────────────────────────────────

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'nusantara':
      return AppColors.secondary;
    case 'thai':
      return const Color(0xFFE53935);
    case 'western':
      return const Color(0xFF1E88E5);
    default:
      return AppColors.primary;
  }
}

String _categoryImage(String category) {
  switch (category.toLowerCase()) {
    case 'nusantara':
      return 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=800&auto=format&fit=crop';
    case 'thai':
      return 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&auto=format&fit=crop';
    case 'western':
      return 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&auto=format&fit=crop';
    default:
      return 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&auto=format&fit=crop';
  }
}

const String _heroImageUrl =
    'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800&auto=format&fit=crop';

// ─── Page (BLoC provider entry point) ────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        GetRecommendationsUseCase(
          HomeRepositoryImpl(HomeRemoteDataSourceImpl()),
        ),
      )..add(const FetchRecommendationsEvent()),
      child: const _HomeView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedCraving = 0;

  final List<_CravingFilter> _cravingFilters = const [
    _CravingFilter('Semua', AppColors.primary),
    _CravingFilter('Nusantara', AppColors.secondary),
    _CravingFilter('Western', Color(0xFF1E88E5)),
    _CravingFilter('Thai', Color(0xFFE53935)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) return _buildLoading();
          if (state is HomeError) return _buildError(context, state.message);
          if (state is HomeLoaded) return _buildContent(context, state.recommendation);
          return const SizedBox.shrink();
        },
      ),
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

  // ─── Loading skeleton ───────────────────────────────────────────────────────

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary200),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  'AI sedang menyiapkan rekomendasi untukmu...',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _skeleton(height: 36, width: 240),
          const SizedBox(height: 10),
          _skeleton(height: 18, width: 300),
          const SizedBox(height: 20),
          _skeleton(height: 220),
          const SizedBox(height: 28),
          _skeleton(height: 160),
          const SizedBox(height: 12),
          _skeleton(height: 160),
          const SizedBox(height: 12),
          _skeleton(height: 160),
        ],
      ),
    );
  }

  Widget _skeleton({double? height, double? width}) => Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(12),
        ),
      );

  // ─── Error ──────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            AppButton(
              label: 'Coba Lagi',
              icon: Icons.refresh_rounded,
              onPressed: () =>
                  context.read<HomeBloc>().add(const FetchRecommendationsEvent()),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Content ────────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, RecommendationEntity data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary200),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rekomendasi AI · Nusantara Sehat',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary700),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<HomeBloc>().add(const FetchRecommendationsEvent()),
                  child: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(data.greeting, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(
            data.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          HeroMealCard(
            title: data.hero.title,
            imageUrl: _heroImageUrl,
            prepTime: data.hero.prepTime,
            badge: data.hero.badge,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(
                  recipe: data.hero.detail.toRecipeData(data.hero.title, _heroImageUrl),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Jelajahi Berdasarkan Selera', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
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
          ...data.meals.map((meal) {
            final imageUrl = _categoryImage(meal.category);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MealCard(
                mealType: meal.mealType.isNotEmpty ? meal.mealType : null,
                title: meal.title,
                category: meal.category,
                categoryColor: _categoryColor(meal.category),
                imageUrl: imageUrl,
                rating: meal.rating,
                whyYoullLoveIt: meal.whyYoullLoveIt,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(
                      recipe: meal.toRecipeData(imageUrl),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          AppButton(
            label: 'Perbarui Preferensi',
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
