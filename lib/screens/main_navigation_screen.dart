import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_nav_provider.dart';
import '../theme/app_theme.dart';
import '../utils/translations.dart';
import 'dashboard_screen.dart';
import 'symptoms_screen.dart';
import 'food_screen.dart';
import 'meditation_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static final List<Widget> _screens = [
    const DashboardScreen(),
    const SymptomsScreen(),
    const FoodScreen(),
    const MeditationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<BottomNavProvider>();

    return Scaffold(
      body: IndexedStack(
        index: nav.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: nav.currentIndex,
        onTap: nav.setIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.mutedForeground,
        backgroundColor: AppTheme.card,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: tr(context, 'dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monitor_heart_outlined),
            label: tr(context, 'symptoms'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu_outlined),
            label: tr(context, 'food'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.spa_outlined),
            label: tr(context, 'meditation'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: tr(context, 'profile'),
          ),
        ],
      ),
    );
  }
}
