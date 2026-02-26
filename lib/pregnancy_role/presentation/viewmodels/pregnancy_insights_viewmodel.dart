import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/models/pregnancy_model.dart';
import 'package:sudha_app/pregnancy_role/data/models/pregnant_daily_summary_model.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/pregnant_daily_summary_repository.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/pregnancy_repository.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';

enum InsightStatus { good, warning, alert }

class WaterIntakeInsight {
  final InsightStatus status;
  final String message;
  final int mlToday;
  final int recommendedMl;

  WaterIntakeInsight({
    required this.status,
    required this.message,
    required this.mlToday,
    this.recommendedMl = 2500,
  });
}

class BabyMovementInsight {
  final InsightStatus status;
  final String message;
  final bool hasMovement;
  final int? kickCount;

  BabyMovementInsight({
    required this.status,
    required this.message,
    required this.hasMovement,
    this.kickCount,
  });
}

class SymptomTrendInsight {
  final List<String> trendingSymptoms;
  final String message;
  final InsightStatus status;

  SymptomTrendInsight({
    required this.trendingSymptoms,
    required this.message,
    required this.status,
  });
}

class VitaminInsight {
  final bool takenToday;
  final int missedThisWeek;
  final String message;
  final InsightStatus status;

  VitaminInsight({
    required this.takenToday,
    required this.missedThisWeek,
    required this.message,
    required this.status,
  });
}

class PregnancyDailyInsight {
  final WaterIntakeInsight waterIntake;
  final BabyMovementInsight babyMovement;
  final SymptomTrendInsight symptoms;
  final VitaminInsight vitamins;

  PregnancyDailyInsight({
    required this.waterIntake,
    required this.babyMovement,
    required this.symptoms,
    required this.vitamins,
  });
}

class PregnancyInsightsViewModel extends StateNotifier<AsyncValue<PregnancyDailyInsight?>> {
  final PregnancyRepository pregnancyRepository;
  final PregnantDailySummaryRepository dailySummaryRepository;

  PregnancyInsightsViewModel({
    required this.pregnancyRepository,
    required this.dailySummaryRepository,
  }) : super(const AsyncValue.loading()) {
    // Automatically calculate insights for today when initialized
    _initializeInsights();
  }

  Future<void> _initializeInsights() async {
    await calculateInsights(DateTime.now());
  }

