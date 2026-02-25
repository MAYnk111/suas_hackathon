import 'package:flutter/material.dart';

import '../models/report_models.dart';
import '../services/api_service.dart';

class ReportsProvider extends ChangeNotifier {
  final ApiService _apiService = const ApiService();

  bool isLoading = false;
  List<ReportSummary> summary = [];
  List<ReportPoint> chart = [];
  String? error;

  Future<void> loadReports() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchReports();
      summary = (data['summary'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((item) => ReportSummary(
                title: item['title'] as String? ?? '',
                value: item['value'] as String? ?? '',
                subtitle: item['subtitle'] as String? ?? '',
              ))
          .toList();

      chart = (data['chart'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((point) => ReportPoint(
                (point['x'] as num?)?.toDouble() ?? 0,
                (point['y'] as num?)?.toDouble() ?? 0,
              ))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('REAL ERROR FROM BACKEND: $e');
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
