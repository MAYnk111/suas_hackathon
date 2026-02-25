import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final language = context.watch<LanguageProvider>();
    final familyMembers = [
      {'name': 'Mom', 'relation': 'Mother'},
      {'name': 'Dad', 'relation': 'Father'},
    ];

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
            const SizedBox(height: AppSpacing.lg),

            // Family Members
            Text(
              'Family Members',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ...familyMembers.map((member) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accent,
                    child: const Icon(Icons.person,
                        color: AppTheme.accentForeground),
                  ),
                  title: Text(member['name']!),
                  subtitle: Text(member['relation']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {},
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
                onTap: () {},
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
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.read<AuthProvider>().logout();
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
}
