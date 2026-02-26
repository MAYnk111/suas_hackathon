import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _loadMetadata();
  }

  final FirebaseAuth _auth;
  Map<String, dynamic> _metadata = {};
  bool _metadataLoaded = false;

  bool get isAvailable => true;

  Map<String, dynamic>? get currentUser => _mapUser(_auth.currentUser);

  Map<String, dynamic> get userMetadata => _metadata;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return false;
    if (data != null && data.isNotEmpty) {
      await updateUserMetadata(data);
    }
    return true;
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) return false;
    await _loadMetadata();
    return true;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _metadata = {};
    _metadataLoaded = false;
  }

  Future<bool> updateUserMetadata(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    _metadata = {
      ..._metadata,
      ...data,
    };

    final prefs = await SharedPreferences.getInstance();
    final key = _metadataKeyForUser(user.uid);
    await prefs.setString(key, jsonEncode(_metadata));
    _metadataLoaded = true;
    return true;
  }

  Future<bool> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.updatePassword(newPassword);
    return true;
  }

  Future<void> reloadMetadata() async {
    await _loadMetadata(force: true);
  }

  Future<void> _loadMetadata({bool force = false}) async {
    if (_metadataLoaded && !force) return;
    final user = _auth.currentUser;
    if (user == null) {
      _metadata = {};
      _metadataLoaded = true;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = _metadataKeyForUser(user.uid);
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      _metadata = {};
    } else {
      final decoded = jsonDecode(raw);
      _metadata = decoded is Map<String, dynamic> ? decoded : {};
    }
    _metadataLoaded = true;
  }

  String _metadataKeyForUser(String uid) => 'pregnancy_metadata_$uid';

  Map<String, dynamic>? _mapUser(User? user) {
    if (user == null) return null;
    return {
      'id': user.uid,
      'email': user.email,
      'phone': user.phoneNumber,
      'created_at': user.metadata.creationTime?.toIso8601String(),
    };
  }
}
