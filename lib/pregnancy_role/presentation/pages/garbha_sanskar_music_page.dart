import 'package:flutter/material.dart';
import 'dart:async';

class GarbhaSanskarMusicPage extends StatefulWidget {
  const GarbhaSanskarMusicPage({super.key});

  @override
  State<GarbhaSanskarMusicPage> createState() => _GarbhaSanskarMusicPageState();
}

class _GarbhaSanskarMusicPageState extends State<GarbhaSanskarMusicPage> {
  String? _playingTrack;
  Timer? _progressTimer;
  double _progress = 0.0;
  bool _isPlaying = false;

  final List<_MusicTrack> _tracks = const [
    _MusicTrack(
      title: 'Morning Raga - Bhairav',
      category: 'Classical Raga',
      duration: '12:30',
      description:
          'Traditionally believed to create a serene morning atmosphere',
      color: Color(0xFFDAA520),
      icon: Icons.wb_sunny,
    ),
    _MusicTrack(
      title: 'Flute Meditation',
      category: 'Instrumental',
      duration: '15:00',
      description: 'Gentle bamboo flute melodies for deep relaxation',
      color: Color(0xFF800000),
      icon: Icons.music_note,
    ),
    _MusicTrack(
      title: 'Om Chanting',
      category: 'Mantra',
      duration: '10:00',
      description: 'Sacred vibrations for inner peace',
      color: Color(0xFFCD853F),
      icon: Icons.graphic_eq,
    ),
    _MusicTrack(
      title: 'Nature Sounds',
      category: 'Ambient',
      duration: '20:00',
      description: 'Forest, water, and birds - pure natural harmony',
      color: Color(0xFFB8860B),
      icon: Icons.nature,
    ),
    _MusicTrack(
      title: 'Lullaby Collection',
      category: 'Lullabies',
      duration: '18:45',
      description: 'Traditional Indian lullabies passed through generations',
      color: Color(0xFF8B4513),
      icon: Icons.child_care,
    ),
    _MusicTrack(
      title: 'Veena Meditation',
      category: 'Classical Instrumental',
      duration: '14:20',
      description: 'Soothing veena strings for contemplation',
      color: Color(0xFF654321),
      icon: Icons.piano,
    ),
  ];

  void _playTrack(String title) {
    setState(() {
      if (_playingTrack == title && _isPlaying) {
        _isPlaying = false;
        _progressTimer?.cancel();
      } else {
        _playingTrack = title;
        _isPlaying = true;
        _progress = 0.0;
        _startProgress();
      }
    });
  }

  void _startProgress() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isPlaying = false;
          _progress = 0.0;
        });
      } else {
        setState(() {
          _progress += 0.002; // Simulated progress
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music & Sounds'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Now Playing Section
          if (_playingTrack != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary,
                    colorScheme.secondary.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.music_note : Icons.pause,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Now Playing',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _playingTrack!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () => _playTrack(_playingTrack!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ],
              ),
            ),

          // Track List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
                final isPlaying = _playingTrack == track.title && _isPlaying;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MusicCard(
                    track: track,
                    isPlaying: isPlaying,
                    onPlay: () => _playTrack(track.title),
                  ),
                );
              },
            ),
          ),

          // Audio Placeholder Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.5),
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Audio playback simulation. Real audio integration coming soon.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicCard extends StatelessWidget {
  final _MusicTrack track;
  final bool isPlaying;
  final VoidCallback onPlay;

  const _MusicCard({
    required this.track,
    required this.isPlaying,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: track.color.withOpacity(isPlaying ? 0.8 : 0.3),
          width: isPlaying ? 2.5 : 1.5,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: track.color.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPlay,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: track.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: track.color.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    track.icon,
                    color: track.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: track.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: track.color,
                      size: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.duration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MusicTrack {
  final String title;
  final String category;
  final String duration;
  final String description;
  final Color color;
  final IconData icon;

  const _MusicTrack({
    required this.title,
    required this.category,
    required this.duration,
    required this.description,
    required this.color,
    required this.icon,
  });
}
