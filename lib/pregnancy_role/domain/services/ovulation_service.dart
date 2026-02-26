import 'package:http/http.dart' as http;
import 'dart:convert';

class OvulationPrediction {
  final double predictedOvulationDay;
  final List<int> fertileWindow;

  OvulationPrediction({
    required this.predictedOvulationDay,
    required this.fertileWindow,
  });

  factory OvulationPrediction.fromJson(Map<String, dynamic> json) {
    return OvulationPrediction(
      predictedOvulationDay: (json['predicted_ovulation_day'] as num).toDouble(),
      fertileWindow: List<int>.from(json['fertile_window'] as List),
    );
  }
}

class OvulationService {
  static const String _baseUrl = 'https://badal023-vatsalya-023.hf.space';

  /// Check if the service is running
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok' && data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      print('Health check error: $e');
      return false;
    }
  }

  /// Predict ovulation day and fertile window
  Future<OvulationPrediction> predictOvulation({
    required double meanCycleLength,
    required double lengthOfLutealPhase,
    required double lengthOfMenses,
    required double prevCycleLength,
    required double cycleStd,
  }) async {
    try {
      final payload = {
        'MeanCycleLength': meanCycleLength,
        'LengthofLutealPhase': lengthOfLutealPhase,
        'LengthofMenses': lengthOfMenses,
        'PrevCycleLength': prevCycleLength,
        'CycleStd': cycleStd,
      };

      print('📊 Sending ovulation prediction request: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15));

      print('📊 Response status: ${response.statusCode}');
      print('📊 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OvulationPrediction.fromJson(data);
      } else {
        throw Exception('Failed to predict ovulation: ${response.statusCode}');
      }
    } catch (e) {
      print('Ovulation prediction error: $e');
      rethrow;
    }
  }
}
