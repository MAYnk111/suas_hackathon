import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 24, thickness: 1, color: AppTheme.border);
  }
}
