import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/core/services/centralized_translations.dart';
import 'package:sudha_app/pregnancy_role/core/theme/app_theme.dart';
import 'package:sudha_app/pregnancy_role/core/utils/notification_service.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/main_navigation_shell.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';

class PregnancyRoleRoot extends StatelessWidget {
  const PregnancyRoleRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: PregnancyRoleApp());
  }
}

class PregnancyRoleApp extends ConsumerStatefulWidget {
  const PregnancyRoleApp({super.key});

  @override
  ConsumerState<PregnancyRoleApp> createState() => _PregnancyRoleAppState();
}

class _PregnancyRoleAppState extends ConsumerState<PregnancyRoleApp> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializePregnancyModule();
  }

  Future<void> _initializePregnancyModule() async {
    await NotificationService.initialize();
    await AppTranslations.loadTranslations();
    ref.read(userProfileProvider.notifier).state = UserProfileType.pregnant;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Theme(
          data: themeMode == ThemeMode.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          child: const MainNavigationShell(),
        );
      },
    );
  }
}
