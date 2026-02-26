import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sudha_app/pregnancy_role/presentation/pages/auth_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/widgets/animated_wave_background.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rainbowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rainbowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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

          // Animated Circles Background (on top of waves)
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
                        .withOpacity(0.1 * _animationController.value),
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
                        .withOpacity(0.08 * _animationController.value),
                  ),
                );
              },
            ),
          ),

          // Animated Rainbow Wave at Bottom (behind main content)
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),

                        // App Logo
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withOpacity(0.8),
                                  colorScheme.secondary.withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Heading
                        Text(
                          'Maternal Infant Care',
                          style:
                              Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          'Your trusted companion for maternal and infant health',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // Features List
                        _buildFeatureItem(
                          context,
                          Icons.favorite,
                          'Health Tracking',
                          'Monitor your health metrics daily',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem(
                          context,
                          Icons.lightbulb,
                          'Smart Reminders',
                          'Get timely reminders for important tasks',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem(
                          context,
                          Icons.info,
                          'Expert Insights',
                          'Access curated health information',
                        ),

                        const SizedBox(height: 80),

                        // Get Started Button
                        SizedBox(
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AuthPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Get Started'),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
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

