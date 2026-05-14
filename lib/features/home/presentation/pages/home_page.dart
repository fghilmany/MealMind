import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../../recipe_detail/presentation/widgets/instructions_section.dart';
import '../widgets/hero_meal_card.dart';
import '../widgets/meal_card.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class _CravingFilter {
  const _CravingFilter(this.label, this.color);
  final String label;
  final Color color;
}

class _MealItem {
  const _MealItem({
    required this.mealType,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    required this.rating,
    required this.whyYoullLoveIt,
    required this.prepTime,
    required this.servings,
    required this.badges,
    required this.ingredients,
    required this.nutrition,
    required this.steps,
  });
  final String mealType;
  final String title;
  final String category;
  final Color categoryColor;
  final String imageUrl;
  final double rating;
  final String whyYoullLoveIt;
  final String prepTime;
  final String servings;
  final List<String> badges;
  final List<String> ingredients;
  final RecipeNutrition nutrition;
  final List<InstructionStep> steps;

  RecipeData toRecipeData() => RecipeData(
        title: title,
        imageUrl: imageUrl,
        prepTime: prepTime,
        servings: servings,
        badges: badges,
        ingredients: ingredients,
        nutrition: nutrition,
        steps: steps,
      );
}

class _HeroData {
  const _HeroData({
    required this.title,
    required this.prepTime,
    required this.badge,
    this.recipeData,
  });
  final String title;
  final String prepTime;
  final String badge;
  final RecipeData? recipeData;
}

// ─── Hardcoded prompt ─────────────────────────────────────────────────────────

const String _kPrompt = '''
Berikan saya rekomendasi makanan yang cocok untuk saya.
Preferensi makanan saya ialah makanan Nusantara, Chineese atau Eropa.

Balas HANYA dengan JSON valid tanpa markdown, tanpa penjelasan, dengan format berikut:
{
  "greeting": "string — sapaan SINGKAT maksimal 4 kata, contoh: Selamat Pagi, Chef!",
  "subtitle": "string — 1 kalimat motivasi singkat konteks hari ini",
  "hero": {
    "title": "string — nama hidangan TERENAK dan TERBAIK yang paling direkomendasikan hari ini",
    "prepTime": "string (contoh: 20 Menit)",
    "badge": "Pilihan Terbaik AI",
    "detail": {
      "prepTime": "string",
      "servings": "string (contoh: 2 Porsi)",
      "badges": ["string", "string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string angka saja",
        "protein": "string dengan satuan g",
        "carbs": "string dengan satuan g",
        "fat": "string dengan satuan g"
      },
      "steps": [
        "string — instruksi langkah 1 (contoh: Potong ayam menjadi beberapa bagian, taburi garam dan merica, aduk rata.)",
        "string — instruksi langkah 2",
        "string — dan seterusnya sesuai kebutuhan resep"
      ]
    }
  },
  "recommendations": [
    {
      "mealType": "Sarapan",
      "title": "string",
      "category": "Nusantara",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    },
    {
      "mealType": "Makan Siang",
      "title": "string",
      "category": "Nusantara",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    },
    {
      "mealType": "Makan Malam",
      "title": "string",
      "category": "Nusantara",
      "rating": number antara 4.5 dan 5.0,
      "whyYoullLoveIt": "string",
      "prepTime": "string",
      "servings": "string",
      "badges": ["string","string"],
      "ingredients": ["string","string","string","string","string"],
      "nutrition": {
        "calories": "string",
        "protein": "string",
        "carbs": "string",
        "fat": "string"
      },
      "steps": [
        "string — instruksi langkah 1",
        "string — dan seterusnya"
      ]
    }
  ]
}

Semua teks dalam Bahasa Indonesia.
''';

// ─── Category color mapping ───────────────────────────────────────────────────

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

// ─── Placeholder images per category ─────────────────────────────────────────

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

