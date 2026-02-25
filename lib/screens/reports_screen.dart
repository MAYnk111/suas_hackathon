import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ReportsProvider>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SectionHeader(
            title: 'Reports',
            subtitle: 'Trends and summary analytics',
          ),
          if (reports.isLoading)
            const LinearProgressIndicator()
          else if (reports.error != null)
            Text(reports.error!, style: const TextStyle(color: AppTheme.destructive))
          else ...[
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: reports.summary
                  .map(
                    (item) => SizedBox(
                      width: 160,
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8),
                            Text(item.value, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: reports.chart.map((p) => FlSpot(p.x, p.y)).toList(),
                        isCurved: true,
                        color: AppTheme.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
