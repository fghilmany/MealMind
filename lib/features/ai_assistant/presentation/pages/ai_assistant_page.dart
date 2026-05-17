import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/ai_assistant_datasource.dart';
import '../../data/ai_assistant_models.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/ai_meal_result_card.dart';
import '../widgets/quick_suggestion_chips.dart';
import '../../../recipe_detail/presentation/pages/recipe_detail_page.dart';
import '../../../recipe_detail/presentation/widgets/instructions_section.dart';

// ─── Message model ────────────────────────────────────────────────────────────

enum _MessageType { timestamp, userBubble, aiBubble, aiMealCard, redirect }

class _ChatMessage {
  const _ChatMessage({required this.type, this.text, this.dish});
  final _MessageType type;
  final String? text;
  final AiDishResult? dish;
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final AiAssistantDataSource _dataSource = AiAssistantDataSource();

  bool _isLoading = false;
  bool _hasStarted = false;

  final List<String> _suggestions = const [
    'Sarapan sehat rendah karbo',
    'Makan siang Nusantara pedas',
    'Makan malam tinggi protein',
    'Ide cemilan sehat',
    'Hidangan vegetarian',
  ];

  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _hasStarted = true;
      _messages.add(_ChatMessage(type: _MessageType.userBubble, text: text));
      _inputController.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await _dataSource.sendMessage(text);

      if (!mounted) return;
      setState(() {
        _isLoading = false;

        if (response.type == 'dish' && response.dish != null) {
          _messages.add(_ChatMessage(type: _MessageType.aiBubble, text: response.message));
          _messages.add(_ChatMessage(type: _MessageType.aiMealCard, dish: response.dish));
        } else if (response.type == 'redirect') {
          _messages.add(_ChatMessage(type: _MessageType.redirect, text: response.message));
        } else {
          _messages.add(_ChatMessage(type: _MessageType.aiBubble, text: response.message));
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(const _ChatMessage(
          type: _MessageType.aiBubble,
          text: 'Maaf, terjadi kesalahan. Silakan coba lagi.',
        ));
      });
    }

    _scrollToBottom();
  }

  void _onSuggestionSelected(String suggestion) {
    _inputController.text = suggestion;
    _focusNode.requestFocus();
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _hasStarted = false;
      _dataSource.resetChat();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _hasStarted ? _buildChatList() : _buildEmptyState(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: QuickSuggestionChips(
              suggestions: _suggestions,
              onSelected: _onSuggestionSelected,
            ),
          ),
          ChatInputBar(
            controller: _inputController,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isLoading: _isLoading,
            hintText: 'Minta hidangan apa yang kamu inginkan...',
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (_isLoading && index == _messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: _TypingIndicator(),
          );
        }

        final msg = _messages[index];
        switch (msg.type) {
          case _MessageType.timestamp:
            return ChatTimestamp(label: msg.text ?? '');

          case _MessageType.userBubble:
            return ChatBubble(text: msg.text ?? '', role: ChatBubbleRole.user);

          case _MessageType.aiBubble:
            return ChatBubble(text: msg.text ?? '', role: ChatBubbleRole.ai);

          case _MessageType.redirect:
            return _RedirectBubble(message: msg.text ?? '');

          case _MessageType.aiMealCard:
            final dish = msg.dish!;
            final imageUrl =
                'https://source.unsplash.com/featured/800x600/?${Uri.encodeComponent(dish.imageQuery)}';
            return AiMealResultCard(
              title: dish.title,
              imageUrl: imageUrl,
              tags: dish.tags.map((t) => _mapTag(t)).toList(),
              onApply: () {},
              onRevise: () {
                _inputController.text = 'Revisi hidangan ${dish.title}: ';
                _focusNode.requestFocus();
              },
              onFavorite: () {},
              onViewDetail: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(
                    recipe: _dishToRecipeData(dish, imageUrl),
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_menu_rounded, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'MealMind Chef',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Ceritakan hidangan apa yang kamu inginkan dan biarkan AI menyiapkan resep terbaik untukmu.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  _exampleRow(Icons.local_fire_department_outlined, 'Hidangan Nusantara pedas untuk makan siang'),
                  const Divider(height: 20),
                  _exampleRow(Icons.eco_outlined, 'Sarapan vegetarian tinggi protein'),
                  const Divider(height: 20),
                  _exampleRow(Icons.schedule_outlined, 'Makan malam sehat dalam 20 menit'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exampleRow(IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        _inputController.text = text;
        _focusNode.requestFocus();
      },
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          ),
          const Icon(Icons.north_west_rounded, size: 14, color: AppColors.neutral400),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.neutral200,
          child: Icon(Icons.person_outline, size: 20, color: AppColors.neutral600),
        ),
      ),
      title: Column(
        children: [
          Text(
            'MealMind Chef',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Dish Assistant',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
      actions: [
        if (_hasStarted)
          IconButton(
            onPressed: _clearChat,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.neutral700),
            tooltip: 'Mulai ulang',
          ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: AppColors.neutral700),
        ),
      ],
    );
  }

  MealTag _mapTag(AiDishTag t) {
    Color color;
    IconData? icon;

    switch (t.colorKey) {
      case 'spicy':
        color = const Color(0xFFE53935);
        break;
      case 'time':
        color = AppColors.neutral600;
        break;
      case 'healthy':
        color = AppColors.primary;
        break;
      default:
        color = AppColors.secondary;
    }

    switch (t.iconKey) {
      case 'fire':
        icon = Icons.local_fire_department_outlined;
        break;
      case 'clock':
        icon = Icons.schedule_outlined;
        break;
      case 'leaf':
        icon = Icons.eco_outlined;
        break;
      default:
        icon = null;
    }

    return MealTag(label: t.label, color: color, icon: icon);
  }

  RecipeData _dishToRecipeData(AiDishResult dish, String imageUrl) {
    return RecipeData(
      title: dish.title,
      imageUrl: imageUrl,
      prepTime: dish.prepTime,
      servings: dish.servings,
      badges: dish.tags.map((t) => t.label).toList(),
      ingredients: dish.ingredients,
      steps: dish.steps
          .asMap()
          .entries
          .map((e) => InstructionStep(stepNumber: e.key + 1, title: '', description: e.value))
          .toList(),
      nutrition: RecipeNutrition(
        calories: dish.nutrition['calories'] ?? '-',
        protein: dish.nutrition['protein'] ?? '-',
        carbs: dish.nutrition['carbs'] ?? '-',
        fat: dish.nutrition['fat'] ?? '-',
      ),
    );
  }
}

// ─── Redirect bubble ──────────────────────────────────────────────────────────

class _RedirectBubble extends StatelessWidget {
  const _RedirectBubble({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondary100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: AppColors.secondary200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.restaurant_menu_rounded, size: 16, color: AppColors.secondary700),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Typing indicator ─────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final delay = i / 3;
              final value = ((_controller.value - delay) % 1.0);
              final opacity = value < 0.5 ? value * 2 : (1 - value) * 2;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Opacity(
                  opacity: opacity.clamp(0.2, 1.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.neutral400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
