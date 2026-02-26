import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/growth_model.dart';

class SupabaseGrowthRepository {
  SupabaseGrowthRepository({SupabaseClient? client})
      : _client = client ?? _tryGetClient();

  final SupabaseClient? _client;
  static const String _tableName = 'growth_records';

  Future<void> saveGrowth(GrowthModel growth) async {
    if (_client == null) return;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'id': growth.id,
      'user_id': userId,
      'timestamp': growth.timestamp.toIso8601String(),
      'weight': growth.weight,
      'height': growth.height,
      'head_circumference': growth.headCircumference,
      'age_in_days': growth.ageInDays,
      'notes': growth.notes,
    };

    await _client!.from(_tableName).upsert(data);
  }

  Future<List<GrowthModel>> getAllGrowths() async {
    if (_client == null) return [];
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client!
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      return (response as List)
          .map((data) => _mapToGrowthModel(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching growths: $e');
      return [];
    }
  }

  Future<GrowthModel?> getLatestGrowth() async {
    final growths = await getAllGrowths();
    return growths.isEmpty ? null : growths.first;
  }

  Future<GrowthModel?> getGrowthByAge(int ageInDays) async {
    if (_client == null) return null;
    final userId = _client!.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client!
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('age_in_days', ageInDays)
          .single();

      return _mapToGrowthModel(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteGrowth(String id) async {
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

  GrowthModel _mapToGrowthModel(Map<String, dynamic> data) {
    return GrowthModel(
      id: data['id'] as String,
      timestamp: DateTime.parse(data['timestamp'] as String),
      weight: (data['weight'] as num).toDouble(),
      height: (data['height'] as num).toDouble(),
      headCircumference: (data['head_circumference'] as num).toDouble(),
      ageInDays: data['age_in_days'] as int,
      notes: data['notes'] as String?,
    );
  }
}

