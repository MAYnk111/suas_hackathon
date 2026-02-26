import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/user_role.dart';

/// Provider for managing user role switching between General and Pregnancy modes
class RoleProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.general;
  static const String _roleBoxName = 'userSettings';
  static const String _roleKey = 'selectedRole';

  /// Gets the current active role
  UserRole get currentRole => _currentRole;

  /// Checks if user is in general mode
  bool get isGeneralMode => _currentRole == UserRole.general;

  /// Checks if user is in pregnancy mode
  bool get isPregnancyMode => _currentRole == UserRole.pregnant;

  /// Initialize and load saved role from storage
  Future<void> initialize() async {
    try {
      final box = await Hive.openBox(_roleBoxName);
      final savedRole = box.get(_roleKey, defaultValue: 'general') as String;
      
      if (savedRole == 'pregnant') {
        _currentRole = UserRole.pregnant;
      } else {
        _currentRole = UserRole.general;
      }
      
      // ignore: avoid_print
      print('✅ Role loaded from storage: ${_currentRole.displayName}');
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ Could not load saved role: $e');
      _currentRole = UserRole.general;
    }
  }

  /// Saves role to persistent storage
  Future<void> _saveRole() async {
    try {
      final box = await Hive.openBox(_roleBoxName);
      await box.put(_roleKey, _currentRole == UserRole.pregnant ? 'pregnant' : 'general');
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ Could not save role: $e');
    }
  }

  /// Sets the user role and notifies listeners
  void setRole(UserRole newRole) {
    if (_currentRole != newRole) {
      _currentRole = newRole;
      _saveRole(); // Persist the choice
      notifyListeners();
      // ignore: avoid_print
      print('✅ Role switched to: ${newRole.displayName}');
    }
  }

  /// Convenience method to switch to general mode
  void switchToGeneral() {
    setRole(UserRole.general);
  }

  /// Convenience method to switch to pregnancy mode
  void switchToPregnancy() {
    setRole(UserRole.pregnant);
  }

  /// Resets to default general role (useful on logout)
  void reset() {
    _currentRole = UserRole.general;
    _saveRole(); // Clear saved role on logout
    notifyListeners();
  }
}
