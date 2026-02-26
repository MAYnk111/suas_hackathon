import 'package:hive_flutter/hive_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/pregnant_weekly_summary_model.dart';

class PregnantWeeklySummaryRepository {
  static const String boxName = 'pregnant_weekly_summaries';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<PregnantWeeklySummaryModel>(boxName);
    }
  }

  Box<PregnantWeeklySummaryModel> getBox() {
    return Hive.box<PregnantWeeklySummaryModel>(boxName);
  }

  Future<void> saveSummary(PregnantWeeklySummaryModel summary) async {
    final box = getBox();
    await box.put(summary.id, summary);
  }

  PregnantWeeklySummaryModel? getSummaryByWeek(DateTime weekStart) {
    final box = getBox();
    final weekKey = _formatDate(weekStart);
    
    for (final summary in box.values) {
      if (_formatDate(summary.weekStart) == weekKey) {
        return summary;
      }
    }
    return null;
  }

  List<PregnantWeeklySummaryModel> getSummariesByDateRange(DateTime start, DateTime end) {
    final box = getBox();
    final results = <PregnantWeeklySummaryModel>[];
    
    for (final summary in box.values) {
      if (summary.weekStart.isAfter(start.subtract(const Duration(days: 7))) && 
          summary.weekStart.isBefore(end.add(const Duration(days: 7)))) {
        results.add(summary);
      }
    }
    
    results.sort((a, b) => a.weekStart.compareTo(b.weekStart));
    return results;
  }

  List<PregnantWeeklySummaryModel> getAllSummaries() {
    final box = getBox();
    return box.values.toList()..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  }

  Future<void> deleteSummary(String id) async {
    final box = getBox();
    await box.delete(id);
  }

  Future<void> clear() async {
    final box = getBox();
    await box.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

