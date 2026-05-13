import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

enum ChatBubbleRole { user, ai }

class ChatTimestamp extends StatelessWidget {
  const ChatTimestamp({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.neutral600),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    required this.role,
  });

  final String text;
  final ChatBubbleRole role;

  bool get _isUser => role == ChatBubbleRole.user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: _isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: _isUser ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: _isUser ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: _isUser
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: _isUser ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
