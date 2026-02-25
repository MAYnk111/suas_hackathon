import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vedic_wellness_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class VedicWellnessScreen extends StatefulWidget {
  const VedicWellnessScreen({super.key});

  @override
  State<VedicWellnessScreen> createState() => _VedicWellnessScreenState();
}

class _VedicWellnessScreenState extends State<VedicWellnessScreen> {
  final List<Map<String, String>> _concerns = [
    {'concern': 'Common Cold & Cough', 'dosha': 'Vata - Kapha', 'emoji': '🌬️'},
    {'concern': 'Digestive Discomfort', 'dosha': 'Pitta', 'emoji': '🔥'},
    {'concern': 'Fatigue & Low Energy', 'dosha': 'Vata - Kapha', 'emoji': '⚡'},
    {'concern': 'Skin Irritation & Inflammation', 'dosha': 'Pitta', 'emoji': '🌿'},
    {'concern': 'Joint & Muscle Comfort', 'dosha': 'Vata', 'emoji': '🦵'},
  ];
  String? _selectedConcern;
  String? _selectedDosha;

  @override
  Widget build(BuildContext context) {
    final vedProvider = context.watch<VedicWellnessProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
          const SectionHeader(
            title: 'Vedic Wellness (Arogya)',
            subtitle: 'Traditional wisdom for everyday wellness',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '🌿 Traditional Wellness',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Arogya: Vedic Food & Natural Support',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Arogya means complete wellness. Explore Vedic-inspired food wisdom for common concerns — rooted in tradition, grounded in responsibility.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.lg),
            ..._concerns.map((concern) {
              final isSelected = _selectedConcern == concern['concern'];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: vedProvider.isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedConcern = concern['concern'];
                                _selectedDosha = concern['dosha'];
                              });
                              vedProvider.getVedicGuidance(
                                concern: concern['concern']!,
                                dosha: concern['dosha']!,
                              );
                            },
                      child: AppCard(
                        child: Row(
                          children: [
                            Text(concern['emoji']!, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    concern['concern']!,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dosha: ${concern['dosha']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppTheme.mutedForeground),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            else
                              const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                    if (isSelected && vedProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  'Fetching guidance for $_selectedConcern...',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isSelected && vedProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: AppCard(
                          child: Text(
                            vedProvider.error!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.destructive),
                          ),
                        ),
                      ),
                    if (isSelected && vedProvider.result != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vedic Guidance',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(vedProvider.result!),
                            ],
                          ),
                        ),
                      ),
                    if (isSelected && _selectedDosha != null)
                      const SizedBox(height: AppSpacing.md),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Text(
                '⚠️ Vedic Wisdom + Modern Responsibility: These foods support general wellness based on traditional knowledge. Changes in diet should align with medical advice. Always consult qualified healthcare providers for diagnosed conditions or persistent symptoms.',
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
