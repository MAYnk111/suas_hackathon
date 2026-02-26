import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/app_config.dart';
import '../models/triage_models.dart';

class GeminiService {
  static const Duration _timeout = Duration(seconds: 60);

  // Debug logging helper for API calls
  void _log(String label, dynamic message) {
    // ignore: avoid_print
    print('🟢 [$label] $message');
  }

  Future<String> sendPrompt({
    required String message,
    required String language,
  }) async {
    _log('CHAT', 'Posting message to /chat endpoint...');
    _log('CHAT', 'Message length: ${message.length} chars');
    _log('CHAT', 'Language: $language');
    _log('CHAT', 'Endpoint: ${AppConfig.chat}');

    final payload = {
      'message': message,
      'language': language,
    };

    _log('CHAT', 'Request payload: $payload');

    final response = await _post(
      AppConfig.chat,
      payload,
    );

    _log('CHAT', 'Response received: $response');

    final reply = response['reply'] as String?;
    if (reply == null || reply.isEmpty) {
      _log('CHAT', '❌ Empty or missing reply field');
      throw Exception('Backend Error: empty reply');
    }
    _log('CHAT', 'Reply length: ${reply.length} chars');
    return reply;
  }

  Future<String> getHealthSuggestion({
    required String userQuestion,
    required String language,
  }) async {
    final prompt = 'You are a healthcare assistant.\n\n'
        'Respond strictly in $language.\n'
        'Use simple, clear language. Do not diagnose or prescribe.\n'
        'If symptoms indicate emergency, suggest using SOS.\n\n'
        'User: $userQuestion';

    return sendPrompt(message: prompt, language: language);
  }

  /// Analyzes symptoms using the SAME /chat endpoint as web app
  /// Sends a structured prompt to Gemini via /chat
  /// This matches the web app's SymptomSection.tsx implementation EXACTLY
  /// Generate confidence score based on condition ranking
  /// First condition (most likely) gets high confidence, diminishing for lower ranks
  int _getConfidenceForRank(int rank) {
    switch (rank) {
      case 1:
        return 95;
      case 2:
        return 80;
      case 3:
        return 65;
      default:
        return 50;
    }
  }

  Future<TriageResult> analyzeUserInput({
    required String symptoms,
    required int age,
    required String gender,
  }) async {
    _log('ANALYZE_VIA_CHAT', 'Starting symptom analysis via /chat endpoint...');
    _log('ANALYZE_VIA_CHAT', 'Symptoms: $symptoms');
    _log('ANALYZE_VIA_CHAT', 'Age: $age');
    _log('ANALYZE_VIA_CHAT', 'Gender: $gender');

    // Build the EXACT same prompt as the web app (SymptomSection.tsx)
    final triagePrompt = '''You are a healthcare triage assistant.

Analyze the symptoms below and respond STRICTLY in this JSON-like format:

RiskLevel: Green | Yellow | Red

TopConditions:
1. Condition name – short reason (1 line)
2. Condition name – short reason (1 line)
3. Condition name – short reason (1 line)

ShortAdvice:
- 2–3 bullet points only

Symptoms:
$symptoms

Do NOT include long explanations.
Do NOT include markdown.
Keep it concise.''';

    _log('ANALYZE_VIA_CHAT', 'Prompt prepared');
    _log('ANALYZE_VIA_CHAT', 'Sending to /chat endpoint (not /analyze-symptoms)');

    // Send via /chat endpoint - SAME AS WEB APP
    final reply = await sendPrompt(message: triagePrompt, language: 'en');

    _log('ANALYZE_VIA_CHAT', 'Response from /chat: ${reply.length} chars');
    _log('ANALYZE_VIA_CHAT', 'Response text:\n$reply');

    // Parse the response using the SAME parsing logic as web app
    final parsed = _parseGeminiResponse(reply, age, gender);
    _log('ANALYZE_VIA_CHAT',
        'Parsed result - Risk: ${parsed.riskLevel}, Conditions: ${parsed.topConditions.length}');

    return parsed;
  }

