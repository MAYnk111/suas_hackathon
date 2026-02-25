import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.radius);
    final shadow = Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: radius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
