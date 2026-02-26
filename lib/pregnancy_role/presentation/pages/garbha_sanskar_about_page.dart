import 'package:flutter/material.dart';

class GarbhaSanskarAboutPage extends StatelessWidget {
  const GarbhaSanskarAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('What is Garbha Sanskar?'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.secondary,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: colorScheme.secondary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This content is for awareness and wellness only and does not replace medical advice.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Introduction
            _SectionCard(
              title: 'An Ancient Tradition',
              icon: Icons.history_edu,
              color: const Color(0xFF800000),
              child: Text(
                'Garbha Sanskar is a Sanskrit term meaning "education in the womb." '
                'Traditionally, it refers to practices and principles believed to support '
                'emotional, mental, and spiritual wellness during pregnancy.',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 20),

            // Cultural Context
            _SectionCard(
              title: 'Cultural & Historical Context',
              icon: Icons.public,
              color: const Color(0xFFDAA520),
              child: Text(
                'Rooted in ancient Indian philosophy, Garbha Sanskar emphasizes the '
                'importance of a peaceful environment, positive thoughts, and mindful '
                'activities during pregnancy. Historically, these practices were seen as '
                'ways to nurture both the mother and developing baby.',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 20),

            // Core Principles
            const _SectionCard(
              title: 'Core Principles',
              icon: Icons.spa,
              color: Color(0xFFCD853F),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PrincipleItem(
                    icon: Icons.psychology,
                    title: 'Mindset & Emotions',
                    description:
                        'Cultivating calmness, joy, and emotional balance through '
                        'meditation, music, and positive thinking.',
                  ),
                  SizedBox(height: 16),
                  _PrincipleItem(
                    icon: Icons.nature,
                    title: 'Environment',
                    description:
                        'Creating a peaceful, harmonious space with gentle sounds, '
                        'pleasant aromas, and natural surroundings.',
                  ),
                  SizedBox(height: 16),
                  _PrincipleItem(
                    icon: Icons.book,
                    title: 'Knowledge & Reflection',
                    description:
                        'Reading uplifting stories, practicing gratitude, and '
                        'engaging in creative activities like art or music.',
                  ),
                  SizedBox(height: 16),
                  _PrincipleItem(
                    icon: Icons.favorite,
                    title: 'Connection',
                    description:
                        'Bonding with your baby through gentle touch, talking, '
                        'and nurturing self-care routines.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Modern Understanding
            _SectionCard(
              title: 'Modern Understanding',
              icon: Icons.lightbulb_outline,
              color: const Color(0xFFB8860B),
              child: Text(
                'While Garbha Sanskar is a traditional practice, today it can be viewed '
                'as a holistic approach to prenatal wellness. The focus on reducing stress, '
                'maintaining emotional health, and creating a positive environment aligns '
                'with modern wellness principles.\n\n'
                'Remember: These practices complement, but do not replace, regular prenatal '
                'care and medical guidance from your healthcare provider.',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.05),
            color.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _PrincipleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrincipleItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.secondary, size: 20),
        ),
        const SizedBox(width: 12),
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
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
