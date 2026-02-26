import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/core/constants/env.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/onboarding_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/main_navigation_shell.dart';
import 'package:sudha_app/pregnancy_role/core/utils/image_path_helper.dart';
import 'package:sudha_app/common/widgets/crash_safe_image.dart';
import 'package:sudha_app/common/widgets/safe_image.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Widget _safeImageAsset(
    String? imagePath, {
    BoxFit? fit,
  }) {
    print('IMAGE PATH DEBUG: $imagePath');
    final resolvedPath =
        (imagePath != null && imagePath.isNotEmpty)
            ? imagePath
            : ImagePathHelper.defaultImage;

    // Use safe image helper for maximum protection against null paths
    return safeImage(
      resolvedPath,
      fit: fit ?? BoxFit.cover,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Check if user is logged in
      final hasSupabase =
          Env.supabaseUrl.isNotEmpty && Env.supabaseAnonKey.isNotEmpty;
      User? currentUser;
      if (hasSupabase) {
        try {
          currentUser = Supabase.instance.client.auth.currentUser;
        } catch (_) {
          currentUser = null;
        }
      }

      Widget nextPage;
      if (currentUser != null) {
        // User is logged in, go to main app
        nextPage = const MainNavigationShell();
      } else {
        // No user, go to onboarding
        nextPage = const OnboardingPage();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String logoPath = ImagePathHelper.logo;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: _safeImageAsset(
                    logoPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Vatsalya',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Nurturing Growth, Daily.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


