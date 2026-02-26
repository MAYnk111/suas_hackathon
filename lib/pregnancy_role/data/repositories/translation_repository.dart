import 'package:http/http.dart' as http;
import 'dart:convert';

/// Translation service using Hugging Face Space API
/// Endpoint: https://samarth-006-vatsalya.hf.space/
class TranslationRepository {
  static const String _baseUrl = 'https://samarth-006-vatsalya.hf.space';
  static const String _translationEndpoint = '/translate';

  /// Translate text to target language
  ///
  /// Parameters:
  /// - text: The text to translate
  /// - targetLanguage: Target language code (e.g., 'hi', 'ta', 'te')
  /// - sourceLanguage: Source language code (defaults to 'en')
  ///
  /// Returns: Translated text or original text if translation fails
  static Future<String> translate({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    if (text.isEmpty) return text;
    if (targetLanguage == 'en') {
      return text; // No translation needed for English
    }

    try {
      final requestBody = {
        'text': text,
        'source': sourceLanguage,
        'target': targetLanguage,
      };

      print('🌐 Translation Request: $requestBody');

      final response = await http
          .post(
            Uri.parse('$_baseUrl$_translationEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw TimeoutException('Translation request timed out'),
          );

      print('🌐 Translation Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🌐 Translation Result: $data');
        return data['translated_text'] ?? text;
      } else if (response.statusCode == 400) {
        print('❌ Bad request: ${response.body}');
        return text;
      } else if (response.statusCode == 404) {
        print('❌ Endpoint not found (404): $_baseUrl$_translationEndpoint');
        print('❌ Response: ${response.body}');
        return text;
      } else if (response.statusCode == 500) {
        print('❌ Server error: ${response.body}');
        return text;
      } else {
        print('❌ Translation error ${response.statusCode}: ${response.body}');
        return text;
      }
    } on TimeoutException catch (e) {
      print('Timeout error: $e');
      return text;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  /// Batch translate multiple texts
  static Future<List<String>> translateBatch({
    required List<String> texts,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    if (texts.isEmpty) return texts;
    if (targetLanguage == 'en') return texts;

    print('🌐 Batch Translation Request:');
    print('   Count: ${texts.length} texts');
    print('   Target: $targetLanguage');
    print('   First 3: ${texts.take(3).toList()}');

    try {
      final requestBody = {
        'text': texts,
        'source': sourceLanguage,
        'target': targetLanguage,
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl$_translationEndpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () =>
                throw TimeoutException('Batch translation timed out'),
          );

      print('🌐 Batch Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🌐 Response data keys: ${data.keys}');
        final translated = List<String>.from(data['translations'] ?? texts);
        print(
            '✅ Batch translation successful! Translated ${translated.length} texts');
        print(
            '   First translated: ${translated.isNotEmpty ? translated.first : "none"}');
        return translated;
      } else {
        print(
            '❌ Batch translation error ${response.statusCode}: ${response.body}');
        return texts;
      }
    } catch (e) {
      print('❌ Batch translation exception: $e');
      return texts;
    }
  }

  /// Check if translation service is available
  static Future<bool> isServiceAvailable() async {
    try {
      print('🔍 Checking service availability at $_baseUrl/health...');
      final response = await http.get(Uri.parse('$_baseUrl/health')).timeout(
          const Duration(seconds: 30)); // Increased timeout for cold start

      print('✅ Service check response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Service availability check failed: $e');
      return false;
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
