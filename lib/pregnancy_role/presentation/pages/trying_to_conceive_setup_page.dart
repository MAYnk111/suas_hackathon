import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sudha_app/pregnancy_role/data/models/fertility_profile_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/auth_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/main_navigation_shell.dart';
import 'package:sudha_app/pregnancy_role/core/services/centralized_translations.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';

class TryingToConceiveSetupPage extends ConsumerStatefulWidget {
  const TryingToConceiveSetupPage({super.key});

  @override
  ConsumerState<TryingToConceiveSetupPage> createState() =>
      _TryingToConceiveSetupPageState();
}

class _TryingToConceiveSetupPageState
    extends ConsumerState<TryingToConceiveSetupPage> {
  DateTime? _lmpDate;
  bool _cycleRegular = true;
  bool _isLoading = false;
  final TextEditingController _cycleLengthController = TextEditingController();

  @override
  void dispose() {
    _cycleLengthController.dispose();
    super.dispose();
  }

  Future<void> _selectLmpDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 28)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _lmpDate = picked;
      });
    }
  }

  Future<void> _saveSetup() async {
    final cycleLength = int.tryParse(_cycleLengthController.text.trim());
    final languageCode = ref.read(languageProvider);

    if (_lmpDate == null || cycleLength == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ttc.missing_details'.tr(languageCode))),
      );
      return;
    }

    if (cycleLength < 20 || cycleLength > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ttc.cycle_length_range'.tr(languageCode))),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ttc.no_user'.tr(languageCode))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fertilityProfileRepositoryProvider);
      final profile = FertilityProfileModel(
        userId: user['id'] as String,
        lmpDate: _lmpDate!,
        avgCycleLength: cycleLength,
        cycleRegular: _cycleRegular,
      );
      await repo.upsertProfile(profile);

      final authService = ref.read(authServiceProvider);
      await authService.updateUserMetadata({
        'start_date':
            DateTime.utc(_lmpDate!.year, _lmpDate!.month, _lmpDate!.day)
                .toIso8601String(),
      });

      ref.read(authStateProvider.notifier).setUser(authService.currentUser);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        );
      }
    } catch (e) {
      if (mounted) {
        final languageCode = ref.read(languageProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${'ttc.error_saving_setup'.tr(languageCode)} $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Tr('ttc.app_bar_title'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      const Tr(
                        'ttc.title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Tr(
                        'ttc.description',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () => _selectLmpDate(context),
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'ttc.lmp_label'.tr(languageCode),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    _lmpDate == null
                        ? 'ttc.select_date'.tr(languageCode)
                        : DateFormat('MMMM dd, yyyy').format(_lmpDate!),
                    style: TextStyle(
                      color: _lmpDate == null
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _cycleLengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ttc.cycle_length_label'.tr(languageCode),
                  prefixIcon: const Icon(Icons.timelapse_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _cycleRegular,
                title: Tr('ttc.cycle_regularity'),
                subtitle: Tr('ttc.cycle_regularity_subtitle'),
                onChanged: (val) => setState(() => _cycleRegular = val),
              ),
              const SizedBox(height: 48),
              FilledButton(
                onPressed: _isLoading ? null : _saveSetup,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Tr('ttc.complete_setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

