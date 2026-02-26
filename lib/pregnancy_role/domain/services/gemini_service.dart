import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final GenerativeModel _model;
  ChatSession? _chatSession;
  static String _getApiKey() {
    final key = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (key.isEmpty) {
      print('⚠️ WARNING: GEMINI_API_KEY is empty in .env file');
      return 'AIzaSyDummyKeyForDemo123456789'; // Fallback for demo
    }
    return key;
  }

  // 🚨 Emergency safety words for critical health situations
  static const List<String> _dangerWords = [
    'suicide',
    'kill myself',
    'overdose',
    'fainting',
    'severe bleeding',
    'unconscious',
    'heavy blood loss',
    'miscarriage',
    'premature labor',
    'preeclampsia',
    'sepsis',
  ];

  GeminiService({String? systemInstruction}) {
    // Load API key from .env file
    final apiKey = _getApiKey();
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: systemInstruction != null ? Content.system(systemInstruction) : null,
    );
  }

  /// Checks if a message contains emergency keywords
  bool _containsDangerWords(String text) {
    final lowerText = text.toLowerCase();
    return _dangerWords.any((word) => lowerText.contains(word));
  }

  /// Generates emergency response for critical health situations
  String _generateEmergencyResponse() {
    return '''🚨 MEDICAL EMERGENCY DETECTED

This may indicate a serious health situation. Please:

1. **Call Emergency Services NOW** 
   - Dial 112 (India) or your local emergency number
   - Do not delay seeking immediate medical help

2. **Inform healthcare provider immediately** of your symptoms

3. **Do not rely on AI for emergency situations**

We care about your safety. Professional medical professionals are best equipped to help you right now.

Stay safe. Help is available.''';
  }

  Future<String> generateContent(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response from AI.';
    } catch (e) {
      print('Gemini generateContent error: $e');
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  void initializeSession(List<Content> history) {
    _chatSession = _model.startChat(history: history);
  }

  Future<String> sendMessage(String message) async {
    // 🚨 Emergency detection first - highest priority
    if (_containsDangerWords(message)) {
      return _generateEmergencyResponse();
    }

    final apiKey = _getApiKey();
    if (apiKey.isEmpty || apiKey == 'AIzaSyDummyKeyForDemo123456789') {
      return 'Error: Gemini API key is missing. Please add GEMINI_API_KEY to your .env file.';
    }

    try {
      _chatSession ??= _model.startChat();
      final response = await _chatSession!.sendMessage(Content.text(message));
      final text = response.text;
      
      if (text == null || text.isEmpty) {
        return 'I apologize, but I couldn\'t generate a response. Please try rephrasing your question.';
      }
      
      return text;
    } catch (e) {
      print('Gemini sendMessage error: $e');
      final errorStr = e.toString().toLowerCase();
      
      if (errorStr.contains('429') || errorStr.contains('quota')) {
        return 'Rate limit exceeded. Please wait a moment before sending another message.';
      } else if (errorStr.contains('403') || errorStr.contains('401')) {
        return 'API key error. Please verify your Gemini API key in the .env file.';
      } else if (errorStr.contains('finish_reason: safety')) {
        return 'I cannot answer this due to safety guidelines. Please ask something else related to maternal or infant care.';
      } else if (errorStr.contains('network') || errorStr.contains('socket')) {
        return 'Network error. Please check your internet connection and try again.';
      }
      
      // Reset session on other errors in case it's corrupted
      _chatSession = null;
      return 'Sorry, I encountered an error: ${e.toString().split(':').last.trim()}';
    }
  }

  void clearSession() {
    _chatSession = null;
  }
}
