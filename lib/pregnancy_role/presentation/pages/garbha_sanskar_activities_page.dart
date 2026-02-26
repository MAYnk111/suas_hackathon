import 'package:flutter/material.dart';
import 'dart:math' as math;

class GarbhaSanskarActivitiesPage extends StatelessWidget {
  const GarbhaSanskarActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Activities'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.15),
                  colorScheme.primary.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.self_improvement,
                  size: 48,
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Gentle Activities',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore mindful practices for wellness',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Yoga Section
          _ActivitySection(
            title: 'Gentle Yoga',
            icon: Icons.self_improvement,
            color: const Color(0xFFDAA520),
            children: [
              const _YogaCard(
                name: 'Butterfly Pose (Baddha Konasana)',
                description:
                    'Sit with soles of feet together, gently press knees down. Opens hips and promotes relaxation.',
                difficulty: 'Easy',
                duration: '2-5 min',
                benefits: 'Hip flexibility, calming',
              ),
              const _YogaCard(
                name: 'Cat-Cow Stretch',
                description:
                    'On hands and knees, alternate arching and rounding your back. Gentle spinal movement.',
                difficulty: 'Easy',
                duration: '3-5 min',
                benefits: 'Back relief, flexibility',
              ),
              const _YogaCard(
                name: 'Child\'s Pose (Balasana)',
                description:
                    'Kneel and sit back on heels, stretch arms forward. Deeply restorative and calming.',
                difficulty: 'Easy',
                duration: '3-7 min',
                benefits: 'Relaxation, stress relief',
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Always consult your healthcare provider before starting any new physical activity.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Breathing Exercises
          _ActivitySection(
            title: 'Breathing Exercises',
            icon: Icons.air,
            color: const Color(0xFF800000),
            children: [
              _BreathingCard(
                name: 'Box Breathing',
                description: 'Inhale 4s → Hold 4s → Exhale 4s → Hold 4s',
                onTap: () =>
                    _showBreathingDemo(context, 'Box Breathing', 4, 4, 4, 4),
              ),
              _BreathingCard(
                name: 'Relaxation Breath',
                description: 'Inhale 4s → Hold 7s → Exhale 8s',
                onTap: () => _showBreathingDemo(
                    context, 'Relaxation Breath', 4, 7, 8, 0),
              ),
              _BreathingCard(
                name: 'Equal Breathing',
                description: 'Inhale 5s → Exhale 5s (repeat)',
                onTap: () =>
                    _showBreathingDemo(context, 'Equal Breathing', 5, 0, 5, 0),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Mindful Puzzles
          _ActivitySection(
            title: 'Mindful Puzzles',
            icon: Icons.extension,
            color: const Color(0xFFCD853F),
            children: [
              _PuzzleCard(
                name: 'Mandala Coloring',
                description:
                    'Color intricate patterns for mindfulness and creativity',
                icon: Icons.palette,
                onTap: () => _navigateToMandala(context),
              ),
              _PuzzleCard(
                name: 'Memory Match',
                description: 'Match pairs of traditional symbols and patterns',
                icon: Icons.grid_on,
                onTap: () => _navigateToMemoryGame(context),
              ),
              _PuzzleCard(
                name: 'Peaceful Patterns',
                description: 'Complete geometric patterns for relaxation',
                icon: Icons.auto_awesome,
                onTap: () => _navigateToPatterns(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Color Therapy
          const _ActivitySection(
            title: 'Color Therapy',
            icon: Icons.color_lens,
            color: Color(0xFFB8860B),
            children: [
              _ColorCard(
                color: Color(0xFFDAA520),
                name: 'Gold',
                meaning: 'Traditionally associated with wisdom and prosperity',
              ),
              _ColorCard(
                color: Color(0xFF87CEEB),
                name: 'Sky Blue',
                meaning: 'Often linked to peace and tranquility',
              ),
              _ColorCard(
                color: Color(0xFF90EE90),
                name: 'Light Green',
                meaning: 'Symbolizes growth and harmony in nature',
              ),
              _ColorCard(
                color: Color(0xFFDDA0DD),
                name: 'Plum',
                meaning: 'Associated with spiritual awareness',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Daily Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.1),
                  colorScheme.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: colorScheme.secondary),
                    const SizedBox(width: 12),
                    Text(
                      'Today\'s Wellness Tip',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Spend 10 minutes today doing something that brings you joy - whether it\'s listening to music, journaling, or simply sitting in nature.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showBreathingDemo(
    BuildContext context,
    String name,
    int inhale,
    int hold,
    int exhale,
    int hold2,
  ) {
    showDialog(
      context: context,
      builder: (context) => _BreathingDemoDialog(
        name: name,
        inhale: inhale,
        hold: hold,
        exhale: exhale,
        hold2: hold2,
      ),
    );
  }

  static void _navigateToMandala(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mandala coloring coming soon!')),
    );
  }

  static void _navigateToMemoryGame(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory game coming soon!')),
    );
  }

  static void _navigateToPatterns(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pattern puzzles coming soon!')),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _ActivitySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _YogaCard extends StatelessWidget {
  final String name;
  final String description;
  final String difficulty;
  final String duration;
  final String benefits;

  const _YogaCard({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDAA520).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFFDAA520),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(label: difficulty, icon: Icons.speed),
              const SizedBox(width: 8),
              _InfoChip(label: duration, icon: Icons.timer),
              const SizedBox(width: 8),
              _InfoChip(label: benefits, icon: Icons.favorite),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const _BreathingCard({
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF800000).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF800000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.air,
                    color: Color(0xFF800000),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleSmall?.copyWith(
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
                const Icon(Icons.play_circle_outline, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _PuzzleCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCD853F).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCD853F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFCD853F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleSmall?.copyWith(
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
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  final Color color;
  final String name;
  final String meaning;

  const _ColorCard({
    required this.color,
    required this.name,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meaning,
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

class _BreathingDemoDialog extends StatefulWidget {
  final String name;
  final int inhale;
  final int hold;
  final int exhale;
  final int hold2;

  const _BreathingDemoDialog({
    required this.name,
    required this.inhale,
    required this.hold,
    required this.exhale,
    required this.hold2,
  });

  @override
  State<_BreathingDemoDialog> createState() => _BreathingDemoDialogState();
}

class _BreathingDemoDialogState extends State<_BreathingDemoDialog> {
  String _currentPhase = '';
  int _countdown = 0;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  void _startCycle() {
    setState(() {
      _isActive = true;
    });
    _runPhase('Breathe In', widget.inhale, () {
      if (widget.hold > 0) {
        _runPhase('Hold', widget.hold, () {
          _runPhase('Breathe Out', widget.exhale, () {
            if (widget.hold2 > 0) {
              _runPhase('Hold', widget.hold2, _startCycle);
            } else {
              _startCycle();
            }
          });
        });
      } else {
        _runPhase('Breathe Out', widget.exhale, _startCycle);
      }
    });
  }

  void _runPhase(String phase, int seconds, VoidCallback onComplete) {
    if (!_isActive) return;

    setState(() {
      _currentPhase = phase;
      _countdown = seconds;
    });

    for (int i = 1; i <= seconds; i++) {
      Future.delayed(Duration(seconds: i), () {
        if (_isActive && mounted) {
          setState(() {
            _countdown = seconds - i;
          });
          if (i == seconds) {
            onComplete();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _currentPhase,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$_countdown',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                setState(() {
                  _isActive = false;
                });
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
