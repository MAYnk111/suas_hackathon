import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_about_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_music_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_meditation_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_journal_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_activities_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/garbha_sanskar_stories_page.dart';

class GarbhaSanskarPage extends ConsumerWidget {
  const GarbhaSanskarPage({super.key});

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 60,
                24,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ornate icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.secondary,
                        width: 3,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary.withOpacity(0.1),
                          colorScheme.secondary.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.spa,
                      size: 48,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Garbha Sanskar',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Ancient wisdom for a mindful pregnancy',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
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
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'For wellness only, not medical advice',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NavigationCard(
                  title: 'What is Garbha Sanskar?',
                  subtitle: 'Learn about this ancient tradition',
                  icon: Icons.auto_stories,
                  color: const Color(0xFF800000),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarAboutPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  title: 'Music & Sounds',
                  subtitle: 'Classical ragas and calming melodies',
                  icon: Icons.music_note,
                  color: const Color(0xFF800000),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarMusicPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  title: 'Guided Meditation',
                  subtitle: 'Breathing exercises and mindful sessions',
                  icon: Icons.self_improvement,
                  color: const Color(0xFFDAA520),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarMeditationPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  title: 'Daily Journal',
                  subtitle: 'Reflect on your thoughts and feelings',
                  icon: Icons.book,
                  color: const Color(0xFFCD853F),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarJournalPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  title: 'Wellness Activities',
                  subtitle: 'Gentle yoga, puzzles, and mindful games',
                  icon: Icons.psychology,
                  color: const Color(0xFFB8860B),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GarbhaSanskarActivitiesPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _NavigationCard(
                  title: 'Stories & Tales',
                  subtitle: 'Uplifting stories from ancient wisdom',
                  icon: Icons.auto_stories,
                  color: const Color(0xFF8B4513),
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

class _NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: color,
          width: 2.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.08),
                color.withOpacity(0.03),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
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
                color: color.withOpacity(0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

