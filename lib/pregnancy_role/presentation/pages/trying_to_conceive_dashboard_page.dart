import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sudha_app/pregnancy_role/data/models/dashboard_card_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/widgets/customizable_dashboard.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_meta_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/fertile_window_visualization_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/ovulation_prediction_page.dart';

class TryingToConceiveDashboardPage extends ConsumerWidget {
  const TryingToConceiveDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomizableDashboard(
      header: _buildHeader(context, ref),
      cardBuilder: (context, card) => _buildCardContent(context, ref, card),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userMeta = ref.watch(userMetaProvider);
    final username = userMeta.username;
    final displayName = (username != null && username.isNotEmpty) ? username : 'Friend';

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Namaste, $displayName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.secondary, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Fertility awareness through balanced health and ऋतुचक्र (menstrual cycle) tracking.',
            softWrap: true,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, WidgetRef ref, DashboardCardModel card) {
    print('DEBUG TTC: Building card with widgetType: ${card.widgetType}, title: ${card.title}');
    switch (card.widgetType) {
      case 'fertility_overview':
        return _buildFertilityOverview(context, ref);
      case 'ovulation_window':
        return _buildOvulationWindow(context, ref);
      case 'ovulation_prediction':
        print('DEBUG TTC: Building ovulation_prediction card');
        return _buildOvulationPredictionCard(context);
      case 'daily_tips':
        return _buildFertilityTips(context);
      default:
        return _buildPlaceholderCard(context, card.title);
    }
  }

  Widget _buildFertilityOverview(BuildContext context, WidgetRef ref) {
    final fertilityProfile = ref.watch(fertilityProfileProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: fertilityProfile.when(
          data: (profile) {
            if (profile == null) {
              return const Text('Complete setup to see your fertility overview.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fertility Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildRow('LMP Date', DateFormat('MMM dd, yyyy').format(profile.lmpDate)),
                _buildRow('Avg Cycle Length', '${profile.avgCycleLength} days'),
                _buildRow('Cycle Regular', profile.cycleRegular ? 'Yes' : 'No'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error loading fertility data: $e'),
        ),
      ),
    );
  }

  Widget _buildOvulationWindow(BuildContext context, WidgetRef ref) {
    final fertilityProfile = ref.watch(fertilityProfileProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: fertilityProfile.when(
          data: (profile) {
            if (profile == null) {
              return const Text('Complete setup to estimate your ovulation window.');
            }

            final ovulationDay = profile.lmpDate.add(Duration(days: profile.avgCycleLength - 14));
            final windowStart = ovulationDay.subtract(const Duration(days: 5));
            final windowEnd = ovulationDay.add(const Duration(days: 1));
            final dateFormat = DateFormat('MMM dd');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Ovulation Window',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '${dateFormat.format(windowStart)} - ${dateFormat.format(windowEnd)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on your average cycle length.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FertileWindowVisualizationPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('View Calendar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error loading fertility data: $e'),
        ),
      ),
    );
  }

  Widget _buildFertilityTips(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fertility Tips',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Track your cycle regularly, maintain a balanced diet, and prioritize sleep for optimal fertility.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOvulationPredictionCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'ML Ovulation Prediction',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Use advanced machine learning to predict your exact ovulation day based on your cycle parameters.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OvulationPredictionPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.trending_up),
                label: const Text('Predict Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(BuildContext context, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(title),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}

