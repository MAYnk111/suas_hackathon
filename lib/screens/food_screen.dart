import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/food_guidance_provider.dart';
import '../providers/vedic_wellness_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final _queryController = TextEditingController();
  String? _selectedVedicConcern;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodGuidanceProvider>();
    final vedProvider = context.watch<VedicWellnessProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SectionHeader(
              title: 'Food & Wellness',
              subtitle: 'Nutrition and Vedic guidance',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Food Hero Banner
            AppCard(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/food_sec.png',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Section 1: Everyday Foods
            Text(
              'Everyday Foods',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🫚', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Turmeric',
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('Anti-inflammatory properties',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppTheme.mutedForeground)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Contains curcumin which may help reduce inflammation naturally.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🥬', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Leafy Vegetables',
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('Iron & haemoglobin support',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppTheme.mutedForeground)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rich in iron and folic acid, supporting healthy blood formation.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Section 2: Food-Medicine Compatibility
            Text(
              'Food-Medicine Compatibility',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _queryController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Ask about food interactions',
                      hintText:
                          'E.g., Can I eat spinach with blood thinners?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: foodProvider.isLoading
                          ? null
                          : () async {
                              await foodProvider
                                  .queryFoodMedicineCompatibility(
                                foodQuery: _queryController.text.trim(),
                              );
                            },
                      child: foodProvider.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryForeground,
                              ),
                            )
                          : const Text('Get AI Response'),
                    ),
                  ),
                ],
              ),
            ),
            if (foodProvider.result != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Response',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(foodProvider.result!),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Section 3: Vedic Food Guidance
            Text(
              'Vedic Wellness Guidance',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ...[
              {'title': 'Vata Balance', 'emoji': '💨'},
              {'title': 'Pitta Cooling', 'emoji': '🔥'},
              {'title': 'Kapha Lightness', 'emoji': '💧'},
            ].map((concern) {
              final isSelected = _selectedVedicConcern == concern['title'];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: vedProvider.isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedVedicConcern = concern['title'];
                              });
                              vedProvider.queryVedicWellness(
                                concern: concern['title']!,
                                dosha: concern['title']!,
                              );
                            },
                      child: AppCard(
                        child: Row(
                          children: [
                            Text(concern['emoji']!,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                concern['title']!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary)
                            else
                              const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                    if (isSelected && vedProvider.result != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: AppCard(
                          child: Text(vedProvider.result!),
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),

            // Section 4: Vedic Principles
            Text(
              'Vedic Food Principles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrinciple(context, 'Dharma', 'Right food for your nature'),
                  const SizedBox(height: AppSpacing.md),
                  _buildPrinciple(context, 'Ahimsa', 'Consume with mindfulness'),
                  const SizedBox(height: AppSpacing.md),
                  _buildPrinciple(
                      context, 'Satya', 'Pure, wholesome foods only'),
                  const SizedBox(height: AppSpacing.md),
                  _buildPrinciple(context, 'Arogya', 'Health through nature'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildPrinciple(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.mutedForeground)),
      ],
    );
  }
}
