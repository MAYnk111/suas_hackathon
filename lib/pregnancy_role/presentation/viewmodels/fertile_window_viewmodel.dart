import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/models/fertility_profile_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';

/// Represents the fertility status of a specific day
enum FertilityDayStatus {
  lowFertility,
  fertile,
  ovulation,
}

/// Data model for a day in the fertile window visualization
class FertileDayData {
  final DateTime date;
  final FertilityDayStatus status;
  final bool isToday;

  FertileDayData({
    required this.date,
    required this.status,
    required this.isToday,
  });
}

/// ViewModel for Fertile Window Visualization
class FertileWindowState {
  final DateTime? ovulationDate;
  final DateTime? fertileWindowStart;
  final DateTime? fertileWindowEnd;
  final List<FertileDayData> monthDays;
  final DateTime displayMonth;
  final FertilityProfileModel? profile;
  final bool isLoading;
  final String? errorMessage;

  FertileWindowState({
    this.ovulationDate,
    this.fertileWindowStart,
    this.fertileWindowEnd,
    this.monthDays = const [],
    required this.displayMonth,
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  FertileWindowState copyWith({
    DateTime? ovulationDate,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
    List<FertileDayData>? monthDays,
    DateTime? displayMonth,
    FertilityProfileModel? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FertileWindowState(
      ovulationDate: ovulationDate ?? this.ovulationDate,
      fertileWindowStart: fertileWindowStart ?? this.fertileWindowStart,
      fertileWindowEnd: fertileWindowEnd ?? this.fertileWindowEnd,
      monthDays: monthDays ?? this.monthDays,
      displayMonth: displayMonth ?? this.displayMonth,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FertileWindowViewModel extends StateNotifier<FertileWindowState> {
  final FertilityProfileModel? fertilityProfile;

  FertileWindowViewModel(this.fertilityProfile)
      : super(FertileWindowState(displayMonth: DateTime.now())) {
    _initialize();
  }

  void _initialize() {
    if (fertilityProfile == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No fertility profile found. Please complete setup first.',
      );
      return;
    }

    _calculateFertileWindow();
    _buildMonthDays(state.displayMonth);
  }

  /// Calculate ovulation day and fertile window based on LMP and cycle length
  /// Ovulation day ≈ avg_cycle_length − 14
  /// Fertile window = ovulation day − 4 to ovulation day + 1
  void _calculateFertileWindow() {
    if (fertilityProfile == null) return;

    try {
      // Calculate predicted ovulation day
      final ovulationDay = fertilityProfile!.lmpDate.add(
        Duration(days: fertilityProfile!.avgCycleLength - 14),
      );

      // Fertile window: 4 days before ovulation to 1 day after
      final windowStart = ovulationDay.subtract(const Duration(days: 4));
      final windowEnd = ovulationDay.add(const Duration(days: 1));

      state = state.copyWith(
        ovulationDate: ovulationDay,
        fertileWindowStart: windowStart,
        fertileWindowEnd: windowEnd,
        profile: fertilityProfile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error calculating fertile window: $e',
      );
    }
  }

  /// Build list of days for the calendar month view
  void _buildMonthDays(DateTime month) {
    if (state.ovulationDate == null) return;

    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final today = DateTime.now();

    final List<FertileDayData> days = [];

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final currentDate = DateTime(month.year, month.month, day);
      final status = _getDayStatus(currentDate);
      final isToday = currentDate.year == today.year &&
          currentDate.month == today.month &&
          currentDate.day == today.day;

      days.add(FertileDayData(
        date: currentDate,
        status: status,
        isToday: isToday,
      ));
    }

    state = state.copyWith(monthDays: days);
  }

  /// Determine the fertility status of a specific day
  FertilityDayStatus _getDayStatus(DateTime date) {
    if (state.ovulationDate == null) return FertilityDayStatus.lowFertility;

    final dateOnly = DateTime(date.year, date.month, date.day);
    final ovulationOnly = DateTime(
      state.ovulationDate!.year,
      state.ovulationDate!.month,
      state.ovulationDate!.day,
    );

    // Check if it's ovulation day
    if (dateOnly.isAtSameMomentAs(ovulationOnly)) {
      return FertilityDayStatus.ovulation;
    }

    // Check if it's within fertile window
    if (state.fertileWindowStart != null && state.fertileWindowEnd != null) {
      final startOnly = DateTime(
        state.fertileWindowStart!.year,
        state.fertileWindowStart!.month,
        state.fertileWindowStart!.day,
      );
      final endOnly = DateTime(
        state.fertileWindowEnd!.year,
        state.fertileWindowEnd!.month,
        state.fertileWindowEnd!.day,
      );

      if ((dateOnly.isAfter(startOnly) || dateOnly.isAtSameMomentAs(startOnly)) &&
          (dateOnly.isBefore(endOnly) || dateOnly.isAtSameMomentAs(endOnly))) {
        return FertilityDayStatus.fertile;
      }
    }

    return FertilityDayStatus.lowFertility;
  }

  /// Navigate to next month
  void nextMonth() {
    final newMonth = DateTime(
      state.displayMonth.year,
      state.displayMonth.month + 1,
      1,
    );
    state = state.copyWith(displayMonth: newMonth);
    _buildMonthDays(newMonth);
  }

  /// Navigate to previous month
  void previousMonth() {
    final newMonth = DateTime(
      state.displayMonth.year,
      state.displayMonth.month - 1,
      1,
    );
    state = state.copyWith(displayMonth: newMonth);
    _buildMonthDays(newMonth);
  }

  /// Go to current month
  void goToToday() {
    final today = DateTime.now();
    final currentMonth = DateTime(today.year, today.month, 1);
    state = state.copyWith(displayMonth: currentMonth);
    _buildMonthDays(currentMonth);
  }

  /// Get days until ovulation from today
  int? getDaysUntilOvulation() {
    if (state.ovulationDate == null) return null;
    final today = DateTime.now();
    final difference = state.ovulationDate!.difference(today).inDays;
    return difference;
  }

  /// Check if currently in fertile window
  bool isInFertileWindow() {
    if (state.fertileWindowStart == null || state.fertileWindowEnd == null) {
      return false;
    }
    final today = DateTime.now();
    return today.isAfter(state.fertileWindowStart!) &&
        today.isBefore(state.fertileWindowEnd!);
  }
}

/// Provider for FertileWindowViewModel
final fertileWindowViewModelProvider =
    StateNotifierProvider<FertileWindowViewModel, FertileWindowState>((ref) {
  final fertilityProfileAsync = ref.watch(fertilityProfileProvider);
  
  return fertilityProfileAsync.when(
    data: (profile) => FertileWindowViewModel(profile),
    loading: () => FertileWindowViewModel(null),
    error: (_, __) => FertileWindowViewModel(null),
  );
});

