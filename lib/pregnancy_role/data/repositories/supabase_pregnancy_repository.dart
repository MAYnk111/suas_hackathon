import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/pregnancy_model.dart';

class SupabasePregnancyRepository {
  SupabasePregnancyRepository({SupabaseClient? client})
      : _client = client ?? _tryGetClient();

  final SupabaseClient? _client;
  static const String _tableName = 'pregnancies';

  Future<void> savePregnancy(PregnancyModel pregnancy) async {
    if (_client == null) return;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'user_id': userId,
      'due_date': pregnancy.dueDate.toIso8601String(),
      'last_period_date': pregnancy.lastPeriodDate.toIso8601String(),
      'current_month': pregnancy.currentMonth,
      'monthly_checklists': pregnancy.monthlyChecklists,
      'completed_tests': pregnancy.completedTests,
      'risk_symptoms': pregnancy.riskSymptoms,
      'created_at': pregnancy.createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Try to update first, if no rows affected, insert
    final result = await _client!
        .from(_tableName)
        .update(data)
        .eq('user_id', userId)
        .select();

    if (result.isEmpty) {
      await _client!.from(_tableName).insert({
        ...data,
        'id': pregnancy.id,
      });
    }
  }

  Future<PregnancyModel?> getPregnancy() async {
    if (_client == null) return null;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client!
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .single();

      return _mapToPregnancyModel(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows found
        return null;
      }
      rethrow;
    }
  }

  Future<void> deletePregnancy(String id) async {
    if (_client == null) return;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client!.from(_tableName).delete().eq('id', id).eq('user_id', userId);
  }

  Future<void> clearAll() async {
    if (_client == null) return;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client!.from(_tableName).delete().eq('user_id', userId);
  }

  static SupabaseClient? _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  PregnancyModel _mapToPregnancyModel(Map<String, dynamic> data) {
    return PregnancyModel(
      id: data['id'] as String,
      dueDate: DateTime.parse(data['due_date'] as String),
      lastPeriodDate: DateTime.parse(data['last_period_date'] as String),
      currentMonth: data['current_month'] as int,
      monthlyChecklists: Map<int, bool>.from(
          data['monthly_checklists'] as Map<String, dynamic>? ?? {}),
      completedTests:
          List<String>.from(data['completed_tests'] as List<dynamic>? ?? []),
      riskSymptoms:
          List<String>.from(data['risk_symptoms'] as List<dynamic>? ?? []),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}

