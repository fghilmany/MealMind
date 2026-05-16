import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/planner_local_datasource.dart';
import '../../data/planner_remote_datasource.dart';
import '../../domain/planner_entities.dart';
import '../../domain/planner_preference_entity.dart';
import '../bloc/planner_bloc.dart';
import '../bloc/planner_event.dart';
import '../bloc/planner_state.dart';
import '../widgets/day_meal_section.dart';
import '../widgets/planner_empty_state.dart';
import '../widgets/planner_preference_sheet.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlannerBloc(PlannerRemoteDataSource(), PlannerLocalDataSource()),
      child: const _PlannerView(),
    );
  }
}

class _PlannerView extends StatefulWidget {
  const _PlannerView();

  @override
  State<_PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<_PlannerView> {
  Future<void> _openPreferenceSheet() async {
    final result = await showModalBottomSheet<PlannerPreferenceEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, _) => const PlannerPreferenceSheet(),
      ),
    );

    if (result != null && mounted) {
      context.read<PlannerBloc>().add(GeneratePlanEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocBuilder<PlannerBloc, PlannerState>(
        builder: (context, state) {
          if (state is PlannerInitial) {
            return PlannerEmptyState(onGenerate: _openPreferenceSheet);
          }
          if (state is PlannerLoading) return _buildLoading();
          if (state is PlannerError) return _buildError(context, state.message);
          if (state is PlannerLoaded) return _buildPlan(context, state.plan);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── Loading skeleton ────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
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
                  'AI sedang menyusun rencana makan kamu...',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ..._skeletonDays(),
        ],
      ),
    );
  }

  List<Widget> _skeletonDays() => List.generate(3, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skel(height: 20, width: 100),
            const SizedBox(height: 12),
            _skel(height: 72),
            const SizedBox(height: 8),
            _skel(height: 72),
            const SizedBox(height: 8),
            _skel(height: 72),
          ],
        ),
      ));

  Widget _skel({double? height, double? width}) => Container(
        height: height,
        width: width ?? double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(10),
        ),
      );

  // ── Error ───────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text('Gagal membuat rencana makan', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            AppButton(
              label: 'Coba Lagi',
              icon: Icons.refresh_rounded,
              onPressed: _openPreferenceSheet,
            ),
          ],
        ),
      ),
    );
  }

  // ── Loaded plan ─────────────────────────────────────────────────────────────

  Widget _buildPlan(BuildContext context, PlannerPlanEntity plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Your Planner', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 4),
          Text(
            '${plan.days.length}-Day Meal Plan',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          ...plan.days.map((day) => Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: DayMealSection(
                  dayName: day.day,
                  meals: day.meals.map((m) => DayMealSection.meal(
                        mealType: m.mealType,
                        title: m.title,
                        imageUrl: _imageForCategory(m.category),
                        prepTime: m.prepTime,
                        tag: m.category,
                        tagColor: _colorForCategory(m.category),
                      )).toList(),
                  onAdjust: () {},
                ),
              )),
          AppButton(
            label: 'AI Regenerate',
            icon: Icons.auto_awesome_outlined,
            variant: AppButtonVariant.inverted,
            isFullWidth: true,
            onPressed: _openPreferenceSheet,
          ),
          const SizedBox(height: 28),
        ],
      ),
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

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'nusantara':
      case 'sundanese':
      case 'javanese':
      case 'betawi':
      case 'melayu':
      case 'west sumatra':
        return AppColors.secondary;
      case 'western':
        return const Color(0xFF1E88E5);
      case 'thai':
        return const Color(0xFFE53935);
      case 'chinese':
        return const Color(0xFFD32F2F);
      case 'japanese':
        return const Color(0xFF7B1FA2);
      default:
        return AppColors.primary;
    }
  }

  String _imageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'nusantara':
      case 'sundanese':
      case 'javanese':
      case 'betawi':
      case 'melayu':
      case 'west sumatra':
        return 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&auto=format&fit=crop';
      case 'western':
        return 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&auto=format&fit=crop';
      case 'thai':
        return 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400&auto=format&fit=crop';
      case 'chinese':
        return 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&auto=format&fit=crop';
      case 'japanese':
        return 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&auto=format&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&auto=format&fit=crop';
    }
  }
}
