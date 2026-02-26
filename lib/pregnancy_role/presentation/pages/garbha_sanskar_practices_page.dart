import 'package:flutter/material.dart';

class GarbhaSanskarPracticesPage extends StatelessWidget {
  const GarbhaSanskarPracticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practices & Daily Routines'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mindful Activities for Your Journey',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore gentle practices traditionally believed to support wellness during pregnancy.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Mind & Emotions Category
            const _CategorySection(
              title: 'Mind & Emotions',
              icon: Icons.psychology,
              color: Color(0xFF800000),
              practices: [
                _Practice(
                  title: 'Morning Meditation',
                  description:
                      'Start your day with 5-10 minutes of quiet reflection or gentle breathing exercises.',
                  suggestion:
                      'Try sitting in a comfortable position and focusing on your breath.',
                ),
                _Practice(
                  title: 'Positive Affirmations',
                  description:
                      'Speak kind, encouraging words to yourself and your baby.',
                  suggestion:
                      'Example: "I am strong, peaceful, and prepared for this journey."',
                ),
                _Practice(
                  title: 'Gratitude Practice',
                  description:
                      'Take a moment each day to note things you feel grateful for.',
                  suggestion: 'Keep a small journal by your bedside.',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Environment Category
            const _CategorySection(
              title: 'Environment',
              icon: Icons.nature,
              color: Color(0xFFDAA520),
              practices: [
                _Practice(
                  title: 'Calming Spaces',
                  description:
                      'Create a corner in your home with soft lighting, comfortable seating, and gentle sounds.',
                  suggestion:
                      'Add plants, cushions, or items that bring you peace.',
                ),
                _Practice(
                  title: 'Music & Sounds',
                  description:
                      'Listen to soothing music, nature sounds, or classical melodies.',
                  suggestion:
                      'Many cultures have traditionally used specific ragas or lullabies.',
                ),
                _Practice(
                  title: 'Aromatherapy',
                  description:
                      'Use gentle, pregnancy-safe scents like lavender or chamomile (with guidance).',
                  suggestion:
                      'Consult your healthcare provider before using essential oils.',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reflection & Routine Category
            const _CategorySection(
              title: 'Reflection & Routine',
              icon: Icons.book,
              color: Color(0xFFCD853F),
              practices: [
                _Practice(
                  title: 'Reading Uplifting Stories',
                  description:
                      'Spend time with books, poetry, or stories that inspire positivity.',
                  suggestion: 'Choose content that brings you joy and peace.',
                ),
                _Practice(
                  title: 'Creative Expression',
                  description:
                      'Engage in art, music, or writing as a form of self-expression.',
                  suggestion:
                      'No need for perfection—simply enjoy the process.',
                ),
                _Practice(
                  title: 'Gentle Movement',
                  description:
                      'Try prenatal yoga, walking, or simple stretches (with medical approval).',
                  suggestion: 'Focus on connection with your body and breath.',
                ),
                _Practice(
                  title: 'Bonding Time',
                  description:
                      'Talk, sing, or gently place your hands on your belly.',
                  suggestion:
                      'Some parents-to-be find this creates a sense of connection.',
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Practice> practices;

  const _CategorySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.practices,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...practices.map((practice) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PracticeCard(practice: practice, color: color),
            )),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final _Practice practice;
  final Color color;

  const _PracticeCard({
    required this.practice,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            practice.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            practice.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          if (practice.suggestion != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      practice.suggestion!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Practice {
  final String title;
  final String description;
  final String? suggestion;

  const _Practice({
    required this.title,
    required this.description,
    this.suggestion,
  });
}
