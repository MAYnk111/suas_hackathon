import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';

class GarbhaSanskarWeeklyPage extends ConsumerWidget {
  const GarbhaSanskarWeeklyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnancyRepo = ref.watch(pregnancyRepositoryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Wisdom'),
        centerTitle: true,
        elevation: 0,
      ),
      body: pregnancyRepo.when(
        data: (repo) {
          final pregnancy = repo.getPregnancy();
          final currentWeek = pregnancy?.weeksPregnant ?? 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Week Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.secondary,
                        colorScheme.secondary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Week $currentWeek',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getTrimester(currentWeek),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The following content reflects traditional beliefs and is not medical advice.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Weekly Content
                _WeeklyContentCard(
                  week: currentWeek,
                  content: _getContentForWeek(currentWeek),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No pregnancy data found',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your pregnancy to see weekly wisdom',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTrimester(int week) {
    if (week <= 13) return 'First Trimester';
    if (week <= 27) return 'Second Trimester';
    return 'Third Trimester';
  }

  Map<String, dynamic> _getContentForWeek(int week) {
    // First Trimester (Weeks 1-13)
    if (week <= 13) {
      return {
        'focus': 'Nurturing Beginnings',
        'theme': 'Calmness & Foundation',
        'traditional_emphasis':
            'Traditionally, the early weeks were seen as a time to establish inner peace and avoid stress. '
                'Activities like listening to soothing music or spending time in nature were historically emphasized.',
        'suggestions': [
          'Create a peaceful morning routine with gentle breathing',
          'Listen to calming classical music or devotional sounds',
          'Avoid overwhelming or negative content',
          'Spend quiet moments in reflection or prayer',
        ],
      };
    }
    // Second Trimester (Weeks 14-27)
    else if (week <= 27) {
      return {
        'focus': 'Growth & Connection',
        'theme': 'Engagement & Positivity',
        'traditional_emphasis':
            'Historically, this phase was believed to be ideal for engaging with uplifting stories, '
                'art, and music. The emphasis was on maintaining joy and positivity.',
        'suggestions': [
          'Read inspiring stories or poetry aloud',
          'Engage in creative activities like drawing or singing',
          'Talk or sing to your baby gently',
          'Maintain a gratitude practice',
        ],
      };
    }
    // Third Trimester (Weeks 28-40)
    else {
      return {
        'focus': 'Preparation & Reflection',
        'theme': 'Grounding & Readiness',
        'traditional_emphasis':
            'Traditionally, the final weeks were seen as a time for grounding practices, '
                'mental preparation, and maintaining emotional balance.',
        'suggestions': [
          'Practice gentle visualization for a calm birth',
          'Spend time in quiet meditation or prayer',
          'Review positive birth affirmations',
          'Connect with your support system',
        ],
      };
    }
  }
}

class _WeeklyContentCard extends StatelessWidget {
  final int week;
  final Map<String, dynamic> content;

  const _WeeklyContentCard({
    required this.week,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Focus & Theme
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF800000),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF800000),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      content['focus'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF800000),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDAA520).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  content['theme'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFDAA520),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Traditional Emphasis
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFDAA520),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    color: Color(0xFFDAA520),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Traditional Perspective',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFDAA520),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content['traditional_emphasis'],
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Suggestions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFCD853F),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFCD853F),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Gentle Suggestions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFCD853F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...(content['suggestions'] as List<String>).map(
                (suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCD853F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          suggestion,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