  /// Parses Gemini response exactly like web app's parseGeminiResponse function
  /// Input: Formatted text with "RiskLevel:", "TopConditions:", "ShortAdvice:" sections
  /// Output: TriageResult with riskLevel, topConditions, explanation, and flags
  TriageResult _parseGeminiResponse(
    String replyText,
    int age,
    String gender,
  ) {
    _log('PARSE', 'Parsing Gemini response...');
    _log('PARSE', 'Input length: ${replyText.length} chars');

    // Split by lines, trim, and filter empty
    final lines = replyText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    _log('PARSE', 'Lines: ${lines.length}');

    String? riskLevel;
    final List<ConditionResult> topConditions = [];
    final List<String> advice = [];

    String? section; // "risk", "conditions", "advice", or null

    for (final line in lines) {
      _log('PARSE_LINE', 'Processing: "$line"');

      // Detect section headers
      if (RegExp(r'^RiskLevel:', caseSensitive: false).hasMatch(line)) {
        section = 'risk';
        _log('PARSE_SECTION', 'Detected RiskLevel section');

        // Extract risk level from this line
        RegExp riskPattern = RegExp(r'\b(Red|Yellow|Green)\b', caseSensitive: false);
        final match = riskPattern.firstMatch(line);
        if (match != null) {
          final level = match.group(0)!;
          riskLevel = level[0].toUpperCase() + level.substring(1).toLowerCase();
          _log('PARSE_RISK', 'Extracted risk level: $riskLevel');
        }
        continue;
      }

      if (RegExp(r'^TopConditions:', caseSensitive: false).hasMatch(line)) {
        section = 'conditions';
        _log('PARSE_SECTION', 'Detected TopConditions section');
        continue;
      }

      if (RegExp(r'^ShortAdvice:', caseSensitive: false).hasMatch(line)) {
        section = 'advice';
        _log('PARSE_SECTION', 'Detected ShortAdvice section');
        continue;
      }

      // Parse content based on current section
      if (section == 'conditions' && RegExp(r'^\d+\.').hasMatch(line)) {
        // Format: "1. Condition name – short reason"
        // Try to split on em-dash, en-dash, or hyphen
        final match = RegExp(r'^\d+\.\s*(.+?)\s*[–—-]\s*(.+)$').firstMatch(line);
        if (match != null) {
          final conditionName = match.group(1)!.trim();
          final reason = match.group(2)!.trim();
          // Generate confidence based on ranking (1st=95, 2nd=80, 3rd=65)
          final confidenceValue = _getConfidenceForRank(topConditions.length + 1);
          topConditions.add(ConditionResult(
            condition: conditionName,
            confidence: confidenceValue,
          ));
          _log('PARSE_CONDITION', 'Name: $conditionName, Reason: $reason, Confidence: $confidenceValue%');
        } else {
          // Fallback: extract just the text after the number
          final text = line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim();
          if (text.isNotEmpty) {
            final confidenceValue = _getConfidenceForRank(topConditions.length + 1);
            topConditions.add(ConditionResult(
              condition: text,
              confidence: confidenceValue,
            ));
            _log('PARSE_CONDITION_FALLBACK', 'Condition: $text, Confidence: $confidenceValue%');
          }
        }
      } else if (section == 'advice' && RegExp(r'^[-•]').hasMatch(line)) {
        final text = line.replaceAll(RegExp(r'^[-•]\s*'), '').trim();
        if (text.isNotEmpty) {
          advice.add(text);
          _log('PARSE_ADVICE', 'Advice: $text');
        }
      }
    }

    // Fallback: if no risk level found, try to extract from entire text
    if (riskLevel == null) {
      _log('PARSE_FALLBACK', 'No RiskLevel found in sections, searching entire text...');
      final match = RegExp(r'\b(Red|Yellow|Green)\b', caseSensitive: false).firstMatch(replyText);
      if (match != null) {
        final level = match.group(0)!;
        riskLevel = level[0].toUpperCase() + level.substring(1).toLowerCase();
        _log('PARSE_FALLBACK', 'Found risk level: $riskLevel');
      }
    }

    riskLevel ??= 'Green'; // Default to Green

    _log('PARSE_RESULT',
        'Final result - Risk: $riskLevel, Conditions: ${topConditions.length}, Advice: ${advice.length}');

    // Return result matching web app structure
    // Limit to 3 items like web app does
    return TriageResult(
      riskLevel: riskLevel,
      topConditions: topConditions.take(3).toList(),
      explanation: replyText, // Full text as explanation
      triageType: 'gemini-via-chat', // Match web approach
      flags: const TriageFlags(),
      analysis: TriageAnalysis(
        age: age.toString(),
        gender: gender,
      ),
    );
  }

  Future<Map<String, dynamic>> _post(String url, Map<String, dynamic> payload) async {
    try {
      _log('HTTP_POST', 'URL: $url');
      _log('HTTP_POST', 'Headers: {Content-Type: application/json}');
      final body = json.encode(payload);
      // ignore: avoid_print
      print('NEW REQUEST STARTED');
      print('REQUEST URL: $url');
      print('REQUEST BODY: $body');
      _log('HTTP_POST', 'Body: $body');
      _log('HTTP_POST', 'Timeout: ${_timeout.inSeconds}s');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      print('URL: $url');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');
      _log('HTTP_POST', 'Status code: ${response.statusCode}');
      _log('HTTP_POST', 'Response body: ${response.body}');

      if (response.statusCode != 200) {
        _log('HTTP_POST', '❌ HTTP error ${response.statusCode}');
        throw Exception('Backend Error ${response.statusCode}: ${response.body}');
      }

      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        _log('HTTP_POST', 'Response parsed. Keys: ${decoded.keys.toList()}');
        return decoded;
      }

      _log('HTTP_POST', '❌ Response is not a Map: ${decoded.runtimeType}');
      throw GeminiException('Unexpected response from server.');
    } on TimeoutException catch (e) {
      _log('HTTP_POST', '❌ Timeout after ${_timeout.inSeconds}s');
      print('REAL NETWORK ERROR: $e');
      rethrow;
    } catch (e, stack) {
      print('REAL NETWORK ERROR: $e');
      print(stack);
      _log('HTTP_POST', 'ERROR: $e (${e.runtimeType})');
      rethrow;
    }
  }
}

class GeminiException implements Exception {
  final String message;

  GeminiException(this.message);
}
