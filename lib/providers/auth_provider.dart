import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User roles in SUDHA app
enum UserRole {
  general,
  pregnant,
}

class AuthProvider extends ChangeNotifier {
  static const String _emailKey = 'sudha_user_email';
  static const String _roleKey = 'sudha_user_role';
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _email;
  String? _uid;
  UserRole _role = UserRole.general; // Default role
  String? error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;
  String? get uid => _uid;
  UserRole get role => _role;
  bool get isPregnantRole => _role == UserRole.pregnant;
  User? get firebaseUser => _firebaseAuth.currentUser;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      _isLoading = true;
      final user = _firebaseAuth.currentUser;
      
      if (user != null) {
        _isAuthenticated = true;
        _email = user.email;
        _uid = user.uid;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailKey, user.email ?? '');
        
        // Load user role from SharedPreferences
        final roleString = prefs.getString(_roleKey);
        if (roleString == 'pregnant') {
          _role = UserRole.pregnant;
        } else {
          _role = UserRole.general;
        }
      } else {
        _isAuthenticated = false;
        _email = null;
        _uid = null;
        _role = UserRole.general;
      }
    } catch (e) {
      error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    error = null;
    notifyListeners();

    if (email.trim().isEmpty || 
        password.trim().length < 6 || 
        name.trim().isEmpty) {
      error = 'Please fill all fields. Password must be at least 6 characters.';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        
        _isAuthenticated = true;
        _email = userCredential.user!.email;
        _uid = userCredential.user!.uid;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailKey, _email ?? '');

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        error = 'Email already registered.';
      } else {
        error = e.message ?? 'Registration failed.';
      }
    } catch (e) {
      error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    error = null;
    notifyListeners();

    if (email.trim().isEmpty || password.trim().length < 6) {
      error = 'Please enter a valid email and password (min 6 characters).';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        _isAuthenticated = true;
        _email = userCredential.user!.email;
        _uid = userCredential.user!.uid;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailKey, _email ?? '');

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'Email not registered.';
      } else if (e.code == 'wrong-password') {
        error = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        error = 'Invalid email format.';
      } else {
        error = e.message ?? 'Login failed.';
      }
    } catch (e) {
      error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _isAuthenticated = false;
      _email = null;
      _uid = null;
      _role = UserRole.general;
      error = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_roleKey);
      
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  /// Switch user role between general and pregnant
  Future<void> switchRole(UserRole newRole) async {
    try {
      _role = newRole;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_roleKey, newRole == UserRole.pregnant ? 'pregnant' : 'general');
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetPassword({required String email}) async {
    error = null;
    notifyListeners();

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      error = 'Password reset email sent. Check your inbox.';
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Failed to send reset email.';
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
