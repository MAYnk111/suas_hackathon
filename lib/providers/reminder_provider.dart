import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reminder {
  final String id;
  final String medicineName;
  final String time; // HH:mm format
  final List<int> days; // 0-6 for Mon-Sun
  final String notes;
  bool completed;

  Reminder({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.days,
    this.notes = '',
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineName': medicineName,
    'time': time,
    'days': days,
    'notes': notes,
    'completed': completed,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      time: json['time'] as String,
      days: List<int>.from(json['days'] as List),
      notes: json['notes'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class ReminderProvider extends ChangeNotifier {
  static const String _remindersKey = 'sudha_reminders';
  
  List<Reminder> _reminders = [];
  String? error;

  List<Reminder> get reminders => _reminders;

  ReminderProvider() {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersJson = prefs.getStringList(_remindersKey) ?? [];
      
      _reminders = remindersJson.map((json) {
        final decoded = jsonDecode(json) as Map<String, dynamic>;
        return Reminder.fromJson(decoded);
      }).toList();
    } catch (e) {
      error = e.toString();
      _reminders = [];
    }
    notifyListeners();
  }

  Future<void> addReminder({
    required String medicineName,
    required String time,
    required List<int> days,
    String notes = '',
  }) async {
    try {
      final reminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicineName: medicineName,
        time: time,
        days: days,
        notes: notes,
      );

      _reminders.add(reminder);
      await _saveReminders();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateReminder(String id, {
    required String medicineName,
    required String time,
    required List<int> days,
    String notes = '',
  }) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reminders[index] = Reminder(
          id: id,
          medicineName: medicineName,
          time: time,
          days: days,
          notes: notes,
          completed: _reminders[index].completed,
        );
        await _saveReminders();
        error = null;
      }
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    try {
      _reminders.removeWhere((r) => r.id == id);
      await _saveReminders();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> markCompleted(String id, bool completed) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reminders[index].completed = completed;
        await _saveReminders();
        error = null;
      }
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> _saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersJson = _reminders
          .map((r) => jsonEncode(r.toJson()))
          .toList();
      await prefs.setStringList(_remindersKey, remindersJson);
    } catch (e) {
      error = e.toString();
    }
  }
}
