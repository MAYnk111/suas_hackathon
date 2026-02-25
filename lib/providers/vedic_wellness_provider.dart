import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class VedicWellnessProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  String? result;
  bool isLoading = false;
  String? error;

  Future<void> queryVedicWellness({
    required String concern,
    required String dosha,
  }) async {
    if (concern.trim().isEmpty) return;

    isLoading = true;
    error = null;
    result = null;
    notifyListeners();

    try {
      // ignore: avoid_print
      print('VEDIC_WELLNESS: Querying for $concern (Dosha: $dosha)');

      final prompt =
          'I need traditional Ayurvedic wellness guidance for $concern (Dosha: $dosha). Recommend foods and lifestyle practices based on Vedic principles. Remember: this is for wellness awareness, not medical treatment. Always suggest consulting a qualified healthcare provider for diagnosed conditions.';

      final response = await _geminiService.sendPrompt(
        message: prompt,
        language: 'en',
      );

      result = response;
      // ignore: avoid_print
      print('VEDIC_WELLNESS: Got response (${response.length} chars)');
    } catch (e) {
      // ignore: avoid_print
      print('VEDIC_WELLNESS ERROR: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getVedicGuidance({
    required String concern,
    required String dosha,
  }) async {
    await queryVedicWellness(concern: concern, dosha: dosha);
  }

  void clearResult() {
    result = null;
    error = null;
    notifyListeners();
  }
}
