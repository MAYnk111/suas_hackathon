import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sudha_app/pregnancy_role/domain/services/gemini_service.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/chat_history_repository.dart';
import 'package:sudha_app/pregnancy_role/data/models/chat_session_model.dart';
import 'package:sudha_app/pregnancy_role/data/models/chat_message_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:uuid/uuid.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final userProfile = ref.watch(userProfileProvider);

  String instruction = '''You are Vatsalya AI, a compassionate women's reproductive health and maternal care assistant.

FOCUS AREAS:
* Menstrual health and cycle tracking
* Pregnancy care across all trimesters
* Postpartum recovery and wellness
* Parenting and caring for toddlers
* Nutrition, hormonal balance, mental wellbeing

PERSONALITY:
* Warm and supportive
* Reassuring and empathetic
* Positive and encouraging
* Calm and gentle tone
* Non-judgmental and inclusive

STRICT RULES:

1. ALWAYS respond in an affirmative and comforting tone
2. Do NOT change medical facts just to agree with user
3. Do NOT diagnose diseases or medical conditions
4. Do NOT prescribe medicines, dosages, or specific treatments
5. ALWAYS encourage doctor/healthcare professional consultation when needed
6. For out-of-scope topics: "I specialize in menstrual, pregnancy, and maternal health topics. How can I help with those?"
7. For emotional concerns: Show deep empathy and validate feelings
8. For danger symptoms: Recommend URGENT medical help without delay

CRITICAL - NEVER OFFER MEDICAL DIAGNOSIS:
* User says: "I have terrible headaches and blurred vision"
* Wrong: "You likely have preeclampsia"
* Right: "Please contact your healthcare provider urgently as these could indicate a serious condition"

YOUR GOAL: Make users feel safe, supported, informed, and empowered.''';

  if (userProfile == UserProfileType.pregnant) {
    instruction +=
        '\n\nCURRENT USER CONTEXT: The user is pregnant. Tailor advice to pregnancy-specific needs, concerns, and trimester-appropriate guidance.';
  } else if (userProfile == UserProfileType.tryingToConceive) {
    instruction +=
        '\n\nCURRENT USER CONTEXT: The user is trying to conceive. Provide guidance on fertility, ovulation tracking, cycle awareness, lifestyle optimization, and conception readiness.';
  } else if (userProfile == UserProfileType.toddlerParent) {
    instruction +=
        '\n\nCURRENT USER CONTEXT: The user is a parent caring for a toddler. Provide advice on toddler development, nutrition, sleep, behavior, and parental wellbeing.';
  }

  return GeminiService(systemInstruction: instruction);
});

final aiResponseProvider =
    StateNotifierProvider<AiChatNotifier, List<ChatMessage>>((ref) {
  final service = ref.watch(geminiServiceProvider);
  final repoAsync = ref.watch(chatHistoryRepositoryProvider);
  return AiChatNotifier(service, repoAsync.value, ref);
});

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      isError: json['isError'] ?? false,
    );
  }
}

class AiChatNotifier extends StateNotifier<List<ChatMessage>> {
  final GeminiService _service;
  final ChatHistoryRepository? _repository;
  final Ref _ref;
  String? currentSessionId;

  AiChatNotifier(this._service, this._repository, this._ref) : super([]) {
    // Optionally load last session or start new?
    // For now, let's start fresh.
  }

  void startNewSession() {
    currentSessionId = null;
    state = [];
    _service.clearSession();
    _ref.invalidate(chatSessionsProvider);
  }

  Future<void> loadSession(String sessionId) async {
    if (_repository == null) return;

    final session = _repository!.getSession(sessionId);
    if (session != null) {
      currentSessionId = sessionId;

      // Convert Hive models to UI models
      final messages = session.messages
          .map((m) => ChatMessage(
                text: m.text,
                isUser: m.isUser,
                timestamp: m.timestamp,
              ))
          .toList();

      state = messages;

      // Initialize Gemini context
      final contentHistory = messages.map((msg) {
        return Content(msg.isUser ? 'user' : 'model', [TextPart(msg.text)]);
      }).toList();
      _service.initializeSession(contentHistory);
      _ref.invalidate(chatSessionsProvider);
    }
  }

  Future<void> _saveCurrentSession() async {
    if (_repository == null) return;

    // Create session ID if new
    currentSessionId ??= const Uuid().v4();

    // Determine title (first user message or "New Chat")
    String title = 'New Chat';
    final firstUserMsg = state.where((m) => m.isUser).firstOrNull;
    if (firstUserMsg != null) {
      title = firstUserMsg.text.length > 30
          ? '${firstUserMsg.text.substring(0, 30)}...'
          : firstUserMsg.text;
    }

    // Convert UI models to Hive models
    final hiveMessages = state
        .map((m) => ChatMessageModel(
              id: const Uuid().v4(), // Generate ID for message
              text: m.text,
              isUser: m.isUser,
              timestamp: m.timestamp,
            ))
        .toList();

    final session = ChatSessionModel(
      id: currentSessionId!,
      title: title,
      lastUpdated: DateTime.now(),
      messages: hiveMessages,
    );

    await _repository!.saveSession(session);
    _ref.invalidate(chatSessionsProvider);
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];

    final response = await _service.sendMessage(text);

    final isError = response.startsWith('Error:') ||
        response.startsWith('Rate limit') ||
        response.startsWith('API key') ||
        response.startsWith('Network error') ||
        response.startsWith('Sorry, I encountered an error');

    final aiMessage = ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
      isError: isError,
    );

    state = [...state, aiMessage];

    // Save to Hive
    await _saveCurrentSession();
  }

  Future<void> clearChat() async {
    // Only clears current view, doesn't delete session from DB unless explicit delete
    _service.clearSession();
    state = [];
    currentSessionId = null;
    _ref.invalidate(chatSessionsProvider);
  }
}

