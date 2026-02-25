import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/food_guidance_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class FoodGuidanceScreen extends StatefulWidget {
  const FoodGuidanceScreen({super.key});

  @override
  State<FoodGuidanceScreen> createState() => _FoodGuidanceScreenState();
}

class _FoodGuidanceScreenState extends State<FoodGuidanceScreen> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _submitQuery() async {
    final provider = context.read<FoodGuidanceProvider>();
    await provider.queryFoodMedicineCompatibility(
      foodQuery: _queryController.text.trim(),
    );

    if (provider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodGuidanceProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
          const SectionHeader(
            title: 'Nutrition & Food Guidance',
            subtitle: 'Understand the nutrients in your daily foods',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '🌿 Everyday Foods & Their Health Contributions',
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
                          Text('Turmeric', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Anti-inflammatory properties',
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
                          Text('Leafy Vegetables', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Iron & haemoglobin support',
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
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🧂', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Iodized Salt', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Iodine intake',
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
                const SizedBox(height: 12),
                Text(
                  'Essential for thyroid function and metabolic health.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Ask About Food-Medicine Compatibility',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: TextField(
              controller: _queryController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Enter your food-medicine question',
                hintText: 'e.g., Can I eat spinach while taking a blood thinner?',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: foodProvider.isLoading ? null : _submitQuery,
              child: foodProvider.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryForeground,
                      ),
                    )
                  : const Text('Ask AI Assistant'),
            ),
          ),
          if (foodProvider.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Text(
                foodProvider.error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.destructive,
                    ),
              ),
            ),
          ],
          if (foodProvider.result != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Response', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(foodProvider.result!),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Text(
                '⚠️ For awareness only. Always consult a healthcare provider before making dietary changes, especially if you are on medication.',
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
