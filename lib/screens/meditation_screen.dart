import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import '../widgets/chakra_slider.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  Timer? _timer;
  int _secondsRemaining = 300; // 5 minutes default
  bool _isRunning = false;
  int _selectedDuration = 300;
  int _selectedMusicTrack = 0;
  bool _isMusicPlaying = false;

  // Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> _meditations = [
    {
      'title': 'Breathing',
      'emoji': '🌬️',
      'description': 'Deep breathing to calm mind',
    },
    {
      'title': 'Mantra',
      'emoji': '🕉️',
      'description': 'Sacred sound meditation',
    },
    {
      'title': 'Mindfulness',
      'emoji': '🧘',
      'description': 'Present moment awareness',
    },
    {
      'title': 'Chakra',
      'emoji': '✨',
      'description': 'Energy center balance',
    },
  ];

  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'Dhyana: The Art of Meditation',
      'emoji': '🧘',
      'story':
          'Dhyana is deep meditation where the mind becomes one with the object of contemplation. Like Arjuna focusing on the eye of the fish, when your mind settles on a single point, all distractions fade away. Practice Dhyana to calm the restless waves of thought.',
    },
    {
      'title': 'Prana: The Life Force',
      'emoji': '🌬️',
      'story':
          'Prana is the vital energy flowing through your body. Through pranayama (breathing exercises), you can control and direct this life force. Feel the Prana entering with each breath, nourishing every cell. Balance your Prana to balance your health and mind.',
    },
    {
      'title': 'Ekagra: Single-Pointed Focus',
      'emoji': '🎯',
      'story':
          'Ekagra means unwavering focus on one point. In ancient martial traditions, fighters attained mastery through Ekagra concentration. Focus your mind like a warrior, eliminate distractions, and conquer the battles within yourself.',
    },
    {
      'title': 'Shanti: Inner Peace',
      'emoji': '☮️',
      'story':
          'Shanti is the ultimate peace that comes from inner harmony. It is not the absence of challenges, but the presence of a calm, centered mind. Cultivate Shanti through meditation, and you will find serenity amidst the storm of life.',
    },
    {
      'title': 'The Abhimanyu\'s Focus',
      'emoji': '🛡️',
      'story':
          'Abhimanyu, a young warrior, demonstrated unwavering Dharma (duty) and concentration even in the most challenging situations. His story teaches us to maintain focus on our path and duties, regardless of external circumstances.',
    },
  ];
  final List<Map<String, dynamic>> _classicalTracks = [
    {
      'title': 'Raga Bhairav',
      'composer': 'Traditional',
      'duration': '5:43',
      'emoji': '🎵',
      'description': 'Ideal for early morning meditation and awakening',
      'audioFile': 'sounds/raga_bhairav_30sec.wav',
    },
    {
      'title': 'Raga Yaman',
      'composer': 'Traditional',
      'duration': '6:12',
      'emoji': '🎶',
      'description': 'Evening meditation for peace and relaxation',
      'audioFile': 'sounds/raga_yaman_30sec_melodious.wav',
    },
    {
      'title': 'Raga Malkauns',
      'composer': 'Traditional',
      'duration': '5:28',
      'emoji': '🎼',
      'description': 'Deep meditation and spiritual connection',
      'audioFile': 'sounds/raga_malkauns_30sec_melodious.wav',
    },
    {
      'title': 'Raga Ahir Bhairav',
      'composer': 'Traditional',
      'duration': '6:45',
      'emoji': '🎹',
      'description': 'Energizing and mood-lifting classical composition',
      'audioFile': 'sounds/raga_ahir_bhairav_30sec_melodious.wav',
    },
    {
      'title': 'Raga Jor',
      'composer': 'Traditional',
      'duration': '4:56',
      'emoji': '🥁',
      'description': 'Rhythmic meditation for focus and concentration',
      'audioFile': 'sounds/raga_jor_style_30sec.wav',
    },
  ];
  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseMusic() async {
    try {
      if (_isMusicPlaying) {
        // Pause music
        await _audioPlayer.pause();
        setState(() => _isMusicPlaying = false);
      } else {
        // Stop any currently playing track and play new one
        await _audioPlayer.stop();
        final audioFile = _classicalTracks[_selectedMusicTrack]['audioFile'];
        print('FILE EXISTS TEST: $audioFile');
        print('Playing audio: $audioFile');
        await _audioPlayer.play(AssetSource(audioFile));
        setState(() => _isMusicPlaying = true);
        print('Audio playback started successfully');
      }
    } catch (e) {
      print('Audio error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not play audio: $e')),
        );
      }
    }
  }

  Future<void> _changeTrack(int newIndex) async {
    try {
      // Stop current track
      await _audioPlayer.stop();
      setState(() {
        _selectedMusicTrack = newIndex;
        _isMusicPlaying = false;
      });
    } catch (e) {
      print('Audio error: $e');
    }
  }

  void _startTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meditation session complete!')),
          );
        }
      });
    });

    setState(() => _isRunning = true);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _selectedDuration;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
              title: 'Meditation & Wellness',
              subtitle: 'Mindfulness and inner peace',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Chakra Energy Meditation
            Text(
              'Chakra Energy Guide',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Text(
                      'Explore the 7 Energy Centers',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ChakraSlider(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Meditation Types
            Text(
              'Meditation Types',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ..._meditations.map((med) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Row(
                  children: [
                    Text(med['emoji'], style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(med['title'],
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(med['description'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: AppTheme.mutedForeground)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            )),
            const SizedBox(height: AppSpacing.lg),

            // Timer Section
            Text(
              'Meditation Timer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Timer Display
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _formatTime(_secondsRemaining),
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Duration Select
                  Text(
                    'Duration',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [300, 600, 900, 1200]
                        .map((duration) => ChoiceChip(
                              label: Text(
                                  '${(duration / 60).toInt()} min'),
                              selected: _selectedDuration == duration,
                              onSelected: _isRunning
                                  ? null
                                  : (selected) {
                                      setState(() {
                                        _selectedDuration = duration;
                                        _secondsRemaining = duration;
                                      });
                                    },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _startTimer,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _resetTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.mutedForeground,
                          ),
                          child: const Icon(Icons.refresh),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Ancient Stories
            Text(
              'Ancient Indian Wisdom',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ..._stories.map((story) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(story['emoji'],
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(story['title'],
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      story['story'],
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.mutedForeground),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: AppSpacing.lg),

            // Classical Music Section
            Text(
              'Classical Indian Music',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Current Track Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _classicalTracks[_selectedMusicTrack]['emoji'],
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _classicalTracks[_selectedMusicTrack]['title'],
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _classicalTracks[_selectedMusicTrack]['description'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.mutedForeground),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _classicalTracks[_selectedMusicTrack]['duration'],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Music Player Controls
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final newIndex = (_selectedMusicTrack - 1 + _classicalTracks.length) %
                                        _classicalTracks.length;
                            _changeTrack(newIndex);
                          },
                          icon: const Icon(Icons.skip_previous),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _playPauseMusic,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            _isMusicPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final newIndex = (_selectedMusicTrack + 1) %
                                        _classicalTracks.length;
                            _changeTrack(newIndex);
                          },
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Track List
                  Text(
                    'Available Tracks',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ..._classicalTracks.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> track = entry.value;
                    bool isSelected = _selectedMusicTrack == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(track['title']),
                          subtitle: Text(
                            '${track['composer']} • ${track['duration']}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 12,
                            ),
                          ),
                          leading: Text(track['emoji'],
                              style: const TextStyle(fontSize: 20)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle)
                              : null,
                          onTap: () {
                            if (index != _selectedMusicTrack) {
                              _changeTrack(index);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
