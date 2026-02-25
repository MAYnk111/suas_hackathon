class AppConfig {
  static const String apiBaseUrl = 'https://hackathon-ii-blr5.onrender.com';
  static String get baseUrl => apiBaseUrl;

  static String get analyzeSymptoms => '$apiBaseUrl/analyze-symptoms';
  static String get chat => '$apiBaseUrl/chat';
  static String get verifyMedicine => '$apiBaseUrl/verify-medicine';
  static String get health => '$apiBaseUrl/health';
}
