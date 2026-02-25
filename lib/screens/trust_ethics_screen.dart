import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class TrustEthicsScreen extends StatelessWidget {
  const TrustEthicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ethics = [
      {
        'icon': Icons.verified_outlined,
        'title': 'No Diagnosis (मर्यादा)',
        'subtitle': 'Maryada',
        'description':
            'We respect professional boundaries — we never diagnose conditions, only share possibilities.',
      },
      {
        'icon': Icons.security_outlined,
        'title': 'No Prescriptions (अहिंसा)',
        'subtitle': 'Ahimsa',
        'description':
            'To do no harm, we never recommend or prescribe any medications.',
      },
      {
        'icon': Icons.person_search_outlined,
        'title': 'Doctor First (वैद्य सम्मान)',
        'subtitle': 'Vaidya Samman',
        'description':
            'We honor healthcare professionals. Always consult qualified doctors for medical decisions.',
      },
      {
        'icon': Icons.lock_outline,
        'title': 'Privacy First (गोपनीयता)',
        'subtitle': 'Gopniyata',
        'description':
            'Your personal health data stays completely private. No information is shared without consent.',
      },
      {
        'icon': Icons.info_outline,
        'title': 'Truth in Limits (सत्य)',
        'subtitle': 'Satya',
        'description':
            'We show confidence levels truthfully so you understand what we know and what we don\'t.',
      },
      {
        'icon': Icons.favorite_border,
        'title': 'Built with Care (करुणा)',
        'subtitle': 'Karuna',
        'description':
            'Designed with compassion to reduce panic, provide clarity, and support well-being.',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
          const SectionHeader(
            title: 'Trust & Ethics',
            subtitle: 'Our commitment to you',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '🛡️ Arogya Dharma: Ethics, Safety & Trust',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'आरोग्य धर्म',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Rooted in the principle of Dharma (ethical duty), we believe healthcare technology must be transparent, safe, and respectful of its limits.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.lg),
            ...ethics.map((item) {
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }
}
