import 'package:flutter/material.dart';

class MeditationSession {
  final String id;
  final String type; // breathing, mantra, mindfulness, chakra
  final int durationSeconds;
  final DateTime completedAt;
  final String notes;

  MeditationSession({
    required this.id,
    required this.type,
    required this.durationSeconds,
    required this.completedAt,
    this.notes = '',
  });
}

class MeditationProvider extends ChangeNotifier {
  final List<MeditationSession> _sessions = [];
  int _timerSeconds = 0;
  bool _isRunning = false;
  String _currentType = 'breathing';

  List<MeditationSession> get sessions => _sessions;
  int get timerSeconds => _timerSeconds;
  bool get isRunning => _isRunning;
  String get currentType => _currentType;

  void setTimerSeconds(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }

  void setRunning(bool running) {
    _isRunning = running;
    notifyListeners();
  }

  void setCurrentType(String type) {
    _currentType = type;
    notifyListeners();
  }

  void addSession({
    required String type,
    required int durationSeconds,
    String notes = '',
  }) {
    final session = MeditationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      durationSeconds: durationSeconds,
      completedAt: DateTime.now(),
      notes: notes,
    );
    _sessions.add(session);
    notifyListeners();
  }

  List<MeditationSession> getSessionsByType(String type) {
    return _sessions.where((s) => s.type == type).toList();
  }

  int getTotalMinutes() {
    return _sessions.fold(0, (sum, session) => sum + (session.durationSeconds ~/ 60));
  }
}
