import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/translation_repository.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';

/// Centralized translation manager
class AppTranslations {
  static final Map<String, Map<String, dynamic>> _translations = {};
  static final Map<String, Map<String, dynamic>> _translatedCache = {};
  static bool _isLoaded = false;

  /// Load base English translations from JSON
  static Future<void> loadTranslations() async {
    if (_isLoaded) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/pregnancy/translations/en.json');
      final decoded = json.decode(jsonString);
      _translations['en'] = decoded as Map<String, dynamic>;
      _isLoaded = true;
      print(
          '✅ Loaded English translations: ${_translations["en"]?.keys.length} top-level keys');
    } catch (e, stack) {
      print('❌ Error loading translations: $e');
      print('Stack: $stack');
      _translations['en'] = {};
      _isLoaded = true; // Set to true to prevent infinite retry
    }
  }

  /// Get translation for a key path (e.g., "profile.title")
  static String get(String keyPath, String languageCode) {
    // Check if translations are loaded
    if (!_isLoaded || _translations.isEmpty) {
      print('⚠️ Translations not loaded yet for key: $keyPath');
      return keyPath.split('.').last; // Return last part as fallback
    }

    // Return cached translation if available
    if (languageCode != 'en' &&
        _translatedCache[languageCode]?[keyPath] != null) {
      return _translatedCache[languageCode]![keyPath]!;
    }

    // Get English value
    final englishValue = _getNestedValue(_translations['en'], keyPath);

    if (englishValue == null) {
      print('⚠️ Translation key not found: $keyPath');
      return keyPath.split('.').last; // Return last part of key if not found
    }

    return englishValue;
  }

  /// Translate entire JSON to target language
  static Future<void> translateLanguage(String targetLanguage) async {
    if (targetLanguage == 'en') {
      print('✅ Using English (no translation needed)');
      return;
    }

    if (_translatedCache[targetLanguage] != null) {
      print('✅ Using cached translations for $targetLanguage');
      return; // Already translated
    }

    print('🔄 Starting translation to $targetLanguage...');

    try {
      // Flatten all translations to a list
      final Map<String, String> flatMap = {};
      final enTranslations = _translations['en'];
      if (enTranslations == null || enTranslations.isEmpty) {
        print('❌ English translations not loaded');
        return;
      }
      _flattenMap(enTranslations, '', flatMap);
      print('📝 Flattened ${flatMap.length} translation keys');

      // Get all values to translate
      final List<String> textsToTranslate = flatMap.values.toList();
      print(
          '🌐 Sending ${textsToTranslate.length} texts to translation API...');

      // Batch translate all values
      final translatedTexts = await TranslationRepository.translateBatch(
        texts: textsToTranslate,
        targetLanguage: targetLanguage,
        sourceLanguage: 'en',
      );

      print('📦 Received ${translatedTexts.length} translated texts');

      // Rebuild translated cache
      _translatedCache[targetLanguage] = {};
      int index = 0;
      flatMap.forEach((key, _) {
        if (index < translatedTexts.length) {
          _translatedCache[targetLanguage]![key] = translatedTexts[index];
        } else {
          _translatedCache[targetLanguage]![key] = flatMap[key]!; // Fallback
        }
        index++;
      });

      print('✅ Translation complete for $targetLanguage!');
      print(
          '   Cached ${_translatedCache[targetLanguage]!.length} translations');
      const sampleKey = 'profile.title';
      if (_translatedCache[targetLanguage]!.containsKey(sampleKey)) {
        print(
            '   Sample: $sampleKey = ${_translatedCache[targetLanguage]![sampleKey]}');
      }
    } catch (e) {
      print('❌ Translation error: $e');
      _translatedCache[targetLanguage] = {}; // Empty cache on error
    }
  }

  /// Get nested value from map using dot notation
  static String? _getNestedValue(Map<String, dynamic>? map, String keyPath) {
    if (map == null) return null;

    final keys = keyPath.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current is String ? current : null;
  }

  /// Flatten nested map to dot notation
  static void _flattenMap(
    Map<String, dynamic> map,
    String prefix,
    Map<String, String> result,
  ) {
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        _flattenMap(value, newKey, result);
      } else if (value is String) {
        result[newKey] = value;
      }
    });
  }

  /// Clear cache for a language
  static void clearCache(String languageCode) {
    _translatedCache.remove(languageCode);
  }

  /// Clear all caches
  static void clearAllCaches() {
    _translatedCache.clear();
  }
}

/// Provider to ensure translations are loaded
final translationsLoadedProvider = FutureProvider<bool>((ref) async {
  await AppTranslations.loadTranslations();
  // Wait a bit to ensure filesystem operations complete
  await Future.delayed(const Duration(milliseconds: 100));
  return AppTranslations._isLoaded;
});

/// Provider that triggers translation when language changes
final currentTranslationsProvider = FutureProvider<bool>((ref) async {
  final languageCode = ref.watch(languageProvider);

  // Load base translations first
  await AppTranslations.loadTranslations();

  // Translate to current language
  if (languageCode != 'en') {
    await AppTranslations.translateLanguage(languageCode);
  }

  return true;
});

/// Widget that shows translated text from centralized JSON
class Tr extends ConsumerWidget {
  final String keyPath;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const Tr(
    this.keyPath, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(languageProvider);
    final translationsReady = ref.watch(currentTranslationsProvider);

    return translationsReady.when(
      data: (_) {
        final text = AppTranslations.get(keyPath, languageCode);
        // Debug: Uncomment to see what's being displayed
        // if (keyPath == 'profile.title') {
        //   print('🎨 Rendering "$keyPath" as "$text" in $languageCode');
        // }
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        );
      },
      loading: () {
        // Show English text while translating (better UX)
        final englishText = AppTranslations.get(keyPath, 'en');
        return Text(
          englishText,
          style: style?.copyWith(color: style?.color?.withOpacity(0.7)),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        );
      },
      error: (err, stack) {
        print('❌ Tr widget error for "$keyPath": $err');
        return Text(
          keyPath.split('.').last,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        );
      },
    );
  }
}

/// Extension for easy translation access
extension TranslateExtension on String {
  String tr(String languageCode) {
    return AppTranslations.get(this, languageCode);
  }
}


