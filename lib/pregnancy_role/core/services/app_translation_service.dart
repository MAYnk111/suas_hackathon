import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/translation_repository.dart';

/// Service for app-wide translations
class AppTranslationService {
  static final Map<String, Map<String, String>> _cache = {};

  /// Translate text to current language with caching
  static Future<String> translate(String text, String targetLanguage) async {
    if (text.isEmpty || targetLanguage == 'en') return text;

    // Check cache
    final cacheKey = '${targetLanguage}_$text';
    if (_cache[targetLanguage]?.containsKey(text) ?? false) {
      return _cache[targetLanguage]![text]!;
    }

    // Translate
    try {
      final translated = await TranslationRepository.translate(
        text: text,
        targetLanguage: targetLanguage,
        sourceLanguage: 'en',
      );

      // Cache result
      _cache[targetLanguage] ??= {};
      _cache[targetLanguage]![text] = translated;

      return translated;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  /// Batch translate with caching
  static Future<List<String>> translateBatch(
    List<String> texts,
    String targetLanguage,
  ) async {
    if (texts.isEmpty || targetLanguage == 'en') return texts;

    final List<String> toTranslate = [];
    final Map<int, String> cached = {};

    // Check cache
    for (int i = 0; i < texts.length; i++) {
      if (_cache[targetLanguage]?.containsKey(texts[i]) ?? false) {
        cached[i] = _cache[targetLanguage]![texts[i]]!;
      } else {
        toTranslate.add(texts[i]);
      }
    }

    // Translate uncached
    if (toTranslate.isEmpty) {
      return texts.asMap().entries.map((e) => cached[e.key]!).toList();
    }

    try {
      final translated = await TranslationRepository.translateBatch(
        texts: toTranslate,
        targetLanguage: targetLanguage,
        sourceLanguage: 'en',
      );

      // Cache and merge results
      _cache[targetLanguage] ??= {};
      int translateIndex = 0;
      final result = <String>[];

      for (int i = 0; i < texts.length; i++) {
        if (cached.containsKey(i)) {
          result.add(cached[i]!);
        } else {
          final trans = translated[translateIndex++];
          _cache[targetLanguage]![texts[i]] = trans;
          result.add(trans);
        }
      }

      return result;
    } catch (e) {
      print('Batch translation error: $e');
      return texts;
    }
  }

  /// Clear cache
  static void clearCache() {
    _cache.clear();
  }
}

/// Widget that automatically translates its child text
class TranslatedText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    if (currentLanguage == 'en') {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      );
    }

    return FutureBuilder<String>(
      future: AppTranslationService.translate(text, currentLanguage),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? text,
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

/// Extension on String for easy translation
extension TranslateString on String {
  Future<String> tr(String targetLanguage) async {
    return AppTranslationService.translate(this, targetLanguage);
  }
}

/// Provider for translation service status
final translationStatusProvider = StateProvider<bool>((ref) => true);