  /// Main method to calculate all insights for a given date
  Future<void> calculateInsights(DateTime selectedDate) async {
    state = const AsyncValue.loading();
    try {
      final pregnancy = pregnancyRepository.getPregnancy();
      if (pregnancy == null) {
        state = const AsyncValue.data(null);
        return;
      }

      // Get today's summary data
      final todaysSummary = dailySummaryRepository.getSummaryByDate(selectedDate);

      // Get last 7 days summaries for trend analysis
      final weekStart = selectedDate.subtract(const Duration(days: 6));
      final sevenDaysSummaries = dailySummaryRepository.getSummariesByDateRange(weekStart, selectedDate);

      // Calculate individual insights
      final waterInsight = _calculateWaterInsight(todaysSummary);
      final movementInsight = _calculateBabyMovementInsight(todaysSummary, sevenDaysSummaries, pregnancy);
      final symptomsInsight = _calculateSymptomTrendInsight(sevenDaysSummaries);
      final vitaminInsight = _calculateVitaminInsight(todaysSummary, sevenDaysSummaries);

      final insight = PregnancyDailyInsight(
        waterIntake: waterInsight,
        babyMovement: movementInsight,
        symptoms: symptomsInsight,
        vitamins: vitaminInsight,
      );

      state = AsyncValue.data(insight);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Calculate water intake status
  WaterIntakeInsight _calculateWaterInsight(PregnantDailySummaryModel? summary) {
    final mlToday = (summary?.waterIntakeMl ?? 0).toInt();
    const recommendedMl = 2500;

    if (mlToday == 0) {
      return WaterIntakeInsight(
        status: InsightStatus.alert,
        message: 'No water intake logged yet. Aim for 2.5L today.',
        mlToday: mlToday,
        recommendedMl: recommendedMl,
      );
    }

    if (mlToday < 1800) {
      return WaterIntakeInsight(
        status: InsightStatus.warning,
        message: 'Low hydration. Try to drink more water throughout the day.',
        mlToday: mlToday,
        recommendedMl: recommendedMl,
      );
    }

    if (mlToday >= 1800 && mlToday < 2500) {
      return WaterIntakeInsight(
        status: InsightStatus.warning,
        message: 'Adequate hydration. You can aim for a bit more.',
        mlToday: mlToday,
        recommendedMl: recommendedMl,
      );
    }

    return WaterIntakeInsight(
      status: InsightStatus.good,
      message: 'Great hydration! You\'re well-hydrated today.',
      mlToday: mlToday,
      recommendedMl: recommendedMl,
    );
  }

  /// Calculate baby movement insight (only for weeks ≥ 24)
  BabyMovementInsight _calculateBabyMovementInsight(
    PregnantDailySummaryModel? todaySummary,
    List<PregnantDailySummaryModel> weekSummaries,
    PregnancyModel pregnancy,
  ) {
    final weeksPregnant = pregnancy.weeksPregnant;

    // Before 24 weeks, fetal movement tracking is not standard
    if (weeksPregnant < 24) {
      return BabyMovementInsight(
        status: InsightStatus.good,
        message: 'Baby is developing! Movement tracking starts around week 24.',
        hasMovement: false,
      );
    }

    if (todaySummary == null || !todaySummary.babyMovementLogged) {
      return BabyMovementInsight(
        status: InsightStatus.alert,
        message: 'No baby movement logged yet today. Check in when you feel kicks!',
        hasMovement: false,
      );
    }

    final todayKicks = todaySummary.kickCount ?? 0;

    // Get average kicks from last 3 days (excluding today if not enough data)
    final recentSummaries = weekSummaries
        .where((s) =>
            s.babyMovementLogged &&
            s.date.isAfter(DateTime.now().subtract(const Duration(days: 3))) &&
            s.date.isBefore(DateTime.now()))
        .toList();

    if (recentSummaries.isEmpty) {
      return BabyMovementInsight(
        status: InsightStatus.good,
        message: 'Baby movements logged: $todayKicks kicks',
        hasMovement: true,
        kickCount: todayKicks,
      );
    }

    final avgKicks = recentSummaries.fold<int>(0, (sum, s) => sum + (s.kickCount ?? 0)) ~/ recentSummaries.length;

    // Alert if today's kicks are significantly lower (< 50% of average)
    if (avgKicks > 0 && todayKicks < (avgKicks * 0.5).toInt()) {
      return BabyMovementInsight(
        status: InsightStatus.warning,
        message: 'Baby movements lower than usual. Stay hydrated and rest, then monitor.',
        hasMovement: true,
        kickCount: todayKicks,
      );
    }

    return BabyMovementInsight(
      status: InsightStatus.good,
      message: 'Baby movements normal: $todayKicks kicks today',
      hasMovement: true,
      kickCount: todayKicks,
    );
  }

  /// Calculate symptom trends (detect if same symptom ≥ 3 consecutive days)
  SymptomTrendInsight _calculateSymptomTrendInsight(List<PregnantDailySummaryModel> weekSummaries) {
    if (weekSummaries.isEmpty) {
      return SymptomTrendInsight(
        trendingSymptoms: [],
        message: 'No symptom data logged yet.',
        status: InsightStatus.good,
      );
    }

    // Sort by date ascending
    final sorted = List<PregnantDailySummaryModel>.from(weekSummaries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final symptomFrequency = <String, int>{};
    const symptomsToCheck = ['Fatigue', 'Nausea', 'Back Pain', 'Swelling', 'Heartburn', 'Mood Changes'];

    // Count consecutive days for each symptom
    for (final symptom in symptomsToCheck) {
      for (final summary in sorted) {
        if (summary.symptoms.contains(symptom)) {
          symptomFrequency[symptom] = (symptomFrequency[symptom] ?? 0) + 1;
        }
      }
    }

    // Identify trending symptoms (≥3 occurrences in week)
    final trendingSymptoms = symptomsToCheck
        .where((s) => (symptomFrequency[s] ?? 0) >= 3)
        .toList();

    if (trendingSymptoms.isEmpty) {
      return SymptomTrendInsight(
        trendingSymptoms: [],
        message: 'No consistent symptom trends detected.',
        status: InsightStatus.good,
      );
    }

    final trendMsg = trendingSymptoms.join(', ');
    return SymptomTrendInsight(
      trendingSymptoms: trendingSymptoms,
      message: '$trendMsg occurring frequently this week.',
      status: InsightStatus.warning,
    );
  }

  /// Calculate prenatal vitamin compliance
  VitaminInsight _calculateVitaminInsight(
    PregnantDailySummaryModel? todaySummary,
    List<PregnantDailySummaryModel> weekSummaries,
  ) {
    if (todaySummary == null) {
      return VitaminInsight(
        takenToday: false,
        missedThisWeek: 0,
        message: 'Log your prenatal vitamin intake for today.',
        status: InsightStatus.alert,
      );
    }

    final takenToday = todaySummary.prenatalVitaminsTaken;

    // Count missed days this week
    final missedCount = weekSummaries.where((s) => !s.prenatalVitaminsTaken).length;

    if (!takenToday) {
      return VitaminInsight(
        takenToday: false,
        missedThisWeek: missedCount + 1,
        message: 'Don\'t forget your prenatal vitamin today!',
        status: InsightStatus.alert,
      );
    }

    if (missedCount >= 2) {
      return VitaminInsight(
        takenToday: true,
        missedThisWeek: missedCount,
        message: 'Good! You took it today. But you missed $missedCount days this week.',
        status: InsightStatus.warning,
      );
    }

    return VitaminInsight(
      takenToday: true,
      missedThisWeek: missedCount,
      message: 'Excellent! Consistent with prenatal vitamins this week.',
      status: InsightStatus.good,
    );
  }
}

final pregnancyInsightsViewModelProvider =
    StateNotifierProvider.autoDispose<PregnancyInsightsViewModel, AsyncValue<PregnancyDailyInsight?>>((ref) {
  final pregnancyRepo = ref.watch(pregnancyRepositoryProvider);
  final dailySummaryRepo = ref.watch(pregnantDailySummaryRepositoryProvider);

  return pregnancyRepo.when(
    data: (preg) {
      return dailySummaryRepo.when(
        data: (daily) {
          return PregnancyInsightsViewModel(
            pregnancyRepository: preg,
            dailySummaryRepository: daily,
          );
        },
        loading: () => PregnancyInsightsViewModel(
          pregnancyRepository: preg,
          dailySummaryRepository: PregnantDailySummaryRepository(),
        ),
        error: (e, st) => throw e,
      );
    },
    loading: () => throw Exception('Pregnancy repo loading'),
    error: (e, st) => throw e,
  );
});

