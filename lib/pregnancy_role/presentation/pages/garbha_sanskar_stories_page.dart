import 'package:flutter/material.dart';

class GarbhaSanskarStoriesPage extends StatelessWidget {
  const GarbhaSanskarStoriesPage({super.key});

  final List<_Story> _stories = const [
    _Story(
      title: 'The Wisdom of Abhimanyu',
      category: 'Ancient Wisdom',
      excerpt: 'The story of learning in the womb from the Mahabharata...',
      content:
          '''In the epic Mahabharata, it is told that Abhimanyu learned the complex military strategy of breaking the Chakravyuha formation while still in his mother Subhadra's womb.

As Arjuna described this intricate battle formation to Subhadra during her pregnancy, the unborn Abhimanyu absorbed every word. This ancient tale symbolizes the traditional belief in prenatal awareness and the significance of the environment and conversations around an expecting mother.

While modern science views consciousness differently, this story has inspired generations to create positive, enriching environments during pregnancy. It reminds us that what we surround ourselves with—whether peaceful music, positive thoughts, or loving conversations—can contribute to our overall wellbeing during this special time.

The tale emphasizes mindfulness and intentionality, encouraging mothers to be conscious of their mental and emotional state, creating a nurturing space for both themselves and their growing baby.''',
      icon: Icons.military_tech,
      color: Color(0xFFDAA520),
      readTime: '3 min',
    ),
    _Story(
      title: 'The Garden of Peace',
      category: 'Wisdom Tale',
      excerpt: 'A story about cultivating inner calm and serenity...',
      content:
          '''Once, in a village nestled between mountains, there lived a wise woman known for her peaceful presence. Expecting her first child, she spent her days tending to a beautiful garden.

Each morning, she would sit among the flowers, speaking softly to her baby. "Little one," she would say, "see how the roses bloom with patience. Notice how the trees stand strong yet flexible in the wind. Feel the warmth of the sun and the gentleness of the rain."

Her garden became a sanctuary—not just for plants, but for her own wellbeing and connection with her baby. She learned to be present, to find joy in small moments, and to nurture both the life growing within her and the life blooming around her.

When her child was born, neighbors remarked on the baby's calm disposition. The wise woman would smile and say, "We are all shaped by the gardens we tend—both within and without."

This tale reminds us that creating peaceful environments and cultivating inner serenity can contribute to our overall wellbeing during pregnancy. The practice of mindfulness, presence, and finding joy in nature's simple beauty are gifts we can give ourselves.''',
      icon: Icons.local_florist,
      color: Color(0xFF90EE90),
      readTime: '4 min',
    ),
    _Story(
      title: 'The Song of the River',
      category: 'Nature Story',
      excerpt: 'Finding flow and trust in life\'s natural rhythms...',
      content:
          '''A river flowed from the high mountains to the distant sea, sometimes rushing over rocks, sometimes pooling in quiet eddies, sometimes meandering through meadows.

A pregnant woman would visit this river each week, sitting on its banks, listening to its songs. In the rushing water, she heard energy and vitality. In the quiet pools, she found reflection and stillness. In the gentle meanders, she recognized patience and grace.

"Teach me your wisdom," she asked the river. "How do you know when to rush and when to rest?"

The river seemed to whisper back: "I don't resist. I flow with what is. I trust my path, even when it winds. I know that every part of my journey—the rapids and the calm—is necessary and purposeful."

The woman took this wisdom to heart. Through the ups and downs of her pregnancy, she remembered the river. When anxious, she pictured the calm pools. When impatient, she recalled the river's patient meandering. When excited, she felt the joy of water dancing over stones.

This story invites us to find our own flow, to trust our journey, and to know that every phase—challenging or easy—has its place and purpose. Like the river, we can adapt, persist, and find our way to where we're meant to be.''',
      icon: Icons.water,
      color: Color(0xFF87CEEB),
      readTime: '4 min',
    ),
    _Story(
      title: 'The Weaver\'s Gift',
      category: 'Inspirational',
      excerpt: 'Creating life\'s tapestry one thread at a time...',
      content:
          '''In an ancient kingdom, there lived a master weaver renowned for her exquisite tapestries. When she became pregnant, she began weaving a special piece—a tapestry that would tell her baby's story.

With each passing day, she added new threads. Gold threads for joy-filled moments. Blue threads for peaceful days. Silver threads for dreams and hopes. Green threads for growth and new beginnings.

Some days, the weaving came easily, and the pattern emerged beautifully. Other days, threads tangled or colors didn't blend as expected. But the weaver persisted, knowing that even imperfections added character and uniqueness to her creation.

Visitors would ask, "How do you know what to weave next?"

She would smile and say, "I don't always know. I weave what each day brings—the feelings, the experiences, the lessons. Every thread matters, even those I once thought were mistakes. They all come together to create something beautiful and uniquely ours."

When the baby was born, the tapestry was complete—a stunning work of art, imperfect yet perfect, telling the story of their journey together.

This tale reminds us that we're all weaving our own tapestries during pregnancy. Each day adds new threads—experiences, emotions, choices. Trust the process, embrace the imperfections, and know that you're creating something profoundly beautiful.''',
      icon: Icons.texture,
      color: Color(0xFFDDA0DD),
      readTime: '5 min',
    ),
    _Story(
      title: 'The Mountain and the Seed',
      category: 'Growth & Patience',
      excerpt: 'Understanding the power of patience and natural timing...',
      content:
          '''High in the mountains, a tiny seed fell into a crack in the rock. Seeing the massive mountains around it, the seed felt overwhelmed.

"How can I possibly grow here?" the seed wondered. "The mountains are so mighty, and I am so small."

The mountain, ancient and wise, spoke gently: "Little seed, do not compare your beginning to my present. I too was once small—just particles of dust that, over millions of years, came together. You have something I once had—the power to grow."

"But growing takes so long," the seed protested.

"Yes," agreed the mountain. "And that is its gift. Growth isn't just about becoming bigger or stronger. It's about becoming yourself, fully and authentically. Take your time. Trust your inner wisdom. You know how to grow—it's already within you."

Encouraged, the seed sent down roots and reached up toward the sun. Some days brought progress. Other days, growth was invisible. But each day, the seed was becoming more fully itself.

The expectant mother who heard this story took its wisdom to heart. She stopped worrying about timelines and comparing her journey to others. She trusted that growth—both hers and her baby's—was happening in perfect timing, even when she couldn't see it.

This tale celebrates patience, trust, and the understanding that profound transformations happen in their own time. Your journey is unique, and that is its beauty.''',
      icon: Icons.landscape,
      color: Color(0xFF8B4513),
      readTime: '5 min',
    ),
    _Story(
      title: 'The Two Lamps',
      category: 'Connection',
      excerpt: 'The invisible bond between mother and child...',
      content:
          '''In a temple stood two lamps side by side. One lamp had burned for many years, its flame steady and strong. The other lamp was newly placed, its wick waiting to be lit.

A pregnant woman visiting the temple noticed these lamps and asked the temple keeper, "Why doesn't someone light the new lamp?"

The keeper smiled wisely. "Watch," she said.

As they observed, the old lamp's flame flickered and danced, and in a magical moment, it leaned toward the new lamp. Without anyone touching them, the new lamp's wick caught fire, glowing with its own light.

"This is how it works," the keeper explained. "The lit lamp shares its flame without losing any of its own light. In fact, both flames now burn brighter together. The first lamp gave life to the second, yet remains whole and luminous."

The woman understood. "This is like the connection between a mother and her child."

"Yes," said the keeper. "You are the first lamp, burning with life and light. You are giving life to a new being, yet you remain yourself—your light doesn't diminish; it multiplies. Two lights now shine where once there was one. You are separate, yet connected. Independent, yet part of each other."

This ancient metaphor reminds us of the beautiful mystery of pregnancy—how we can give life to another while remaining fully ourselves, how love multiplies rather than divides, and how the connection between mother and child is both profound and inexplicable.''',
      icon: Icons.lightbulb,
      color: Color(0xFFFFD700),
      readTime: '4 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories & Tales'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.15),
                  colorScheme.primary.withOpacity(0.15),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 48,
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Uplifting Tales',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stories of wisdom, hope, and inspiration',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Stories List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _StoryCard(
                    story: story,
                    onTap: () => _showStoryDialog(context, story),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void _showStoryDialog(BuildContext context, _Story story) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      story.color.withOpacity(0.8),
                      story.color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(story.icon, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            story.category,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Story Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    story.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final _Story story;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: story.color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: story.color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        story.color,
                        story.color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: story.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    story.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: story.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.excerpt,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            story.readTime,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: story.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Story {
  final String title;
  final String category;
  final String excerpt;
  final String content;
  final IconData icon;
  final Color color;
  final String readTime;

  const _Story({
    required this.title,
    required this.category,
    required this.excerpt,
    required this.content,
    required this.icon,
    required this.color,
    required this.readTime,
  });
}
