import 'package:hive_flutter/hive_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/pregnant_daily_summary_model.dart';

class PregnantDailySummaryRepository {
  static const String boxName = 'pregnant_daily_summaries';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<PregnantDailySummaryModel>(boxName);
    }
  }

  Box<PregnantDailySummaryModel> getBox() {
    return Hive.box<PregnantDailySummaryModel>(boxName);
  }

  Future<void> saveSummary(PregnantDailySummaryModel summary) async {
    final box = getBox();
    await box.put(summary.id, summary);
  }

  PregnantDailySummaryModel? getSummaryByDate(DateTime date) {
    final box = getBox();
    final dateKey = _formatDate(date);
    
    for (final summary in box.values) {
      if (_formatDate(summary.date) == dateKey) {
        return summary;
      }
    }
    return null;
  }

  List<PregnantDailySummaryModel> getSummariesByDateRange(DateTime start, DateTime end) {
    final box = getBox();
    final results = <PregnantDailySummaryModel>[];
    
    for (final summary in box.values) {
      if (summary.date.isAfter(start) && summary.date.isBefore(end.add(const Duration(days: 1)))) {
        results.add(summary);
      }
    }
    
    results.sort((a, b) => a.date.compareTo(b.date));
    return results;
  }

  List<PregnantDailySummaryModel> getAllSummaries() {
    final box = getBox();
    return box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
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

