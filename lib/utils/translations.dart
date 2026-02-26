import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

// Translation keys and values
const Map<String, Map<String, String>> translations = {
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
    'tracking': 'Tracking',
    'reports': 'Reports',
    'medicine_safety': 'Medicine Safety',
    'ai_assistant': 'AI Assistant',
    'vedic_wellness': 'Vedic Wellness',
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
    'tracking': 'ट्रैकिंग',
    'reports': 'रिपोर्ट',
    'medicine_safety': 'दवा सुरक्षा',
    'ai_assistant': 'एआई सहायक',
    'vedic_wellness': 'वैदिक कल्याण',
  },
};

/// Simple translation function
/// Usage: tr(context, 'dashboard') returns "Dashboard" or "डैशबोर्ड"
String tr(BuildContext context, String key) {
  try {
    final languageProvider = context.read<LanguageProvider>();
    return translations[languageProvider.language]?[key] ?? key;
  } catch (e) {
    return key;
  }
}
