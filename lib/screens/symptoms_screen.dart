import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tracking_provider.dart';
import '../providers/hospital_checklist_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final _symptomsController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _symptomsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submitSymptoms() async {
    final provider = context.read<TrackingProvider>();
    await provider.submit(
      symptoms: _symptomsController.text.trim(),
      age: 30,
      gender: 'Not specified',
    );

    if (mounted) {
      _symptomsController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Symptoms analyzed. Check results below.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SectionHeader(
              title: 'Symptom Analyzer',
              subtitle: 'Describe your symptoms for AI analysis',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Symptoms Hero Banner
            AppCard(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/symptom_sec.png',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Input Section
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Describe Your Symptoms',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _symptomsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'E.g., I have a fever, cough, and sore throat for 2 days',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tracking.isSubmitting
                          ? null
                          : _submitSymptoms,
                      child: tracking.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryForeground,
                              ),
                            )
                          : const Text('Analyze Symptoms'),
                    ),
                  ),
                  if (tracking.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppTheme.destructive.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.destructive),
                      ),
                      child: Text(
                        tracking.error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.destructive),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Results Section
            if (tracking.result != null) ...[
              SectionHeader(
                title: 'Analysis Results',
                subtitle: 'Risk Level: ${tracking.result!.riskLevel}',
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Risk Level Card with Visual Indicator
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Risk Assessment',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getRiskColor(tracking.result!.riskLevel).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _getRiskColor(tracking.result!.riskLevel)),
                          ),
                          child: Text(
                            tracking.result!.riskLevel.toUpperCase(),
                            style: TextStyle(
                              color: _getRiskColor(tracking.result!.riskLevel),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      tracking.result!.explanation,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (tracking.result!.topConditions.isNotEmpty) ...[
                      const Divider(),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Confidence Indicators:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...tracking.result!.topConditions.asMap().entries.map((e) {
                        final condition = e.value;
                        final index = e.key;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${index + 1}. ${condition.condition}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${condition.confidence}%',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: condition.confidence / 100,
                                  minHeight: 8,
                                  backgroundColor: AppTheme.mutedForeground.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getConfidenceColor(condition.confidence),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '⚠️  Provided for awareness only. Consult a healthcare provider for diagnosis.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.mutedForeground),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Symptom Tracker
            SectionHeader(
              title: 'Symptom Tracker',
              subtitle: 'Log your daily symptoms',
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Today\'s Entry',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _durationController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'How are you feeling today?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_durationController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Entry saved to your tracker'),
                            ),
                          );
                          _durationController.clear();
                        }
                      },
                      child: const Text('Save Entry'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Hospital Bag Checklist
            SectionHeader(
              title: 'Hospital Checklist',
              subtitle: 'Prepare your wellness kit',
            ),
            const SizedBox(height: AppSpacing.md),
            Consumer<HospitalChecklistProvider>(
              builder: (context, checklist, _) {
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress: ${checklist.getCompletionPercentage()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: checklist.getCompletionPercentage() / 100,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...checklist.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isChecked,
                              onChanged: (_) {
                                checklist.toggleItem(item.id);
                              },
                            ),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                checklist.deleteItem(item.id);
                              },
                              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      )),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: _AddItemDialog(checklist: checklist),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return AppTheme.destructive;
      case 'moderate':
        return AppTheme.accent;
      case 'low':
        return Colors.green;
      default:
        return AppTheme.primary;
    }
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 70) return AppTheme.destructive;
    if (confidence >= 50) return AppTheme.accent;
    return Colors.green;
  }
}

class _AddItemDialog extends StatefulWidget {
  final HospitalChecklistProvider checklist;

  const _AddItemDialog({required this.checklist});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_controller.text.trim().isNotEmpty) {
      widget.checklist.addItem(_controller.text.trim());
      _controller.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Add Item'),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter checklist item',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      widget.checklist.addItem(_controller.text.trim());
                      _controller.clear();
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
