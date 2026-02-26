import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/family_provider.dart';
import '../providers/health_data_provider.dart';
import '../providers/reminder_provider.dart';
import '../providers/role_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import '../screens/user_health_information_screen.dart';
import '../screens/health_snapshot_preview_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final language = context.watch<LanguageProvider>();
    final family = context.watch<FamilyProvider>();
    final healthData = context.watch<HealthDataProvider>();
    final reminders = context.watch<ReminderProvider>();

    // Set user data for health export
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.email != null && auth.uid != null) {
        healthData.setUserData(auth.email, auth.uid);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SectionHeader(
              title: 'Profile',
              subtitle: 'Account and preferences',
            ),
            const SizedBox(height: AppSpacing.lg),

            // User Info
            AppCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.primary,
                    child: Icon(Icons.person_outline,
                        color: AppTheme.primaryForeground, size: 32),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Profile',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          auth.email ?? 'user@example.com',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.verified,
                      color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Preferences
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),

            // Dark Mode
            AppCard(
              child: ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: theme.isDarkMode,
                  onChanged: (_) {
                    theme.toggleDarkMode();
                  },
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Language
            AppCard(
              child: ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: language.language,
                  onChanged: (val) {
                    if (val != null) {
                      language.setLanguage(val);
                    }
                  },
                  items: language.getAvailableLanguages().map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  underline: const SizedBox(),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Role Switcher - Switch to Pregnancy Care
            AppCard(
              child: ListTile(
                title: const Text('Care Mode'),
                subtitle: const Text(
                  'Currently in General Healthcare mode',
                  style: TextStyle(color: AppTheme.mutedForeground),
                ),
                trailing: const Icon(Icons.arrow_forward),
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.local_hospital, color: Colors.white),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Switch to Pregnancy Care'),
                      content: const Text(
                        'Switch to Pregnancy Care mode for comprehensive maternal health tracking and support.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            
                            // ✅ Switch role (updates RoleProvider and saves to storage)
                            context.read<RoleProvider>().switchToPregnancy();
                            
                            // ✅ Pop everything to root - AppEntry Consumer will rebuild automatically
                            final navigator = Navigator.of(context, rootNavigator: true);
                            navigator.popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.pregnant_woman),
                          label: const Text('Switch'),
                        ),
                      ],
                    ),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Family Members
            Text(
              'Family Members',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ...family.members.map((member) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accent,
                    child: const Icon(Icons.person,
                        color: AppTheme.accentForeground),
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    member.phone != null
                        ? '${member.relation} • ${member.phone}'
                        : member.relation,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditMemberDialog(context, member),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppTheme.destructive,
                        onPressed: () => _confirmDeleteMember(context, member),
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: const Icon(Icons.add,
                      color: AppTheme.primaryForeground),
                ),
                title: const Text('Add Family Member'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => _showAddMemberDialog(context),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Emergency Contact
            Text(
              'Emergency Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.destructive,
                  child: const Icon(Icons.phone,
                      color: Colors.white),
                ),
                title: const Text('Emergency Contacts'),
                subtitle: const Text('Set up quick alerts'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Health Data & Records - Health Snapshot
            Text(
              'Health Data & Records',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.sage,
                  child: const Icon(Icons.health_and_safety_outlined,
                      color: AppTheme.sageForeground),
                ),
                title: const Text('Generate Snapshot'),
                subtitle: const Text('Create health record'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () async {
                  if (!healthData.hasRequiredHealthInfo) {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserHealthInformationScreen(),
                      ),
                    );
                    if (!mounted || result != true) return;
                  }

                  // Generate snapshot
                  final activeMeds = reminders
                      .reminders
                      .map((r) => r.medicineName)
                      .toList();
                  
                  final snapshot = await healthData.generateSnapshot(
                    type: SnapshotType.normal,
                    activeMedications: activeMeds,
                  );

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthSnapshotPreviewScreen(
                        snapshot: snapshot,
                      ),
                    ),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accent,
                  child: const Icon(Icons.emergency_outlined,
                      color: AppTheme.accentForeground),
                ),
                title: const Text('Emergency Snapshot'),
                subtitle: const Text('Quick medical record'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () async {
                  if (!healthData.hasRequiredHealthInfo) {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserHealthInformationScreen(),
                      ),
                    );
                    if (!mounted || result != true) return;
                  }

                  final activeMeds = reminders
                      .reminders
                      .map((r) => r.medicineName)
                      .toList();

                  final snapshot = await healthData.generateSnapshot(
                    type: SnapshotType.emergency,
                    activeMedications: activeMeds,
                  );

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthSnapshotPreviewScreen(
                        snapshot: snapshot,
                      ),
                    ),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // More Settings
            Text(
              'More',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outlined),
                    title: const Text('About SUDHA'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.destructive.withValues(alpha: 0.1),
                  foregroundColor: AppTheme.destructive,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            // Reset role to general before logout
                            context.read<RoleProvider>().reset();
                            await context.read<AuthProvider>().logout();
                            
                            // Pop to root - AppEntry Consumer will show LoginScreen
                            if (context.mounted) {
                              final navigator = Navigator.of(context, rootNavigator: true);
                              navigator.popUntil((route) => route.isFirst);
                            }
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Family Member'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name',
                  ),
                  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: relationController,
                  decoration: const InputDecoration(
                    labelText: 'Relation',
                    hintText: 'e.g., Mother, Father, Spouse',
                  ),
                  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    hintText: 'Enter phone number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                context.read<FamilyProvider>().addMember(
                      name: nameController.text.trim(),
                      relation: relationController.text.trim(),
                      phone: phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Family member added')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(BuildContext context, FamilyMember member) {
    final nameController = TextEditingController(text: member.name);
    final relationController = TextEditingController(text: member.relation);
    final phoneController = TextEditingController(text: member.phone ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Family Member'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name',
                  ),
                  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: relationController,
                  decoration: const InputDecoration(
                    labelText: 'Relation',
                    hintText: 'e.g., Mother, Father, Spouse',
                  ),
                  validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    hintText: 'Enter phone number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                context.read<FamilyProvider>().updateMember(
                      member.id,
                      name: nameController.text.trim(),
                      relation: relationController.text.trim(),
                      phone: phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Family member updated')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMember(BuildContext context, FamilyMember member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Family Member'),
        content: Text('Are you sure you want to remove ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.destructive),
            onPressed: () {
              context.read<FamilyProvider>().deleteMember(member.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${member.name} removed')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
