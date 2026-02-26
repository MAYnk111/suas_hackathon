import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/fertile_window_viewmodel.dart';

class FertileWindowVisualizationPage extends ConsumerWidget {
  const FertileWindowVisualizationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fertileWindowViewModelProvider);
    final viewModel = ref.read(fertileWindowViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertile Window'),
        elevation: 0,
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? _buildErrorState(context, state.errorMessage!)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInfoBanner(context),
                      _buildCalendarHeader(context, state, viewModel),
                      _buildCalendarGrid(context, state),
                      const SizedBox(height: 24),
                      _buildCycleTimeline(context, state),
                      const SizedBox(height: 24),
                      _buildLegend(context),
                      const SizedBox(height: 24),
                      _buildFertilityInfo(context, state, viewModel),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fertility windows are estimates based on logged data.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(
    BuildContext context,
    FertileWindowState state,
    FertileWindowViewModel viewModel,
  ) {
    final monthFormat = DateFormat('MMMM yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => viewModel.previousMonth(),
            tooltip: 'Previous month',
          ),
          Column(
            children: [
              Text(
                monthFormat.format(state.displayMonth),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                onPressed: () => viewModel.goToToday(),
                icon: const Icon(Icons.today, size: 16),
                label: const Text('Today'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => viewModel.nextMonth(),
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, FertileWindowState state) {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Week day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          _buildMonthGrid(context, state),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(BuildContext context, FertileWindowState state) {
    if (state.monthDays.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get the first day of the month to calculate offset
    final firstDay = DateTime(state.displayMonth.year, state.displayMonth.month, 1);
    final firstWeekday = firstDay.weekday % 7; // Sunday = 0

    // Create grid including empty cells for offset
    final List<Widget> cells = [];

    // Add empty cells for days before month starts
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Add day cells
    for (final dayData in state.monthDays) {
      cells.add(_buildDayCell(context, dayData));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: cells,
    );
  }

  Widget _buildDayCell(BuildContext context, FertileDayData dayData) {
    Color backgroundColor;
    Color textColor;
    bool hasBorder = false;

    // Determine color based on fertility status
    switch (dayData.status) {
      case FertilityDayStatus.ovulation:
        backgroundColor = const Color(0xFFE53935); // Red for ovulation
        textColor = Colors.white;
        break;
      case FertilityDayStatus.fertile:
        backgroundColor = const Color(0xFF66BB6A); // Green for fertile window
        textColor = Colors.white;
        break;
      case FertilityDayStatus.lowFertility:
        backgroundColor = Theme.of(context).colorScheme.surface;
        textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
        break;
    }

    // Highlight today with a border
    if (dayData.isToday) {
      hasBorder = true;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Center(
        child: Text(
          '${dayData.date.day}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: dayData.isToday ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildCycleTimeline(BuildContext context, FertileWindowState state) {
    if (state.profile == null ||
        state.ovulationDate == null ||
        state.fertileWindowStart == null ||
        state.fertileWindowEnd == null) {
      return const SizedBox.shrink();
    }

    final cycleLength = state.profile!.avgCycleLength;
    final ovulationDay = state.profile!.avgCycleLength - 14;
    final fertileStartDay = ovulationDay - 4;
    final fertileEndDay = ovulationDay + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cycle Timeline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Timeline visualization
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Stack(
              children: [
                // Fertile window bar
                Positioned(
                  left: (fertileStartDay / cycleLength) * MediaQuery.of(context).size.width * 0.8,
                  width: ((fertileEndDay - fertileStartDay) / cycleLength) *
                      MediaQuery.of(context).size.width *
                      0.8,
                  top: 10,
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF66BB6A).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Ovulation marker
                Positioned(
                  left: (ovulationDay / cycleLength) * MediaQuery.of(context).size.width * 0.8,
                  top: 5,
                  bottom: 5,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Day markers
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimelineMarker(context, '1', 'Day 1'),
                      _buildTimelineMarker(context, '●', 'Ovulation\nDay $ovulationDay'),
                      _buildTimelineMarker(context, cycleLength.toString(), 'Day $cycleLength'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Timeline legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimelineLegendItem(
                context,
                const Color(0xFF66BB6A),
                'Fertile Window\n($fertileStartDay-$fertileEndDay)',
              ),
              _buildTimelineLegendItem(
                context,
                const Color(0xFFE53935),
                'Ovulation\n(Day $ovulationDay)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMarker(BuildContext context, String label, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildTimelineLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                context,
                const Color(0xFF66BB6A),
                'Fertile Days',
              ),
              _buildLegendItem(
                context,
                const Color(0xFFE53935),
                'Ovulation',
              ),
              _buildLegendItem(
                context,
                Theme.of(context).colorScheme.surface,
                'Low Fertility',
                textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    Color color,
    String label, {
    Color? textColor,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
              ),
        ),
      ],
    );
  }

  Widget _buildFertilityInfo(
    BuildContext context,
    FertileWindowState state,
    FertileWindowViewModel viewModel,
  ) {
    final daysUntilOvulation = viewModel.getDaysUntilOvulation();
    final isInFertileWindow = viewModel.isInFertileWindow();

    if (daysUntilOvulation == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        color: isInFertileWindow
            ? const Color(0xFF66BB6A).withOpacity(0.1)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isInFertileWindow) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFF66BB6A),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You are in your fertile window!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF66BB6A),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is the best time for conception.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ] else if (daysUntilOvulation > 0) ...[
                Text(
                  'Days until predicted ovulation:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$daysUntilOvulation',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ] else if (daysUntilOvulation == 0) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color(0xFFE53935),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ovulation predicted today!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE53935),
                            ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  'Ovulation has passed for this cycle.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

