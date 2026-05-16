import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/database/favorites_local_datasource.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../widgets/favorite_recipe_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesLocalDataSource _dataSource = FavoritesLocalDataSource();
  final TextEditingController _searchController = TextEditingController();

  List<FavoriteItem> _all = [];
  List<FavoriteItem> _filtered = [];
  String _selectedFilter = 'All';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_applyFilter);
    FavoritesLocalDataSource.changesNotifier.addListener(_load);
  }

  @override
  void dispose() {
    _searchController.dispose();
    FavoritesLocalDataSource.changesNotifier.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final items = await _dataSource.getAll();
    setState(() {
      _all = items;
      _applyFilter();
    });
  }

  void _applyFilter() {
    _query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _all.where((item) {
        final matchesQuery = _query.isEmpty ||
            item.title.toLowerCase().contains(_query) ||
            item.category.toLowerCase().contains(_query);
        final matchesFilter = _selectedFilter == 'All' ||
            item.category.toLowerCase() == _selectedFilter.toLowerCase();
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  List<String> get _filterChips {
    final categories = _all.map((e) => e.category).toSet().toList()..sort();
    return ['All', ...categories];
  }

  Future<void> _removeFavorite(String id) async {
    await _dataSource.remove(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.neutral400, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search saved dishes...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filter chips
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filterChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final label = _filterChips[index];
                final isSelected = _selectedFilter == label;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedFilter = label);
                    _applyFilter();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.neutral300,
                      ),
                    ),
                    child: Text(
                      label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // List
          Expanded(
            child: _filtered.isEmpty ? _buildEmpty() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _filtered[index];
        return FavoriteRecipeCard(
          item: item,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: item.recipeData),
            ),
          ),
          onUnfavorite: () => _removeFavorite(item.id),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text('No favorites yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Open a recipe and tap the heart button to save it here.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        'Favorites',
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral700),
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
}
