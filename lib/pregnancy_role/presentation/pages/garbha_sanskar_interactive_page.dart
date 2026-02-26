import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_music_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_meditation_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_journal_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_activities_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_stories_page.dart';

class GarbhaSanskarInteractivePage extends ConsumerWidget {
  const GarbhaSanskarInteractivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Interactive Wellness'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 70,
                24,
                16,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 48,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Engage Your Senses',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive tools for mindful wellness',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _InteractiveCard(
                  title: 'Music & Sounds',
                  subtitle: 'Classical ragas and calming melodies',
                  icon: Icons.music_note,
                  color: const Color(0xFF800000),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF800000), Color(0xFFA52A2A)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarMusicPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InteractiveCard(
                  title: 'Guided Meditation',
                  subtitle: 'Breathing exercises and mindful sessions',
                  icon: Icons.self_improvement,
                  color: const Color(0xFFDAA520),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDAA520), Color(0xFFFFD700)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarMeditationPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InteractiveCard(
                  title: 'Daily Journal',
                  subtitle: 'Reflect on your thoughts and feelings',
                  icon: Icons.book,
                  color: const Color(0xFFCD853F),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCD853F), Color(0xFFDEB887)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarJournalPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InteractiveCard(
                  title: 'Wellness Activities',
                  subtitle: 'Gentle yoga, puzzles, and mindful games',
                  icon: Icons.psychology,
                  color: const Color(0xFFB8860B),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB8860B), Color(0xFFDAA520)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarActivitiesPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InteractiveCard(
                  title: 'Stories & Tales',
                  subtitle: 'Uplifting stories from ancient wisdom',
                  icon: Icons.auto_stories,
                  color: const Color(0xFF8B4513),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarStoriesPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final VoidCallback onTap;

  const _InteractiveCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: color,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.12),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

