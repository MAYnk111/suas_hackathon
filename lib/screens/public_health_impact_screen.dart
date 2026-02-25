import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class PublicHealthImpactScreen extends StatelessWidget {
  const PublicHealthImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final impact = [
      {
        'icon': Icons.shield_outlined,
        'title': 'Nakli Aushadhi Suraksha',
        'subtitle': 'नकली औषधि सुरक्षा',
        'description':
            'Protecting users from counterfeit medicines by helping identify fake drugs before consumption.',
      },
      {
        'icon': Icons.restaurant_menu,
        'title': 'Aahar–Aushadhi Samvedana',
        'subtitle': 'आहार–औषधि संवेदन',
        'description':
            'Building awareness of food–drug interactions to prevent unsafe combinations in daily life.',
      },
      {
        'icon': Icons.favorite_outlined,
        'title': 'Shanti & Spashtata',
        'subtitle': 'शांति और स्पष्टता',
        'description':
            'Reducing panic through calm, clear, informational guidance that prevents unnecessary hospital visits.',
      },
      {
        'icon': Icons.public_outlined,
        'title': 'Jan Arogya Seva',
        'subtitle': 'जन आरोग्य सेवा',
        'description':
            'Serving public health by strengthening healthcare awareness and responsibility across communities.',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
          const SectionHeader(
            title: 'Public Health Impact',
            subtitle: 'Our commitment to community health',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '✨ Arogya Seva',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Jan Arogya Prabhav: Our Public Health Impact',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'जन आरोग्य प्रभाव',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Through Seva (service) to society, we aim to make healthcare safer, more informed, and accessible for every Indian family.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...impact.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.mutedForeground,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['description'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Text(
                '🌍 Together, we\'re building a healthier, more informed society where healthcare decisions are made with clarity, confidence, and care.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppTheme.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
