import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/widgets/animated_wave_background.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/main_navigation_shell.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/register_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _rainbowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _rainbowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _rainbowController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
        return;
      }

      ref.read(authStateProvider.notifier).setUser(authService.currentUser);

      final role = authService.userMetadata['role'] as String?;
      if (role == 'pregnant') {
        ref.read(userProfileProvider.notifier).state = UserProfileType.pregnant;
      } else if (role == 'trying_to_conceive') {
        ref.read(userProfileProvider.notifier).state =
            UserProfileType.tryingToConceive;
      } else if (role == 'parent' || role == 'toddler_parent') {
        ref.read(userProfileProvider.notifier).state =
            UserProfileType.toddlerParent;
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  void _handleRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Animated Wave Background - Bottom half only
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: const AnimatedWaveBackground(
                colors: [
                  Color(0x88FFD700), // Golden with 53% opacity
                  Color(0x88CD853F), // Peru/tan with 53% opacity
                  Color(0x88800000), // Maroon with 53% opacity
                ],
              ),
            ),
          ),

          // Semi-transparent overlay for readability
          Positioned.fill(
            child: Container(
              color: colorScheme.surface.withOpacity(0.50),
            ),
          ),

          // Animated Background Elements (on top of waves)
          Positioned(
            top: -50,
            right: -50,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary
                        .withOpacity(0.08 * _animationController.value),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: -100,
            left: -50,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.secondary
                        .withOpacity(0.06 * _animationController.value),
                  ),
                );
              },
            ),
          ),

          // Animated Rainbow Wave at Bottom (behind content)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _rainbowController,
              builder: (context, child) {
                return CustomPaint(
                  painter: RainbowWavePainter(
                    animation: _rainbowController.value,
                    colorScheme: colorScheme,
                  ),
                  size: Size(MediaQuery.of(context).size.width, 120),
                );
              },
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_person_rounded,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: _handleLogin,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to the Journey? ',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: _handleRegister,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Rainbow Wave Painter for animated wave effect
class RainbowWavePainter extends CustomPainter {
  final double animation;
  final ColorScheme colorScheme;

  RainbowWavePainter({
    required this.animation,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2.0;
    final rainbowColors = [
      colorScheme.primary,
      colorScheme.primary.withOpacity(0.8),
      colorScheme.secondary,
      colorScheme.secondary.withOpacity(0.8),
      colorScheme.tertiary,
    ];

    // Draw multiple waves with rainbow colors
    for (int i = 0; i < rainbowColors.length; i++) {
      final waveHeight = 7.5 + (i * 1.5);
      final offset = (animation * size.width) % size.width;
      
      paint.color = rainbowColors[i];
      
      final path = Path();
      path.moveTo(-size.width + offset, size.height - 20 - (i * 5));
      
      for (double x = -size.width + offset; x < size.width * 2 + offset; x += 20) {
        final y = size.height - 20 - (i * 5) - 
                  (waveHeight * (0.5 + 0.5 * math.sin((x / 30) + animation * 2 * math.pi)));
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width * 2 + offset, size.height);
      path.lineTo(-size.width + offset, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }

    // Draw gradient overlay on waves
    final rect = Rect.fromLTWH(0, size.height - 40, size.width, 40);
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          colorScheme.surface.withOpacity(0.9),
        ],
      ).createShader(rect);
    
    canvas.drawRect(rect, gradientPaint);
  }

  @override
  bool shouldRepaint(RainbowWavePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

