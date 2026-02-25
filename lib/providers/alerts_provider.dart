import 'package:flutter/material.dart';

import '../models/alert_item.dart';
import '../services/api_service.dart';

class AlertsProvider extends ChangeNotifier {
  final ApiService _apiService = const ApiService();

  bool isLoading = false;
  List<AlertItem> alerts = [];
  String? error;

  Future<void> loadAlerts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchAlerts();
      alerts = data
          .map((item) => AlertItem(
                title: item['title'] as String? ?? '',
                description: item['description'] as String? ?? '',
                time: item['time'] as String? ?? '',
                severity: item['severity'] as String? ?? 'low',
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
