import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/auth_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';

class UserMeta {
  final UserProfileType? role;
  final DateTime? startDate;
  final String? username;
  final bool tipsEnabled;
  final bool alertsEnabled;
  final bool remindersEnabled;

  UserMeta({
    this.role, 
    this.startDate, 
    this.username, 
    this.tipsEnabled = true, 
    this.alertsEnabled = true,
    this.remindersEnabled = true,
  });

  factory UserMeta.fromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return UserMeta();
    
    final roleStr = metadata['role'] as String?;
    final role = roleStr == 'pregnant'
      ? UserProfileType.pregnant
      : (roleStr == 'trying_to_conceive'
        ? UserProfileType.tryingToConceive
        : (roleStr == 'parent' || roleStr == 'toddler_parent'
          ? UserProfileType.toddlerParent
          : null));
    
    final startDateStr = metadata['start_date'] as String?;
    final startDate = startDateStr != null ? DateTime.tryParse(startDateStr) : null;
    final username = metadata['username'] as String?;
    
    // Explicitly check for false, default to true if null or not present
    final tipsEnabled = metadata['tips_enabled'] != false;
    final alertsEnabled = metadata['alerts_enabled'] != false;
    final remindersEnabled = metadata['reminders_enabled'] != false;

    return UserMeta(
      role: role,
      startDate: startDate,
      username: username,
      tipsEnabled: tipsEnabled,
      alertsEnabled: alertsEnabled,
      remindersEnabled: remindersEnabled,
    );
  }
}

final userMetaProvider = Provider<UserMeta>((ref) {
  final user = ref.watch(currentUserProvider);
  final authService = ref.watch(authServiceProvider);
  final profileType = ref.watch(userProfileProvider);
  
  print('DEBUG userMetaProvider: user=$user, profileType=$profileType');
  
  if (user == null) {
    print('DEBUG userMetaProvider: user is null, returning empty UserMeta');
    return UserMeta();
  }
  
  final metadata = authService.userMetadata;
  print('DEBUG userMetaProvider: metadata=$metadata');
  final userMeta = UserMeta.fromMetadata(metadata);
  
  // Use profileType if role is not in metadata
  if (userMeta.role == null && profileType != null) {
    print('DEBUG userMetaProvider: Using profileType as role');
    return UserMeta(
      role: profileType,
      startDate: userMeta.startDate,
      username: userMeta.username,
      tipsEnabled: userMeta.tipsEnabled,
      alertsEnabled: userMeta.alertsEnabled,
      remindersEnabled: userMeta.remindersEnabled,
    );
  }
  
  print('DEBUG userMetaProvider: Returning userMeta with role=${userMeta.role}, username=${userMeta.username}');
  return userMeta;
});

