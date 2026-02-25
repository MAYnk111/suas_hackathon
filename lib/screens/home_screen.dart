import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import '../providers/alerts_provider.dart';
import '../providers/bottom_nav_provider.dart';
import 'medicine_safety_screen.dart';
import 'food_guidance_screen.dart';
import 'ai_assistant_screen.dart';
import 'vedic_wellness_screen.dart';
import 'trust_ethics_screen.dart';
import 'sos_emergency_screen.dart';
import 'public_health_impact_screen.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/summary_card.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardProvider>().loadDashboard();
      context.read<AlertsProvider>().loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final alerts = context.watch<AlertsProvider>();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final dashboardProvider = context.read<DashboardProvider>();
          final alertsProvider = context.read<AlertsProvider>();
          await dashboardProvider.loadDashboard();
          await alertsProvider.loadAlerts();
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('SUDHA', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 6),
            Text(
              'Healthcare overview and safety tools',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Status', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (dashboard.isLoading)
                    const LinearProgressIndicator()
                  else if (dashboard.error != null)
                    Text(dashboard.error!, style: const TextStyle(color: AppTheme.destructive))
                  else
                    Text(
                      '${dashboard.status} (v${dashboard.version})',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.mutedForeground),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(
              title: 'Quick Actions',
              subtitle: 'All sections of the SUDHA platform',
            ),
            _QuickActionGrid(context),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: 'Alerts Preview',
              subtitle: 'Upcoming reminders and notifications',
              trailing: TextButton(
                onPressed: () => context.read<BottomNavProvider>().setIndex(2),
                child: const Text('View all'),
              ),
            ),
            if (alerts.isLoading)
              const LinearProgressIndicator()
            else if (alerts.error != null)
              Text(alerts.error!, style: const TextStyle(color: AppTheme.destructive))
            else
              ...alerts.alerts.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: alert.severity == 'high'
                                  ? AppTheme.destructive
                                  : alert.severity == 'medium'
                                      ? AppTheme.coral
                                      : AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alert.title, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(alert.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppTheme.mutedForeground)),
                              ],
                            ),
                          ),
                          Text(alert.time,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.mutedForeground)),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

Widget _QuickActionGrid(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: SummaryCard(
              icon: Icons.shield_outlined,
              title: 'Medicine Safety',
              description: 'Verify medicines',
              backgroundColor: AppTheme.warm,
              foregroundColor: AppTheme.warmForeground,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MedicineSafetyScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SummaryCard(
              icon: Icons.monitor_heart_outlined,
              title: 'Symptoms',
              description: 'Check symptoms',
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.accentForeground,
              onTap: () => context.read<BottomNavProvider>().setIndex(1),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        children: [
          Expanded(
            child: SummaryCard(
              icon: Icons.restaurant_menu,
              title: 'Nutrition',
              description: 'Food guidance',
              backgroundColor: AppTheme.sage,
              foregroundColor: AppTheme.sageForeground,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FoodGuidanceScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SummaryCard(
              icon: Icons.chat_outlined,
              title: 'AI Assistant',
              description: 'Ask questions',
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.primaryForeground,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        children: [
          Expanded(
            child: SummaryCard(
              icon: Icons.spa_outlined,
              title: 'Vedic Wellness',
              description: 'Arogya wisdom',
              backgroundColor: AppTheme.coral,
              foregroundColor: AppTheme.coral,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VedicWellnessScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SummaryCard(
              icon: Icons.gavel_outlined,
              title: 'Ethics',
              description: 'Trust & values',
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.primaryForeground,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TrustEthicsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        children: [
          Expanded(
            child: SummaryCard(
              icon: Icons.emergency_outlined,
              title: 'SOS',
              description: 'Emergency info',
              backgroundColor: AppTheme.destructive,
              foregroundColor: Colors.white,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SOSEmergencyScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SummaryCard(
              icon: Icons.public_outlined,
              title: 'Public Health',
              description: 'Our impact',
              backgroundColor: AppTheme.sage,
              foregroundColor: AppTheme.sageForeground,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PublicHealthImpactScreen()),
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
    ],
  );
}
