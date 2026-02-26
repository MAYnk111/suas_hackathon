import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/translation_repository.dart';

/// Supported Indian languages in the app
enum AppLanguage {
  english('en', 'English', '🇮🇳'),
  hindi('hi', 'हिन्दी', '🇮🇳'),
  tamil('ta', 'தமிழ்', '🇮🇳'),
  telugu('te', 'తెలుగు', '🇮🇳'),
  kannada('kn', 'ಕನ್ನಡ', '🇮🇳'),
  malayalam('ml', 'മലയാളം', '🇮🇳'),
  gujarati('gu', 'ગુજરાતી', '🇮🇳'),
  marathi('mr', 'मराठी', '🇮🇳'),
  punjabi('pa', 'ਪੰਜਾਬੀ', '🇮🇳'),
  bengali('bn', 'বাংলা', '🇮🇳');

  final String code;
  final String nativeName;
  final String flag;

  const AppLanguage(this.code, this.nativeName, this.flag);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Language state notifier to manage app language (NOT system language)
class LanguageNotifier extends StateNotifier<String> {
  bool _isServiceAvailable = false;

  LanguageNotifier() : super('en') {
    _loadLanguage();
    _checkServiceAvailability();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('app_language_code') ?? 'en';
    state = languageCode;
  }

  Future<void> _checkServiceAvailability() async {
    _isServiceAvailable = await TranslationRepository.isServiceAvailable();
    if (_isServiceAvailable) {
      print('Translation service is available');
    } else {
      print('Translation service is not available');
    }
  }

  /// Set app language (does NOT change device language)
  Future<void> setLanguage(AppLanguage language) async {
    state = language.code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language_code', language.code);
  }

  /// Translate text to current app language
  Future<String> translateText(String text) async {
    if (!_isServiceAvailable || state == 'en') {
      return text;
    }

    return await TranslationRepository.translate(
      text: text,
      targetLanguage: state,
      sourceLanguage: 'en',
    );
  }

  /// Translate multiple texts to current app language
  Future<List<String>> translateTexts(List<String> texts) async {
    if (!_isServiceAvailable || state == 'en') {
      return texts;
    }

    return await TranslationRepository.translateBatch(
      texts: texts,
      targetLanguage: state,
      sourceLanguage: 'en',
    );
  }

  bool get isServiceAvailable => _isServiceAvailable;

  /// Get current language enum
  AppLanguage get currentLanguage {
    return AppLanguage.fromCode(state);
  }
}

/// Provider for app language (NOT system locale)
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

