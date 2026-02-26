import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sudha_app/pregnancy_role/data/models/vaccination_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/core/utils/vaccination_schedule.dart';
import 'package:sudha_app/pregnancy_role/core/utils/reminder_service.dart';
import 'package:sudha_app/pregnancy_role/core/services/centralized_translations.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';

class VaccinationPage extends ConsumerStatefulWidget {
  const VaccinationPage({super.key});

  @override
  ConsumerState<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends ConsumerState<VaccinationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vaccinationRepo = ref.watch(vaccinationRepositoryProvider);
    final languageCode = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Tr('vaccination.title'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(child: Tr('vaccination.tab_upcoming')),
            Tab(child: Tr('vaccination.tab_completed')),
            Tab(child: Tr('vaccination.tab_schedule')),
          ],
        ),
      ),
      body: vaccinationRepo.when(
        data: (repo) {
          final upcoming = repo.getUpcomingVaccinations();
          final completed = repo.getCompletedVaccinations();

          return TabBarView(
            controller: _tabController,
            children: [
              _UpcomingTab(
                  vaccinations: upcoming,
                  repo: repo,
                  languageCode: languageCode),
              _CompletedTab(
                  vaccinations: completed, languageCode: languageCode),
              _ScheduleTab(repo: repo),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child:
              Text('${'common.error'.tr(languageCode)}: ${error.toString()}'),
        ),
      ),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  final List<VaccinationModel> vaccinations;
  final dynamic repo;
  final String languageCode;

  const _UpcomingTab({
    required this.vaccinations,
    required this.repo,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (vaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Tr('vaccination.no_upcoming'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: vaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = vaccinations[index];
        return _VaccinationCard(
            vaccination: vaccination, repo: repo, isUpcoming: true);
      },
    );
  }
}

class _CompletedTab extends StatelessWidget {
  final List<VaccinationModel> vaccinations;
  final String languageCode;

  const _CompletedTab({required this.vaccinations, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    if (vaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vaccines_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Tr('vaccination.no_completed'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: vaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = vaccinations[index];
        return _VaccinationCard(
            vaccination: vaccination, repo: null, isUpcoming: false);
      },
    );
  }
}

class _ScheduleTab extends ConsumerWidget {
  final dynamic repo;

  const _ScheduleTab({required this.repo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = VaccinationSchedule.getIndianSchedule();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.vaccines,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(item['name'] as String),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${'vaccination.age'.tr(ref.watch(languageProvider))} ${item['age']}'),
                if (item['description'] != null)
                  Text(item['description'] as String),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () async {
                try {
                  final ageInDays = _parseAgeToDays(item['age'] as String);
                  final scheduledDate =
                      DateTime.now().add(Duration(days: ageInDays));

                  final vaccination = VaccinationModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: item['name'] as String,
                    scheduledDate: scheduledDate,
                    ageInDays: ageInDays,
                  );
                  await repo.saveVaccination(vaccination);
                  await ReminderService.scheduleVaccinationReminder(
                      vaccination);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('vaccination.scheduled'
                              .tr(ref.read(languageProvider)))),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${'common.error'.tr(ref.read(languageProvider))}: ${e.toString()}')),
                    );
                  }
                }
              },
              child:
                  Text('vaccination.schedule'.tr(ref.watch(languageProvider))),
            ),
          ),
        );
      },
    );
  }

  int _parseAgeToDays(String age) {
    if (age.contains('At birth')) return 0;
    if (age.contains('weeks')) {
      final weeks = int.tryParse(age.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return weeks * 7;
    }
    if (age.contains('months')) {
      final months = int.tryParse(age.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return months * 30;
    }
    if (age.contains('year')) {
      final years = int.tryParse(age.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return years * 365;
    }
    return 0;
  }
}

class _VaccinationCard extends ConsumerWidget {
  final VaccinationModel vaccination;
  final dynamic repo;
  final bool isUpcoming;

  const _VaccinationCard({
    required this.vaccination,
    required this.repo,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUpcoming && vaccination.daysUntilDue <= 7
          ? Theme.of(context).colorScheme.errorContainer
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: vaccination.isCompleted
              ? Colors.green.withOpacity(0.2)
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            vaccination.isCompleted ? Icons.check_circle : Icons.vaccines,
            color: vaccination.isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(vaccination.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!vaccination.isCompleted)
              Text(
                '${'vaccination.due'.tr(ref.watch(languageProvider))} ${DateFormat('MMM dd, yyyy').format(vaccination.scheduledDate)}',
              ),
            if (vaccination.isCompleted && vaccination.administeredDate != null)
              Text(
                '${'vaccination.administered'.tr(ref.watch(languageProvider))} ${DateFormat('MMM dd, yyyy').format(vaccination.administeredDate!)}',
              ),
            if (isUpcoming)
              Text(
                '${vaccination.daysUntilDue} ${'vaccination.days_left'.tr(ref.watch(languageProvider))}',
                style: TextStyle(
                  color: vaccination.daysUntilDue <= 7
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (vaccination.batchNumber != null)
              Text(
                '${'vaccination.batch'.tr(ref.watch(languageProvider))} ${vaccination.batchNumber}',
              ),
            if (vaccination.doctorName != null)
              Text(
                '${'vaccination.doctor'.tr(ref.watch(languageProvider))} ${vaccination.doctorName}',
              ),
          ],
        ),
        trailing: isUpcoming
            ? IconButton(
                icon: const Icon(Icons.check_circle),
                onPressed: () async {
                  final updated = vaccination.copyWith(
                    isCompleted: true,
                    administeredDate: DateTime.now(),
                  );
                  await repo.saveVaccination(updated);
                },
              )
            : null,
      ),
    );
  }
}

