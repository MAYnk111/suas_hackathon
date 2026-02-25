import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIAssistantProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  List<ChatMessage> messages = [];
  bool isLoading = false;
  String? error;

  Future<void> sendMessage(String userMessage, {String language = 'en'}) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message
    messages.add(ChatMessage(
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // ignore: avoid_print
      print('AI_ASSISTANT: Sending message: $userMessage');

      final reply = await _geminiService.sendPrompt(
        message: userMessage,
        language: language,
      );

      // Add AI response
      messages.add(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      // ignore: avoid_print
      print('AI_ASSISTANT: Got response (${reply.length} chars)');
    } catch (e) {
      // ignore: avoid_print
      print('AI_ASSISTANT ERROR: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    messages.clear();
    error = null;
    notifyListeners();
  }
}
