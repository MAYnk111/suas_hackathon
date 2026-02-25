import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final String level;

  const StatusPill({super.key, required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Color _resolveColor(String level) {
    switch (level.toLowerCase()) {
      case 'red':
        return AppTheme.destructive;
      case 'yellow':
        return AppTheme.coral;
      case 'green':
        return AppTheme.sage;
      default:
        return AppTheme.mutedForeground;
    }
  }
}
