/// Defines the user roles available in the SUDHA app
enum UserRole {
  /// General patient care role (standard SUDHA features)
  general,
  
  /// Pregnancy care role (Vatsalya pregnancy features)
  pregnant,
}

/// Extension methods for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.general:
        return 'General Patient Care';
      case UserRole.pregnant:
        return 'Pregnancy Care';
    }
  }
  
  String get description {
    switch (this) {
      case UserRole.general:
        return 'Standard health monitoring and medical assistance';
      case UserRole.pregnant:
        return 'Comprehensive pregnancy tracking and maternal care';
    }
  }
}
