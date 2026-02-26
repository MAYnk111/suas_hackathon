import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserProfileType { pregnant, toddlerParent, tryingToConceive }

final userProfileProvider = StateProvider<UserProfileType?>((ref) => null);
