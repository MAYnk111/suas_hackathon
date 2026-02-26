import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GarbhaSanskarJournalPage extends StatefulWidget {
  const GarbhaSanskarJournalPage({super.key});

  @override
  State<GarbhaSanskarJournalPage> createState() =>
      _GarbhaSanskarJournalPageState();
}

class _GarbhaSanskarJournalPageState extends State<GarbhaSanskarJournalPage> {
  final List<_JournalEntry> _entries = [];
  final _textController = TextEditingController();
  String? _selectedMood;

  final List<_MoodOption> _moods = const [
    _MoodOption(emoji: '😊', label: 'Happy', color: Color(0xFFFFD700)),
    _MoodOption(emoji: '😌', label: 'Peaceful', color: Color(0xFF87CEEB)),
    _MoodOption(emoji: '🤔', label: 'Thoughtful', color: Color(0xFFDAA520)),
    _MoodOption(emoji: '😴', label: 'Tired', color: Color(0xFF9370DB)),
    _MoodOption(emoji: '😟', label: 'Worried', color: Color(0xFFFF6347)),
    _MoodOption(emoji: '💪', label: 'Energetic', color: Color(0xFF32CD32)),
  ];

  final List<String> _prompts = const [
    'What made you smile today?',
    'Describe a moment you felt connected to your baby',
    'What are you grateful for today?',
    'How did you nurture yourself today?',
    'What positive thought do you want to remember?',
    'Describe something beautiful you noticed today',
    'What does your baby\'s future look like in your imagination?',
    'What traditional wisdom resonates with you?',
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getStringList('journal_entries') ?? [];

      setState(() {
        _entries.clear();
        for (final json in entriesJson) {
          final map = jsonDecode(json);
          _entries.add(_JournalEntry.fromJson(map));
        }
        _entries.sort((a, b) => b.date.compareTo(a.date));
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveEntry() async {
    if (_textController.text.trim().isEmpty || _selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something and select your mood'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final entry = _JournalEntry(
      date: DateTime.now(),
      text: _textController.text.trim(),
      mood: _selectedMood!,
    );

    setState(() {
      _entries.insert(0, entry);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = _entries.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('journal_entries', entriesJson);
    } catch (e) {
      // Handle error silently
    }

    _textController.clear();
    setState(() {
      _selectedMood = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Entry saved'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _getRandomPrompt() {
    _prompts.shuffle();
    return _prompts.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Journal'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // New Entry Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'How are you feeling?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Journal Prompt'),
                            content: Text(_getRandomPrompt()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.lightbulb_outline,
                          size: 18, color: colorScheme.secondary),
                      label: Text(
                        'Get Prompt',
                        style: TextStyle(color: colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Mood Selector
                Wrap(
                  spacing: 8,
                  children: _moods.map((mood) {
                    final isSelected = _selectedMood == mood.emoji;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood.emoji;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mood.color.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? mood.color
                                : colorScheme.outline.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mood.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              mood.label,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Text Input
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveEntry,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Entry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Past Entries
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No entries yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start writing to track your journey',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      final mood = _moods.firstWhere(
                        (m) => m.emoji == entry.mood,
                        orElse: () => _moods[0],
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: mood.color.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.mood,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDate(entry.date),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(entry.date),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                entry.text,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _JournalEntry {
  final DateTime date;
  final String text;
  final String mood;

  _JournalEntry({
    required this.date,
    required this.text,
    required this.mood,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'text': text,
        'mood': mood,
      };

  factory _JournalEntry.fromJson(Map<String, dynamic> json) => _JournalEntry(
        date: DateTime.parse(json['date']),
        text: json['text'],
        mood: json['mood'],
      );
}

class _MoodOption {
  final String emoji;
  final String label;
  final Color color;

  const _MoodOption({
    required this.emoji,
    required this.label,
    required this.color,
  });
}
