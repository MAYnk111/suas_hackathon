import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class FoodGuidanceProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  String? result;
  bool isLoading = false;
  String? error;

  Future<void> queryFoodMedicineCompatibility({
    required String foodQuery,
  }) async {
    if (foodQuery.trim().isEmpty) return;

    isLoading = true;
    error = null;
    result = null;
    notifyListeners();

    try {
      // ignore: avoid_print
      print('FOOD_GUIDANCE: Querying food-medicine compatibility for: $foodQuery');

      final response = await _geminiService.sendPrompt(
        message: foodQuery,
        language: 'en',
      );

      result = response;
      // ignore: avoid_print
      print('FOOD_GUIDANCE: Got response (${response.length} chars)');
    } catch (e) {
      // ignore: avoid_print
      print('FOOD_GUIDANCE ERROR: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearResult() {
    result = null;
    error = null;
    notifyListeners();
  }
}
