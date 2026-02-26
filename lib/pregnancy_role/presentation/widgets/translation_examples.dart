import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/language_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/translation_provider.dart';

/// Example: Simple widget that translates a single text
class TranslatedTextExample extends ConsumerWidget {
  final String text;

  const TranslatedTextExample(this.text, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatedFuture = ref.watch(translateProvider(text));

    return translatedFuture.when(
      data: (translated) => Text(translated),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text(text), // Fallback to original
    );
  }
}

/// Example: List of items that are translated
class TranslatedListExample extends ConsumerWidget {
  final List<String> items;
  final String title;

  const TranslatedListExample({
    required this.items,
    this.title = 'Items',
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatedFuture = ref.watch(translateBatchProvider(items));

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        translatedFuture.when(
          data: (translations) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: translations.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(translations[index]),
            ),
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(items[index]),
            ),
          ),
        ),
      ],
    );
  }
}

/// Example: Card with translated content
class TranslatedCardExample extends ConsumerWidget {
  final String title;
  final String description;

  const TranslatedCardExample({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleFuture = ref.watch(translateProvider(title));
    final descriptionFuture = ref.watch(translateProvider(description));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleFuture.when(
              data: (translated) => Text(
                translated,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              loading: () => const Text('...'),
              error: (_, __) => Text(title),
            ),
            const SizedBox(height: 8),
            descriptionFuture.when(
              data: (translated) => Text(
                translated,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              loading: () => const Text('...'),
              error: (_, __) => Text(description),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example: Dialog with language selection and real-time translation
class LanguageAndTranslationDialogExample extends ConsumerWidget {
  final String sampleText;

  const LanguageAndTranslationDialogExample({
    required this.sampleText,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);
    final translatedFuture = ref.watch(translateProvider(sampleText));

    return AlertDialog(
      title: const Text('Language Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Language: ${AppLanguage.fromCode(currentLanguage.languageCode).nativeName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text('Translation Sample:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: translatedFuture.when(
                data: (translated) => Text(translated),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => Text(sampleText),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView(
                children: AppLanguage.values.map((language) {
                  final isSelected =
                      currentLanguage.languageCode == language.code;
                  return ListTile(
                    leading: Text(language.flag),
                    title: Text(language.nativeName),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () async {
                      await languageNotifier.setLanguage(language);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Language changed to ${language.nativeName}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Example: Service health indicator
class TranslationServiceStatusExample extends ConsumerWidget {
  const TranslationServiceStatusExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceStatus = ref.watch(translationServiceProvider);

    return serviceStatus.when(
      data: (available) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: available ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            available ? 'Service Available' : 'Service Unavailable',
            style: TextStyle(
              color: available ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      loading: () => const Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Checking...'),
        ],
      ),
      error: (_, __) => const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 12),
          SizedBox(width: 8),
          Text('Check Failed'),
        ],
      ),
    );
  }
}

/// Example: Full page with multiple translated sections
class FullPageTranslationExample extends ConsumerWidget {
  const FullPageTranslationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = [
      'Welcome to Vatsalya',
      'Track your pregnancy journey',
      'Get expert insights',
      'Connect with community'
    ];

    final sectionsFuture = ref.watch(translateBatchProvider(sections));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TranslationServiceStatusExample(),
          const SizedBox(height: 24),
          sectionsFuture.when(
            data: (translations) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: translations.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        entry.value,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(section),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

