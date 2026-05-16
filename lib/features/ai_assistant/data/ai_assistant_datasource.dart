import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'ai_assistant_models.dart';
import 'ai_assistant_prompts.dart';

class AiAssistantDataSource {
  AiAssistantDataSource() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(AiAssistantPrompts.systemInstruction),
    );
    _chat = _model.startChat();
  }

  late final GenerativeModel _model;
  late ChatSession _chat;

  /// Start a fresh conversation session.
  void resetChat() {
    _chat = _model.startChat();
  }

  /// Send a message and get an [AiAssistantResponse].
  Future<AiAssistantResponse> sendMessage(String userMessage) async {
    final response = await _chat.sendMessage(Content.text(userMessage));
    final raw = response.text ?? '';

    // Strip markdown fences if any
    final cleaned = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    try {
      final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
      return AiAssistantResponse.fromJson(decoded);
    } catch (_) {
      // If JSON parse fails, treat as plain text
      return AiAssistantResponse(type: 'text', message: cleaned);
    }
  }
}
