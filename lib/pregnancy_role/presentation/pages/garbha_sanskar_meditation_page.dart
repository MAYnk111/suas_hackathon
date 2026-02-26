import 'package:flutter/material.dart';
import 'dart:async';

class GarbhaSanskarMeditationPage extends StatefulWidget {
  const GarbhaSanskarMeditationPage({super.key});

  @override
  State<GarbhaSanskarMeditationPage> createState() =>
      _GarbhaSanskarMeditationPageState();
}

class _GarbhaSanskarMeditationPageState
    extends State<GarbhaSanskarMeditationPage> {
  int _selectedDuration = 5;
  bool _isActive = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  String _phase = 'Breathe In';
  double _breathProgress = 0.0;

  final List<int> _durations = [3, 5, 10, 15, 20];

  void _startMeditation() {
    setState(() {
      _isActive = true;
      _remainingSeconds = _selectedDuration * 60;
      _startBreathingCycle();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopMeditation();
      }
    });
  }

  void _startBreathingCycle() {
    // 4-7-8 breathing technique cycle
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isActive) {
        timer.cancel();
        return;
      }

      setState(() {
        _breathProgress += 0.005;

        if (_breathProgress <= 0.25) {
          _phase = 'Breathe In (4s)';
        } else if (_breathProgress <= 0.58) {
          _phase = 'Hold (7s)';
        } else if (_breathProgress <= 1.0) {
          _phase = 'Breathe Out (8s)';
        }

        if (_breathProgress >= 1.0) {
          _breathProgress = 0.0;
        }
      });
    });
  }

  void _stopMeditation() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _remainingSeconds = 0;
      _breathProgress = 0.0;
      _phase = 'Breathe In';
    });

    if (_remainingSeconds == 0) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Color(0xFFDAA520)),
            SizedBox(width: 12),
            Text('Session Complete'),
          ],
        ),
        content: const Text(
          'Well done! You\'ve completed your meditation session. Take a moment to notice how you feel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Meditation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Breathing Animation
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.1),
                    colorScheme.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.secondary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: _isActive ? 80 + (_breathProgress * 100) : 80,
                    height: _isActive ? 80 + (_breathProgress * 100) : 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colorScheme.secondary,
                          colorScheme.secondary.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.secondary.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  // Outer Ring
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.secondary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                  // Phase Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      Text(
                        _phase,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_isActive) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Duration Selection
            if (!_isActive) ...[
              Text(
                'Choose Duration',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: _durations.map((duration) {
                  final isSelected = _selectedDuration == duration;
                  return ChoiceChip(
                    label: Text('$duration min'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDuration = duration;
                      });
                    },
                    selectedColor: colorScheme.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: colorScheme.secondary.withOpacity(0.5),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // Start/Stop Button
            ElevatedButton(
              onPressed: _isActive ? _stopMeditation : _startMeditation,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isActive ? Colors.red[700] : colorScheme.secondary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isActive ? Icons.stop : Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(
                    _isActive ? 'Stop Meditation' : 'Start Meditation',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Techniques Section
            _TechniqueCard(
              title: '4-7-8 Breathing',
              description:
                  'Breathe in for 4 seconds, hold for 7, exhale for 8. This technique is traditionally believed to promote relaxation.',
              icon: Icons.air,
              color: colorScheme.secondary,
            ),

            const SizedBox(height: 12),

            _TechniqueCard(
              title: 'Benefits',
              description:
                  'Regular meditation may help reduce stress, improve focus, and create a sense of calm. Always listen to your body and consult with healthcare providers.',
              icon: Icons.favorite,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TechniqueCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TechniqueCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
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
