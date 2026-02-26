import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/translation_repository.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';

/// Provider to check translation service availability
final translationServiceProvider = FutureProvider<bool>((ref) async {
  return await TranslationRepository.isServiceAvailable();
});

/// Provider to translate a single text string
final translateProvider =
    FutureProvider.family<String, String>((ref, text) async {
  final currentLanguageCode = ref.watch(languageProvider);
  if (text.isEmpty || currentLanguageCode == 'en') {
    return text;
  }

  return await TranslationRepository.translate(
    text: text,
    targetLanguage: currentLanguageCode,
    sourceLanguage: 'en',
  );
});

/// Provider to translate multiple texts at once
final translateBatchProvider =
    FutureProvider.family<List<String>, List<String>>((ref, texts) async {
  final currentLanguageCode = ref.watch(languageProvider);
  if (texts.isEmpty || currentLanguageCode == 'en') {
    return texts;
  }

  return await TranslationRepository.translateBatch(
    texts: texts,
    targetLanguage: currentLanguageCode,
    sourceLanguage: 'en',
  );
});

/// Helper class for easy translation in widgets
class TranslationHelper {
  /// Translate text with fallback to original if service unavailable
  static String translate(String text, AppLanguage language) {
    if (text.isEmpty || language.code == 'en') {
      return text;
    }
    // This is a synchronous helper - for actual translation use the providers
    return text;
  }

  /// Get a list of supported language codes
  static List<String> getSupportedLanguageCodes() {
    return AppLanguage.values.map((lang) => lang.code).toList();
  }

  /// Get supported languages
  static List<AppLanguage> getSupportedLanguages() {
    return AppLanguage.values.toList();
  }
}

