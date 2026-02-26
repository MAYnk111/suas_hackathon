import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/models/reminder_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/educator_suggestions_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/widgets/smart_reminder_card.dart';

class EducatorSuggestionsPage extends ConsumerWidget {
  const EducatorSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(educatorSuggestionsProvider);
    final reminderRepoAsync = ref.watch(reminderRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Educator Suggestions'),
      ),
      body: reminderRepoAsync.when(
        data: (repo) {
          return suggestionsAsync.when(
            data: (suggestions) {
              if (suggestions.isEmpty) {
                return const Center(child: Text('No suggestions available.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return SmartReminderCard(
                    reminder: suggestion,
                    onDismiss: () {
                      _handleDismiss(context, repo, suggestion);
                    },
                    onComplete: () {
                      _handleAssign(context, repo, suggestion);
                    },
                    actionLabel: 'Assign Worksheet',
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _handleDismiss(
    BuildContext context,
    dynamic repo,
    ReminderModel suggestion,
  ) async {
    await repo.saveReminder(suggestion.copyWith(isCompleted: true));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suggestion dismissed')),
      );
    }
  }

  Future<void> _handleAssign(
    BuildContext context,
    dynamic repo,
    ReminderModel suggestion,
  ) async {
    final updated = suggestion.copyWith(isCompleted: true);
    await repo.saveReminder(updated);
    await repo.saveReminder(
      suggestion.copyWith(
        id: '${suggestion.id}_assignment',
        title: 'Worksheet Assigned',
        description: '${suggestion.description} Worksheet assigned.',
        type: 'EducatorAssignment',
        isCompleted: true,
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Worksheet assigned')),
      );
    }
  }
}

