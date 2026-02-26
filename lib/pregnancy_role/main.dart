import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/core/constants/env.dart';
import 'package:sudha_app/pregnancy_role/core/theme/app_theme.dart';
import 'package:sudha_app/pregnancy_role/core/utils/notification_service.dart';
import 'package:sudha_app/pregnancy_role/data/local/hive_adapters.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/splash_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';
import 'package:sudha_app/pregnancy_role/core/services/centralized_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Handle Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter Error: ${details.exception}');
    print('Stack: ${details.stack}');
  };

  // Handle async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    print('Platform Error: $error');
    print('Stack: $stack');
    return true;
  };

  try {
    await dotenv.load(fileName: '.env');
    if (Env.supabaseUrl.isNotEmpty && Env.supabaseAnonKey.isNotEmpty) {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
      );
    } else {
      print('Supabase env missing. Check SUPABASE_URL and SUPABASE_ANON_KEY.');
    }

    await Hive.initFlutter();
    await HiveAdapters.registerAdapters();

    try {
      await NotificationService.initialize();
    } catch (e) {
      print('Notification service initialization failed: $e');
      // Continue without notifications
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e, stackTrace) {
    print('Initialization error: $e');
    print('Stack trace: $stackTrace');
    // Still run the app even if initialization fails
  }

  // Preload translations before building UI
  await AppTranslations.loadTranslations();

  runApp(
    const ProviderScope(
      child: VatsalyaApp(),
    ),
  );
}

class VatsalyaApp extends ConsumerWidget {
  const VatsalyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // Watch app language (but don't set device locale)
    ref.watch(languageProvider);

    return MaterialApp(
      title: 'Vatsalya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // Don't set locale - keep device language intact
      // Only use language provider for content translation
      supportedLocales:
          AppLanguage.values.map((lang) => Locale(lang.code)).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashPage(),
    );
  }
}