// ─── Page ─────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCraving = 0;
  bool _isLoading = true;
  String? _error;

  String _greeting = 'Selamat Pagi, Chef!';
  String _subtitle = 'Ini rekomendasi menu sehat Nusantara untuk harimu.';
  _HeroData _hero = const _HeroData(
    title: 'Memuat rekomendasi...',
    prepTime: '--',
    badge: 'Pilihan AI',
  );
  List<_MealItem> _meals = [];

  final List<_CravingFilter> _cravingFilters = const [
    _CravingFilter('Semua', AppColors.primary),
    _CravingFilter('Nusantara', AppColors.secondary),
    _CravingFilter('Western', Color(0xFF1E88E5)),
    _CravingFilter('Thai', Color(0xFFE53935)),
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );

      final response = await model.generateContent([Content.text(_kPrompt)]);
      final raw = response.text ?? '';

      // Strip possible markdown code fences
      final cleaned = raw
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      final heroJson = json['hero'] as Map<String, dynamic>;
      final recsJson = json['recommendations'] as List<dynamic>;

      setState(() {
        _greeting = json['greeting'] as String? ?? _greeting;
        _subtitle = json['subtitle'] as String? ?? _subtitle;

        // Parse hero
        final heroDetailJson = heroJson['detail'] as Map<String, dynamic>? ?? {};
        final heroNutritionJson = heroDetailJson['nutrition'] as Map<String, dynamic>? ?? {};
        final heroStepsJson = heroDetailJson['steps'] as List<dynamic>? ?? [];
        final heroIngredientsJson = heroDetailJson['ingredients'] as List<dynamic>? ?? [];
        final heroBadgesJson = heroDetailJson['badges'] as List<dynamic>? ?? [];
        final heroRecipeData = RecipeData(
          title: heroJson['title'] as String,
          imageUrl: 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800&auto=format&fit=crop',
          prepTime: heroDetailJson['prepTime'] as String? ?? heroJson['prepTime'] as String? ?? '20 Menit',
          servings: heroDetailJson['servings'] as String? ?? '2 Porsi',
          badges: heroBadgesJson.map((e) => e as String).toList(),
          ingredients: heroIngredientsJson.map((e) => e as String).toList(),
          nutrition: RecipeNutrition(
            calories: heroNutritionJson['calories'] as String? ?? '0',
            protein: heroNutritionJson['protein'] as String? ?? '0g',
            carbs: heroNutritionJson['carbs'] as String? ?? '0g',
            fat: heroNutritionJson['fat'] as String? ?? '0g',
          ),
          steps: heroStepsJson.asMap().entries.map((e) {
            return InstructionStep(
              stepNumber: e.key + 1,
              title: '',
              description: e.value as String? ?? '',
            );
          }).toList(),
        );
        _hero = _HeroData(
          title: heroJson['title'] as String,
          prepTime: heroJson['prepTime'] as String,
          badge: heroJson['badge'] as String? ?? 'Pilihan Terbaik AI',
          recipeData: heroRecipeData,
        );
        _meals = recsJson.map((item) {
          final m = item as Map<String, dynamic>;
          final category = m['category'] as String? ?? 'Nusantara';

          // Parse nutrition
          final nutritionJson = m['nutrition'] as Map<String, dynamic>? ?? {};
          final nutrition = RecipeNutrition(
            calories: nutritionJson['calories'] as String? ?? '0',
            protein: nutritionJson['protein'] as String? ?? '0g',
            carbs: nutritionJson['carbs'] as String? ?? '0g',
            fat: nutritionJson['fat'] as String? ?? '0g',
          );

          // Parse steps
          final stepsJson = m['steps'] as List<dynamic>? ?? [];
          final steps = stepsJson.asMap().entries.map((e) {
            return InstructionStep(
              stepNumber: e.key + 1,
              title: '',
              description: e.value as String? ?? '',
            );
          }).toList();

          // Parse ingredients
          final ingredientsJson = m['ingredients'] as List<dynamic>? ?? [];
          final ingredients = ingredientsJson.map((e) => e as String).toList();

          // Parse badges
          final badgesJson = m['badges'] as List<dynamic>? ?? [category];
          final badges = badgesJson.map((e) => e as String).toList();

          return _MealItem(
            mealType: m['mealType'] as String? ?? '',
            title: m['title'] as String,
            category: category,
            categoryColor: _categoryColor(category),
            imageUrl: _categoryImage(category),
            rating: (m['rating'] as num).toDouble(),
            whyYoullLoveIt: m['whyYoullLoveIt'] as String,
            prepTime: m['prepTime'] as String? ?? '30 Menit',
            servings: m['servings'] as String? ?? '2 Porsi',
            badges: badges,
            ingredients: ingredients,
            nutrition: nutrition,
            steps: steps,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat rekomendasi. Coba lagi.';
      });
    }
  }

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
    if (_isLoading) return _buildLoading();
    if (_error != null) return _buildError();
    return _buildContent();
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // AI banner shimmer
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
          _buildSkeletonBox(height: 36, width: 240),
          const SizedBox(height: 10),
          _buildSkeletonBox(height: 18, width: 300),
          const SizedBox(height: 20),
          _buildSkeletonBox(height: 220),
          const SizedBox(height: 28),
          _buildSkeletonBox(height: 160),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 160),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 160),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({double? height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text(_error!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            AppButton(
              label: 'Coba Lagi',
              icon: Icons.refresh_rounded,
              onPressed: _fetchRecommendations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // AI banner
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
                    'Rekomendasi AI · Selasa Pagi · Cuaca Panas · Nusantara Sehat',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary700),
                  ),
                ),
                GestureDetector(
                  onTap: _fetchRecommendations,
                  child: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Greeting — use titleLarge so it doesn't overflow
          Text(_greeting, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(
            _subtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          // Hero card — best dish, navigate with real data
          HeroMealCard(
            title: _hero.title,
            imageUrl:
                'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800&auto=format&fit=crop',
            prepTime: _hero.prepTime,
            badge: _hero.badge,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: _hero.recipeData),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Section title
          Text('Jelajahi Berdasarkan Selera', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          // Filter chips
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
                mealType: meal.mealType.isNotEmpty ? meal.mealType : null,
                title: meal.title,
                category: meal.category,
                categoryColor: meal.categoryColor,
                imageUrl: meal.imageUrl,
                rating: meal.rating,
                whyYoullLoveIt: meal.whyYoullLoveIt,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipe: meal.toRecipeData()),
                  ),
                ),
              ),
            ),
          ),
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
