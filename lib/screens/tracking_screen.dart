import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tracking_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/section_header.dart';
import '../widgets/app_card.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'notspecified';

  @override
  void dispose() {
    _symptomsController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TrackingProvider>();
    await provider.submit(
      symptoms: _symptomsController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _gender,
    );

    if (provider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SectionHeader(
            title: 'Tracking',
            subtitle: 'Submit symptoms for guided assessment',
          ),
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _symptomsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Describe symptoms',
                      hintText: 'Include duration and intensity',
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Please describe your symptoms.'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      final parsed = int.tryParse(value ?? '');
                      if (parsed == null || parsed < 1 || parsed > 150) {
                        return 'Enter a valid age (1-150).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: const [
                      DropdownMenuItem(value: 'notspecified', child: Text('Select gender')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) => setState(() => _gender = value ?? 'notspecified'),
                    validator: (value) => value == 'notspecified' ? 'Please select gender.' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tracking.isSubmitting ? null : _submit,
                      child: tracking.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryForeground),
                            )
                          : const Text('Submit for review'),
                    ),
                  ),
                  if (tracking.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      tracking.error.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.destructive),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (tracking.result != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Risk Level', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(tracking.result!.riskLevel),
                    backgroundColor: _riskColor(tracking.result!.riskLevel),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(tracking.result!.explanation),
                  const SizedBox(height: AppSpacing.md),
                  if (tracking.result!.topConditions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top Conditions', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ...tracking.result!.topConditions.map(
                          (item) => Text('- ${item.condition} (${item.confidence}%)'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
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
