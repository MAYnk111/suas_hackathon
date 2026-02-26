import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/hospital_checklist_provider.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/alerts_provider.dart';
import 'providers/reports_provider.dart';
import 'providers/tracking_provider.dart';
import 'providers/medicine_safety_provider.dart';
import 'providers/ai_assistant_provider.dart';
import 'providers/food_guidance_provider.dart';
import 'providers/vedic_wellness_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/meditation_provider.dart';
import 'providers/family_provider.dart';
import 'providers/health_data_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';
import 'utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: avoid_print
    print('✅ Firebase initialized successfully');
  } catch (e) {
    // Firebase may already be initialized on hot reload
    // ignore: avoid_print
    print('⚠️ Firebase initialization warning: $e');
  }

  // ignore: avoid_print
  print('BASE URL: ${AppConfig.baseUrl}');
  runApp(const SudhaApp());
}

class SudhaApp extends StatelessWidget {
  const SudhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => HospitalChecklistProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
        ChangeNotifierProvider(create: (_) => AlertsProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineSafetyProvider()),
        ChangeNotifierProvider(create: (_) => AIAssistantProvider()),
        ChangeNotifierProvider(create: (_) => FoodGuidanceProvider()),
        ChangeNotifierProvider(create: (_) => VedicWellnessProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => MeditationProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => HealthDataProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          return MaterialApp(
            title: 'SUDHA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // ✅ Locale configuration for language switching
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('hi', 'IN'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const AppEntry(),
          );
        },
      ),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingProvider>().resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return auth.isAuthenticated
            ? const MainNavigationScreen()
            : const LoginScreen();
      },
    );
  }
}
