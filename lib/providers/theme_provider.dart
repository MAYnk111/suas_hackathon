import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _darkModeKey = 'sudha_dark_mode';
  
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading theme preference: $e');
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error saving theme preference: $e');
    }
  }

  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error saving theme preference: $e');
    }
  }
}
