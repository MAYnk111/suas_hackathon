import 'package:flutter/material.dart';

import '../models/triage_models.dart';
import '../services/api_service.dart';
import '../services/gemini_service.dart';
import '../utils/app_config.dart';

class TrackingProvider extends ChangeNotifier {
  final ApiService _apiService = const ApiService();

  bool isSubmitting = false;
  TriageResult? result;
  String? error;

  void resetState({bool notify = true}) {
    isSubmitting = false;
    result = null;
    error = null;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> submit({
    required String symptoms,
    required int age,
    required String gender,
  }) async {
    if (isSubmitting) return;
    // ignore: avoid_print
    print('BACKEND BASE URL: ${AppConfig.apiBaseUrl}');
    print('NEW SYMPTOM REQUEST STARTED');
    error = null;
    result = null;
    isSubmitting = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    isSubmitting = true;
    notifyListeners();

    try {
      // submitTrackingEntry now returns TriageResult directly (via GeminiService)
      // for exact web app parity
      Future<TriageResult> apiCall() => _apiService.submitTrackingEntry(
            symptoms: symptoms,
            age: age,
            gender: gender,
          );

      try {
        result = await apiCall();
      } catch (e) {
        // ignore: avoid_print
        print('Retrying request...');
        await Future.delayed(const Duration(seconds: 1));
        result = await apiCall();
      }
    } catch (e) {
      // ignore: avoid_print
      print('REAL ERROR FROM BACKEND: $e');
      error = e.toString();
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void clearResult() {
    result = null;
    notifyListeners();
  }
}
