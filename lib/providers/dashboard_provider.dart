import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = const ApiService();

  bool isLoading = false;
  String status = '';
  String triageSystem = '';
  String version = '';
  String? error;

  Future<void> loadDashboard() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchDashboardData();
      status = data['status'] as String? ?? '';
      triageSystem = data['triageSystem'] as String? ?? '';
      version = data['version'] as String? ?? '';
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
