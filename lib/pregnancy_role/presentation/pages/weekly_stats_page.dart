import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_meta_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/data/models/kick_log_model.dart';
import 'package:sudha_app/pregnancy_role/data/models/contraction_model.dart';
import 'package:sudha_app/pregnancy_role/core/services/centralized_translations.dart';

class WeeklyStatsPage extends ConsumerStatefulWidget {
  const WeeklyStatsPage({super.key});

  @override
  ConsumerState<WeeklyStatsPage> createState() => _WeeklyStatsPageState();
}

class _WeeklyStatsPageState extends ConsumerState<WeeklyStatsPage> {
  DateTime _weekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  void _changeWeek(int weeks) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * weeks));
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final userMeta = ref.watch(userMetaProvider);
    final isPregnant = userMeta.role == UserProfileType.pregnant;
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final dateRangeText =
        '${DateFormat('MMM d').format(_weekStart)} - ${DateFormat('MMM d, y').format(weekEnd)}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Tr('weekly_stats.title'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Theme-aware Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _getBackgroundGradientColors(context),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Week Navigator
                _buildWeekNavigator(context, dateRangeText, weekEnd),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: isPregnant
                        ? _buildPregnancyWeeklyAnalysis(context)
                        : _buildInfantWeeklyAnalysis(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBackgroundGradientColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFF1a1a2e),
        const Color(0xFF16213e),
      ];
    } else {
      return [
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor,
      ];
    }
  }

  Widget _buildWeekNavigator(
      BuildContext context, String dateRangeText, DateTime weekEnd) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => _changeWeek(-1),
            color: theme.colorScheme.primary,
          ),
          Flexible(
            child: Text(
              dateRangeText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: weekEnd
                    .isAfter(DateTime.now().subtract(const Duration(days: 1)))
                ? null
                : () => _changeWeek(1),
            color: weekEnd
                    .isAfter(DateTime.now().subtract(const Duration(days: 1)))
                ? theme.disabledColor
                : theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyWeeklyAnalysis(BuildContext context) {
    final kickRepo = ref.watch(kickLogRepositoryProvider);
    final contractionRepo = ref.watch(contractionRepositoryProvider);

    return Column(
      children: [
        // Baby Kicks Analysis
        kickRepo.when(
          data: (repo) {
            final allKicks = repo.getHistory() as List<KickLogModel>;
            final weeklyKicks = <double>[];
            for (int i = 0; i < 7; i++) {
              final date = _weekStart.add(Duration(days: i));
              final dayKicks = allKicks
                  .where((k) => _isSameDay(k.sessionStart, date))
                  .toList();
              final totalKicks =
                  dayKicks.fold<int>(0, (sum, k) => sum + (k.kickCount ?? 0));
              weeklyKicks.add(totalKicks.toDouble());
            }
            return _buildAnalysisCard(
              context,
              'Baby Kicks Trend',
              weeklyKicks,
              Colors.pink,
              'kicks',
            );
          },
          loading: () => const _LoadingChart(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 20),

        // Contractions Analysis
        contractionRepo.when(
          data: (repo) {
            final allContractions =
                repo.getContractions() as List<ContractionModel>;
            final weeklyContractions = <double>[];
            for (int i = 0; i < 7; i++) {
              final date = _weekStart.add(Duration(days: i));
              final dayContractions = allContractions
                  .where((c) => _isSameDay(c.startTime, date))
                  .toList();
              weeklyContractions.add(dayContractions.length.toDouble());
            }
            return _buildAnalysisCard(
              context,
              'Contractions Tracking',
              weeklyContractions,
              Colors.deepOrange,
              'contractions',
            );
          },
          loading: () => const _LoadingChart(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 20),

        // Pregnancy Health Summary
        _buildPregnancyHealthSummary(context),
      ],
    );
  }

  Widget _buildInfantWeeklyAnalysis(BuildContext context) {
    final feedingRepo = ref.watch(feedingRepositoryProvider);
    final sleepRepo = ref.watch(sleepRepositoryProvider);
    final diaperRepo = ref.watch(diaperRepositoryProvider);

    return Column(
      children: [
        feedingRepo.when(
          data: (repo) {
            final feedingData = _getFeedingData(repo, _weekStart);
            return _buildAnalysisCard(
              context,
              'Feeding (ml)',
              feedingData,
              Colors.orange,
              'ml',
            );
          },
          loading: () => const _LoadingChart(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 20),
        sleepRepo.when(
          data: (repo) {
            final sleepData = _getSleepData(repo, _weekStart);
            return _buildAnalysisCard(
              context,
              'Sleep (hours)',
              sleepData,
              Colors.indigo,
              'hrs',
            );
          },
          loading: () => const _LoadingChart(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 20),
        diaperRepo.when(
          data: (repo) {
            final diaperData = _getDiaperData(repo, _weekStart);
            return _buildAnalysisCard(
              context,
              'Diaper Changes',
              diaperData,
              Colors.teal,
              'changes',
            );
          },
          loading: () => const _LoadingChart(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPregnancyHealthSummary(BuildContext context) {
    final theme = Theme.of(context);
    final kickRepo = ref.watch(kickLogRepositoryProvider);
    final contractionRepo = ref.watch(contractionRepositoryProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite,
                    color: theme.colorScheme.primary, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Weekly Health Summary',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          kickRepo.when(
            data: (kickRepoData) {
              final allKicks = kickRepoData.getHistory() as List<KickLogModel>;
              final weeklyKicks = allKicks.where((k) {
                final daysDiff = k.sessionStart.difference(_weekStart).inDays;
                return daysDiff >= 0 && daysDiff < 7;
              }).toList();
              final totalKicks = weeklyKicks.fold<int>(
                  0, (sum, k) => sum + (k.kickCount ?? 0));
              final avgKicksPerSession = weeklyKicks.isNotEmpty
                  ? (totalKicks / weeklyKicks.length).toStringAsFixed(1)
                  : '0';

              return _buildSummaryItem(
                context,
                'Total Baby Kicks',
                '$totalKicks',
                'Avg: $avgKicksPerSession per session',
                Icons.favorite,
                Colors.pink,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          contractionRepo.when(
            data: (contractionRepoData) {
              final allContractions = contractionRepoData.getContractions()
                  as List<ContractionModel>;
              final weeklyContractions = allContractions.where((c) {
                final daysDiff = c.startTime.difference(_weekStart).inDays;
                return daysDiff >= 0 && daysDiff < 7;
              }).toList();

              return _buildSummaryItem(
                context,
                'Contractions Recorded',
                '${weeklyContractions.length}',
                'Track them closely for patterns',
                Icons.psychology,
                Colors.deepOrange,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            context,
            'Hydration Goal',
            '8-10',
            'glasses per day recommended',
            Icons.local_drink,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    String title,
    List<double> weeklyData,
    Color color,
    String unit,
  ) {
    final theme = Theme.of(context);
    final maxY = weeklyData.isNotEmpty
        ? weeklyData.reduce((curr, next) => curr > next ? curr : next)
        : 0.0;
    final targetY = maxY == 0 ? 10.0 : maxY * 1.2;

    // Calculate statistics
    final avgValue = weeklyData.isEmpty
        ? 0.0
        : weeklyData.reduce((a, b) => a + b) / weeklyData.length;
    final maxValue = maxY;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bar_chart, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Statistics Row
          Row(
            children: [
              Expanded(
                child: _buildStatistic(context, 'Average',
                    '${avgValue.toStringAsFixed(1)} $unit', color),
              ),
              Expanded(
                child: _buildStatistic(context, 'Peak',
                    '${maxValue.toStringAsFixed(1)} $unit', color),
              ),
              Expanded(
                child: _buildStatistic(context, 'Days',
                    '${weeklyData.where((v) => v > 0).length}/7', color),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bar Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: targetY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: color,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)} $unit',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: targetY / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: color.withOpacity(0.8),
                        width: 14,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: targetY,
                          color: color.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<double> _getFeedingData(dynamic repo, DateTime start) {
    List<double> data = [];
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final feedings = repo.getFeedingsByDate(date);
      final total =
          feedings.fold(0.0, (sum, item) => sum + (item.quantity as double));
      data.add(total);
    }
    return data;
  }

  List<double> _getSleepData(dynamic repo, DateTime start) {
    List<double> data = [];
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      data.add(repo.getTotalSleepHoursByDate(date));
    }
    return data;
  }

  List<double> _getDiaperData(dynamic repo, DateTime start) {
    List<double> data = [];
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      data.add(repo.getDiapersByDate(date).length.toDouble());
    }
    return data;
  }
}

class _LoadingChart extends StatelessWidget {
  const _LoadingChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

