import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HealthSnapshotStorage {
  static const String latestSymptomLogKey = 'sudha_latest_symptom_log';
  static const String latestDailyEntryKey = 'sudha_latest_daily_entry';

  static Future<void> saveLatestSymptomLog({
    required String symptoms,
    required int age,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'symptoms': symptoms,
      'age': age,
      'gender': gender,
      'recorded_at': DateTime.now().toIso8601String(),
    };
    await prefs.setString(latestSymptomLogKey, jsonEncode(payload));
  }

  static Future<void> saveLatestDailyEntry({
    required String entry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'entry': entry,
      'recorded_at': DateTime.now().toIso8601String(),
    };
    await prefs.setString(latestDailyEntryKey, jsonEncode(payload));
  }

  static Future<Map<String, dynamic>?> loadLatestSymptomLog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(latestSymptomLogKey);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> loadLatestDailyEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(latestDailyEntryKey);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
