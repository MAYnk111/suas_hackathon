import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class SOSEmergencyScreen extends StatelessWidget {
  const SOSEmergencyScreen({super.key});

  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot make call to $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
          const SectionHeader(
            title: 'Emergency & SOS',
            subtitle: 'Quick access to emergency services',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '🚨',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Emergency?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Get help immediately by contacting emergency services or activating your smart alert.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () => _makeCall(context, '108'),
              icon: const Icon(Icons.phone),
              label: const Text('Call 108 (National Emergency)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.destructive,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () => _makeCall(context, '112'),
              icon: const Icon(Icons.phone),
              label: const Text('Call 112 (Police/Fire)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.coral,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚨 Smart Emergency Alert',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Activate emergency alert to notify your emergency contacts with your location, or call emergency services directly.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.mutedForeground),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Emergency alert feature coming soon'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    child: const Text('Activate Alert'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Important',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'This app provides health information only. In a life-threatening emergency, always call emergency services immediately (108 or 112).\n\nDo not rely on this app for emergency medical guidance.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
