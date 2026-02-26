import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/medicine_validation_exception.dart';
import '../models/medicine_verification.dart';
import '../models/triage_models.dart';
import '../utils/app_config.dart';
import 'gemini_service.dart';

class ApiService {
  const ApiService();

  static const Duration _timeout = Duration(seconds: 60);

  // Debug logging helper for requests/responses
  void _log(String label, dynamic message) {
    // ignore: avoid_print
    print('🔵 [$label] $message');
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final response = await _get(AppConfig.health);
    return {
      'status': response['status'] ?? 'Unknown',
      'triageSystem': response['triageSystem'] ?? 'rule-based-gemini',
      'version': response['version'] ?? '2.1',
    };
  }

  Future<Map<String, dynamic>> fetchTrackingData() async {
    return {
      'lastUpdated': DateTime.now().toIso8601String(),
      'entries': <Map<String, dynamic>>[],
    };
  }

  Future<List<Map<String, dynamic>>> fetchAlerts() async {
    return [
      {
        'title': 'Medication Reminder',
        'description': 'Take morning dose with water.',
        'time': '08:00 AM',
        'severity': 'low',
      },
      {
        'title': 'Hydration Check',
        'description': 'Log your water intake for today.',
        'time': '12:30 PM',
        'severity': 'medium',
      },
    ];
  }

  Future<Map<String, dynamic>> fetchReports() async {
    return {
      'summary': [
        {
          'title': 'Adherence',
          'value': '92%',
          'subtitle': 'Last 7 days',
        },
        {
          'title': 'Energy',
          'value': 'Stable',
          'subtitle': 'Trend steady',
        },
      ],
      'chart': [
        {'x': 1, 'y': 3.5},
        {'x': 2, 'y': 4.2},
        {'x': 3, 'y': 3.9},
        {'x': 4, 'y': 4.4},
        {'x': 5, 'y': 4.1},
      ],
    };
  }

  Future<TriageResult> submitTrackingEntry({
    required String symptoms,
    required int age,
    required String gender,
  }) async {
    _log('TRACKING', 'Submitting tracking entry with symptom analysis...');
    _log('TRACKING', 'Delegating to GeminiService.analyzeUserInput()');
    
    // NOTE: This now delegates to GeminiService for exact web parity
    // The web app uses /chat endpoint with a prompt, not /analyze-symptoms
    final geminiService = GeminiService();
    return geminiService.analyzeUserInput(
      symptoms: symptoms,
      age: age,
      gender: gender,
    );
  }

  Future<MedicineVerificationResult> verifyMedicine(File imageFile) async {
    _log('VERIFY_MEDICINE', 'Starting medicine verification...');
    _log('VERIFY_MEDICINE', 'Image path: ${imageFile.path}');
    _log('VERIFY_MEDICINE', 'Endpoint: ${AppConfig.verifyMedicine}');

    try {
      final request = http.MultipartRequest('POST', Uri.parse(AppConfig.verifyMedicine));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      _log('VERIFY_MEDICINE', 'Multipart request prepared with field: "image"');

      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);

      print('URL: ${AppConfig.verifyMedicine}');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      _log('VERIFY_MEDICINE', 'Response status code: ${response.statusCode}');
      _log('VERIFY_MEDICINE', 'Response body: ${response.body}');

      final data = _parseJsonMap(response.body);

      // ⚠️ STRICT VALIDATION: Check if this is an invalid image
      if (data.containsKey('success') && data['success'] == false) {
        final errorType = data['type'] ?? 'validation_error';
        _log('VERIFY_MEDICINE', '⚠️ Image validation failed: ${data['message']} (type: $errorType)');
        
        if (errorType == 'invalid_image') {
          // Not a medicine image - throw validation exception
          throw MedicineValidationException(
            data['message'] ?? 'Image does not appear to be medicine',
            details: data['details'],
          );
        }
        
        // Other validation failures
        throw MedicineValidationException(
          data['message'] ?? 'Invalid medicine image',
          details: data['details'],
        );
      }

      // Handle HTTP error status codes
      if (response.statusCode != 200) {
        _log('VERIFY_MEDICINE', '❌ Error: HTTP ${response.statusCode}');
        throw Exception('Backend Error ${response.statusCode}: ${response.body}');
      }

      // Parse successful medicine analysis
      // Check if response has nested 'analysis' field (new format) or direct fields (old format)
      final analysisData = data.containsKey('analysis') ? data['analysis'] : data;
      _validateKeys(analysisData, ['confidence', 'riskLevel', 'message']);
      return MedicineVerificationResult.fromJson(analysisData);
      
    } on MedicineValidationException {
      rethrow;
    } catch (e) {
      _log('VERIFY_MEDICINE', '❌ Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _get(String url) async {
    try {
      // ignore: avoid_print
      print('NEW REQUEST STARTED');
      print('REQUEST URL: $url');
      print('REQUEST BODY: <empty>');
      _log('GET', 'URL: $url');
      _log('GET', 'Headers: {Content-Type: application/json}');

      final response = await http
          .get(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'})
          .timeout(_timeout);

      print('URL: $url');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');
      _log('GET', 'Status code: ${response.statusCode}');
      _log('GET', 'Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Backend Error ${response.statusCode}: ${response.body}');
      }
      return _parseJsonMap(response.body);
    } catch (e, stack) {
      print('API ERROR: $e');
      print(stack);
      _log('GET', 'ERROR: $e');
      rethrow;
    }
  }

  // ignore: unused_element
  Future<Map<String, dynamic>> _post(String url, Map<String, dynamic> payload) async {
    try {
      _log('POST', 'URL: $url');
      _log('POST', 'Headers: {Content-Type: application/json}');
      final body = json.encode(payload);
      // ignore: avoid_print
      print('NEW REQUEST STARTED');
      print('REQUEST URL: $url');
      print('REQUEST BODY: $body');
      _log('POST', 'Payload: $body');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body,
          )
          .timeout(_timeout);

      print('URL: $url');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');
      _log('POST', 'Status code: ${response.statusCode}');
      _log('POST', 'Response body: ${response.body}');

      if (response.statusCode != 200) {
        _log('POST', '❌ Error: HTTP ${response.statusCode}');
        throw Exception('Backend Error ${response.statusCode}: ${response.body}');
      }
      return _parseJsonMap(response.body);
    } catch (e, stack) {
      print('API ERROR: $e');
      print(stack);
      _log('POST', 'ERROR: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _parseJsonMap(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        _log('PARSE', 'JSON parsed successfully. Keys: ${decoded.keys.toList()}');
        return decoded;
      }
      _log('PARSE', '❌ Response is not a Map: ${decoded.runtimeType}');
      throw Exception('Backend Error: invalid JSON object. Raw response: $body');
    } catch (e) {
      _log('PARSE', '❌ JSON parse error: $e');
      throw Exception('Backend Error: JSON parse failed. Raw response: $body');
    }
  }

  void _validateKeys(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      if (!data.containsKey(key)) {
        _log('VALIDATE', '❌ Missing key: "$key". Available keys: ${data.keys.toList()}');
        throw Exception('Backend Error: missing key "$key". Available keys: ${data.keys.toList()}');
      }
    }
    _log('VALIDATE', '✅ All required keys present: $keys');
  }

}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);
}
