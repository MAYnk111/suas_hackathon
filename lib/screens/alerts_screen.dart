import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alerts_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AlertsProvider>().loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertsProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SectionHeader(
            title: 'Alerts',
            subtitle: 'Reminders and important notifications',
          ),
          if (alerts.isLoading)
            const LinearProgressIndicator()
          else if (alerts.error != null)
            Text(alerts.error!, style: const TextStyle(color: AppTheme.destructive))
          else
            ...alerts.alerts.map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.muted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: alert.severity == 'high'
                              ? AppTheme.destructive
                              : alert.severity == 'medium'
                                  ? AppTheme.coral
                                  : AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alert.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text(
                              alert.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      Text(alert.time, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
