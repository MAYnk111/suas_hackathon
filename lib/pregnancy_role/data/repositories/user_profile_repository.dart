import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileRepository {
  UserProfileRepository({SupabaseClient? client})
      : _client = client ?? _tryGetClient();

  final SupabaseClient? _client;

  Future<void> upsertProfile({
    required String userId,
    required String email,
    required String role,
    required String profileType,
  }) async {
    if (_client == null) return;
    await _client!.from('profiles').upsert({
      'id': userId,
      'email': email,
      'role': role,
      'profile_type': profileType,
    });
  }

  static SupabaseClient? _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}
