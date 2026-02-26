import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
import 'providers/role_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'pregnancy_role/pregnancy_role_app.dart';
import 'theme/vatsalya_theme.dart';
import 'utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  try {
    await Hive.initFlutter();
    // Open required boxes for pregnancy and reminders
    await Hive.openBox('pregnancyBox');
    await Hive.openBox('reminderBox');
    // ignore: avoid_print
    print('✅ Hive initialized successfully');
  } catch (e) {
    // ignore: avoid_print
    print('⚠️ Hive initialization warning: $e');
  }
  
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
  runApp(const RootApp());
}

/// Root App - Entry point with all providers
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = RoleProvider();
            // Load saved role from storage
            provider.initialize();
            return provider;
          },
        ),
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
            theme: VatsalyaTheme.lightTheme,
            darkTheme: VatsalyaTheme.darkTheme,
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

/// App Entry Point - Authentication and Role Routing
class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // Reset tracking state once on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingProvider>().resetState();
    });

    return Consumer2<AuthProvider, RoleProvider>(
      builder: (context, auth, roleProvider, _) {
        // Show loading spinner while checking auth
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // ✅ STEP 1: Check Authentication First
        if (!auth.isAuthenticated) {
          return const LoginScreen();
        }
        
        // ✅ STEP 2: Route Based on Role (Single Source of Truth)
        if (roleProvider.isPregnancyMode) {
          return const PregnancyRoleRoot();
        } else {
          return const MainNavigationScreen();
        }
      },
    );
  }
}
