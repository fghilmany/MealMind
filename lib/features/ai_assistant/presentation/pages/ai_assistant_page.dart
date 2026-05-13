import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/ai_meal_result_card.dart';
import '../widgets/quick_suggestion_chips.dart';

// ─── Chat message model ───────────────────────────────────────────────────────

enum _MessageType { timestamp, userBubble, aiBubble, aiMealCard }

class _ChatMessage {
  const _ChatMessage({required this.type, this.text, this.mealCard});
  final _MessageType type;
  final String? text;
  final _MealCardData? mealCard;
}

class _MealCardData {
  const _MealCardData({
    required this.title,
    required this.imageUrl,
    required this.tags,
  });
  final String title;
  final String imageUrl;
  final List<MealTag> tags;
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
  bool _isLoading = false;

  final List<String> _suggestions = const [
    'Make it Low Carb',
    'Kid Friendly Version',
    'Under 30 mins',
    'High Protein',
    'Vegetarian Option',
  ];

  final List<_ChatMessage> _messages = [
    const _ChatMessage(type: _MessageType.timestamp, text: 'Today, 10:42 AM'),
    const _ChatMessage(
      type: _MessageType.userBubble,
      text: "I want a spicy Nusantara dish for Tuesday's lunch instead.",
    ),
    const _ChatMessage(
      type: _MessageType.aiBubble,
      text:
          "Here's a fiery and authentic Rendang Ayam that perfectly fits your profile and brings those rich Nusantara flavors to Tuesday's lunch!",
    ),
    _ChatMessage(
      type: _MessageType.aiMealCard,
      mealCard: _MealCardData(
        title: 'Rendang Ayam',
        imageUrl:
            'https://images.unsplash.com/photo-1604908177522-3e5e3e5e5e5e?w=800&auto=format&fit=crop',
        tags: const [
          MealTag(
            label: 'Spicy',
            color: Color(0xFFE53935),
            icon: Icons.local_fire_department_outlined,
          ),
          MealTag(
            label: '45 mins',
            color: AppColors.neutral600,
            icon: Icons.schedule_outlined,
          ),
          MealTag(
            label: 'Nusantara',
            color: AppColors.secondary,
          ),
        ],
      ),
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(type: _MessageType.userBubble, text: text));
      _inputController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(const _ChatMessage(
          type: _MessageType.aiBubble,
          text: "Great choice! Let me find the perfect meal for you based on your preferences.",
        ));
      });
      _scrollToBottom();
    });
  }

  void _onSuggestionSelected(String suggestion) {
    _inputController.text = suggestion;
    _focusNode.requestFocus();
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
          // Chat list
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // Loading indicator as last item
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
                    return ChatBubble(
                      text: msg.text ?? '',
                      role: ChatBubbleRole.user,
                    );
                  case _MessageType.aiBubble:
                    return ChatBubble(
                      text: msg.text ?? '',
                      role: ChatBubbleRole.ai,
                    );
                  case _MessageType.aiMealCard:
                    final card = msg.mealCard!;
                    return AiMealResultCard(
                      title: card.title,
                      imageUrl: card.imageUrl,
                      tags: card.tags,
                      onApply: () {},
                      onRevise: () {},
                      onFavorite: () {},
                    );
                }
              },
            ),
          ),
          // Quick suggestions
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: QuickSuggestionChips(
              suggestions: _suggestions,
              onSelected: _onSuggestionSelected,
            ),
          ),
          // Input bar
          ChatInputBar(
            controller: _inputController,
            focusNode: _focusNode,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
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
      ],
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
