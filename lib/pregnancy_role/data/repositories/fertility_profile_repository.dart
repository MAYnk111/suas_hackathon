import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/fertility_profile_model.dart';

class FertilityProfileRepository {
  FertilityProfileRepository({SupabaseClient? client})
      : _client = client ?? _tryGetClient();

  final SupabaseClient? _client;

  Future<void> upsertProfile(FertilityProfileModel profile) async {
    if (_client == null) return;
    await _client!.from('fertility_profiles').upsert(profile.toMap());
  }

  Future<FertilityProfileModel?> fetchProfile(String userId) async {
    if (_client == null) return null;
    final data = await _client!
        .from('fertility_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) return null;
    return FertilityProfileModel.fromMap(data);
  }

  static SupabaseClient? _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}

