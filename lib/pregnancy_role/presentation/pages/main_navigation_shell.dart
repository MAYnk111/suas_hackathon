import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/resources_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/profile_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/reminders_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_meta_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/toddler_setup_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/trying_to_conceive_setup_page.dart';
import 'package:sudha_app/pregnancy_role/core/utils/notification_service.dart';

// We'll import these when we create them, for now using placeholders/existing
import 'package:sudha_app/pregnancy_role/presentation/pages/pregnant_dashboard_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/toddler_dashboard_page.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/trying_to_conceive_dashboard_page.dart';

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final granted = await NotificationService.requestPermission();
    print('DEBUG: MainNavigationShell - Notification permission granted: $granted');
  }

  @override
  Widget build(BuildContext context) {
    final userMeta = ref.watch(userMetaProvider);
    print('DEBUG MainNavigationShell: Building - role: ${userMeta.role}, startDate: ${userMeta.startDate}');
    
    // Skip setup pages entirely - go directly to dashboards
    // All setup can be done from the dashboard if needed

    // Determine the dashboard based on profile type
    Widget homePage;
    if (userMeta.role == UserProfileType.pregnant) {
      print('DEBUG MainNavigationShell: Loading PregnantDashboardPage (skipping setup)');
      homePage = const PregnantDashboardPage();
    } else if (userMeta.role == UserProfileType.tryingToConceive) {
      print('DEBUG MainNavigationShell: Loading TryingToConceiveDashboardPage (skipping setup)');
      homePage = const TryingToConceiveDashboardPage();
    } else {
      print('DEBUG MainNavigationShell: Loading ToddlerDashboardPage (skipping setup)');
      homePage = const ToddlerDashboardPage();
    }

    final screens = [
      homePage,
      const ResourcesPage(),
      const RemindersPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(Icons.alarm),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

