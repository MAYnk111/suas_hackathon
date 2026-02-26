import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaveBackground extends StatefulWidget {
  final List<Color> colors;
  final double heightFactor;

  const AnimatedWaveBackground({
    super.key,
    required this.colors,
    this.heightFactor = 1.0,
  });

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveBackgroundPainter(
            animation: _controller.value,
            colors: widget.colors,
            heightFactor: widget.heightFactor,
          ),
          child: Container(),
        );
      },
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  final double heightFactor;

  WaveBackgroundPainter({
    required this.animation,
    required this.colors,
    required this.heightFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw multiple wave layers with different speeds and patterns
    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      
      final path = Path();
      final waveHeight = (size.height * heightFactor * 0.15) * (1 + i * 0.3);
      final frequency = 0.015 + (i * 0.005);
      final speed = 1.0 + (i * 0.3);
      final phaseShift = animation * 2 * math.pi * speed;
      
      // Start from top left
      path.moveTo(0, 0);
      
      // Draw the top wave curve
      for (double x = 0; x <= size.width; x += 2) {
        final y1 = waveHeight * math.sin((x * frequency) + phaseShift);
        final y2 = waveHeight * 0.7 * math.cos((x * frequency * 0.8) - phaseShift * 0.7);
        final y = size.height * 0.3 + y1 + y2;
        path.lineTo(x, y);
      }
      
      // Complete the path to fill the entire vertical space
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }

    // Add additional flowing waves in the middle section
    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i].withOpacity(0.3);
      
      final path = Path();
      final waveHeight = (size.height * heightFactor * 0.1) * (1 + i * 0.2);
      final frequency = 0.012 + (i * 0.004);
      final speed = 0.8 + (i * 0.4);
      final phaseShift = animation * 2 * math.pi * speed;
      
      // Start middle wave
      path.moveTo(0, size.height * 0.5);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y1 = waveHeight * math.sin((x * frequency) + phaseShift + math.pi);
        final y2 = waveHeight * 0.5 * math.cos((x * frequency * 1.2) - phaseShift);
        final y = size.height * 0.6 + y1 + y2;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WaveBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
