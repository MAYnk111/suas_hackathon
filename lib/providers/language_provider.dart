import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'sudha_language';
  
  String _language = 'English';
  get language => _language;

  // Simple translation map for core labels
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'dashboard': 'Dashboard',
      'symptoms': 'Symptoms',
      'hospital_checklist': 'Hospital Checklist',
      'food': 'Food Guidance',
      'meditation': 'Meditation',
      'profile': 'Profile',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'logout': 'Logout',
      'settings': 'Settings',
      'emergency': 'Emergency',
    },
    'Hindi': {
      'dashboard': 'डैशबोर्ड',
      'symptoms': 'लक्षण',
      'hospital_checklist': 'अस्पताल चेकलिस्ट',
      'food': 'भोजन मार्गदर्शन',
      'meditation': 'ध्यान',
      'profile': 'प्रोफाइल',
      'language': 'भाषा',
      'dark_mode': 'डार्क मोड',
      'logout': 'लॉगआउट',
      'settings': 'सेटिंग्स',
      'emergency': 'आपातकाल',
    },
  };

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _language = prefs.getString(_languageKey) ?? 'English';
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading language preference: $e');
    }
  }

  Future<void> setLanguage(String lang) async {
    if (_translations.containsKey(lang)) {
      _language = lang;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, _language);
        notifyListeners();
      } catch (e) {
        // ignore: avoid_print
        print('Error saving language preference: $e');
      }
    }
  }

  String translate(String key) {
    return _translations[_language]?[key] ?? key;
  }

  List<String> getAvailableLanguages() => _translations.keys.toList();
}
