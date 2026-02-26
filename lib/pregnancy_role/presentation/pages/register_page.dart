import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/trying_to_conceive_setup_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/main_navigation_shell.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/auth_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/widgets/animated_wave_background.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> 
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserProfileType _selectedProfileType = UserProfileType.toddlerParent;
  bool _isLoading = false;
  late AnimationController _rainbowController;

  @override
  void initState() {
    super.initState();
    _rainbowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _rainbowController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final role = _roleStringFromProfile(_selectedProfileType);
      final success = await authService.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'role': role,
        },
      );

      if (!success) {
        throw Exception('Registration failed');
      }

      if (!mounted) return;

      ref.read(authStateProvider.notifier).setUser(authService.currentUser);

      // Update local provider state
      ref.read(userProfileProvider.notifier).state = _selectedProfileType;

      if (authService.isAvailable) {
        final currentUser = authService.currentUser;
        if (currentUser != null) {
          final profileRepo = ref.read(userProfileRepositoryProvider);
          await profileRepo.upsertProfile(
            userId: currentUser['id'] as String,
            email: (currentUser['email'] as String?) ?? email,
            role: role,
            profileType: role,
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate based on selection
      if (_selectedProfileType == UserProfileType.pregnant) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
          (route) => false,
        );
      } else if (_selectedProfileType == UserProfileType.tryingToConceive) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const TryingToConceiveSetupPage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      String errorMessage = 'Registration failed';
      if (e.message.contains('already registered')) {
        errorMessage =
            'Email already registered. Please try logging in instead.';
      } else if (e.message.contains('weak password')) {
        errorMessage = 'Password is too weak. Use at least 6 characters.';
      } else if (e.message.contains('invalid email')) {
        errorMessage = 'Invalid email format.';
      } else {
        errorMessage = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Join Us',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start your journey with us today.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I am a:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      context,
                      title: 'Pregnant Mom',
                      subtitle: 'Pregnancy tracking & care',
                      icon: Icons.pregnant_woman,
                      value: UserProfileType.pregnant,
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      context,
                      title: 'Trying to Conceive',
                      subtitle: 'Fertility & Ovulation Tracking',
                      icon: Icons.favorite_border,
                      value: UserProfileType.tryingToConceive,
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      context,
                      title: 'Toddler Parent',
                      subtitle: 'Growth & Development',
                      icon: Icons.child_care,
                      value: UserProfileType.toddlerParent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
      ],
      ),
    );
  }

  String _roleStringFromProfile(UserProfileType type) {
    switch (type) {
      case UserProfileType.pregnant:
        return 'pregnant';
      case UserProfileType.tryingToConceive:
        return 'trying_to_conceive';
      case UserProfileType.toddlerParent:
        return 'toddler_parent';
    }
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required UserProfileType value,
  }) {
    final isSelected = _selectedProfileType == value;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _selectedProfileType = value),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
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

