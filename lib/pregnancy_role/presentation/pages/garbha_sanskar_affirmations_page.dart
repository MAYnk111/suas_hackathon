import 'package:flutter/material.dart';

class GarbhaSanskarAffirmationsPage extends StatefulWidget {
  const GarbhaSanskarAffirmationsPage({super.key});

  @override
  State<GarbhaSanskarAffirmationsPage> createState() =>
      _GarbhaSanskarAffirmationsPageState();
}

class _GarbhaSanskarAffirmationsPageState
    extends State<GarbhaSanskarAffirmationsPage> {
  int _selectedIndex = 0;

  final List<_Affirmation> _affirmations = const [
    _Affirmation(
      title: 'Morning Grounding',
      text: 'I welcome this new day with peace and gratitude. '
          'My body knows exactly what to do. '
          'I am calm, prepared, and surrounded by love.',
      icon: Icons.wb_sunny,
      color: Color(0xFFDAA520),
    ),
    _Affirmation(
      title: 'Inner Strength',
      text: 'I am strong, capable, and resilient. '
          'Every breath I take nourishes my baby and myself. '
          'I trust my journey and embrace each moment.',
      icon: Icons.favorite,
      color: Color(0xFF800000),
    ),
    _Affirmation(
      title: 'Connection & Bond',
      text: 'I am connected to my baby in the most beautiful way. '
          'Together, we are growing and thriving. '
          'Love surrounds us always.',
      icon: Icons.child_care,
      color: Color(0xFFCD853F),
    ),
    _Affirmation(
      title: 'Peace & Calm',
      text: 'I release all worry and embrace peace. '
          'My mind is calm, my heart is open. '
          'I am exactly where I need to be.',
      icon: Icons.spa,
      color: Color(0xFFB8860B),
    ),
    _Affirmation(
      title: 'Positive Birth',
      text: 'I visualize a calm, safe, and joyful birth. '
          'My body is designed for this. '
          'I welcome my baby with confidence and love.',
      icon: Icons.pregnant_woman,
      color: Color(0xFF8B4513),
    ),
    _Affirmation(
      title: 'Evening Gratitude',
      text: 'I am grateful for today and all it brought. '
          'I rest knowing my baby is safe and loved. '
          'Tomorrow is a new opportunity for joy.',
      icon: Icons.nights_stay,
      color: Color(0xFF654321),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentAffirmation = _affirmations[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection & Affirmations'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Main Affirmation Display
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Ornate Icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentAffirmation.color,
                        width: 3,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          currentAffirmation.color.withOpacity(0.15),
                          currentAffirmation.color.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      currentAffirmation.icon,
                      size: 56,
                      color: currentAffirmation.color,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      currentAffirmation.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentAffirmation.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Affirmation Text Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: currentAffirmation.color,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: currentAffirmation.color.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        currentAffirmation.text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          height: 1.8,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Audio Placeholder (Future Feature)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.headphones,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Audio guided meditation coming soon',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation Hint
                  Text(
                    'Swipe or tap below to explore more',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom Affirmation Selector
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _affirmations.length,
              itemBuilder: (context, index) {
                final affirmation = _affirmations[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? affirmation.color.withOpacity(0.15)
                          : theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: affirmation.color,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          affirmation.icon,
                          color: affirmation.color,
                          size: isSelected ? 32 : 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          affirmation.title.split(' ').first,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: affirmation.color,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Affirmation {
  final String title;
  final String text;
  final IconData icon;
  final Color color;

  const _Affirmation({
    required this.title,
    required this.text,
    required this.icon,
    required this.color,
  });
}
