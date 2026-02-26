import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/domain/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthStateNotifier extends StateNotifier<Map<String, dynamic>?> {
  AuthStateNotifier(this._authService) : super(_authService.currentUser) {
    _subscription = _authService.authStateChanges.listen((_) async {
      state = _authService.currentUser;
      await _authService.reloadMetadata();
    });
  }

  final AuthService _authService;
  StreamSubscription? _subscription;

  void setUser(Map<String, dynamic>? user) {
    state = user;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, Map<String, dynamic>?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

final currentUserProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(authStateProvider);
});

