import 'package:flutter/material.dart';

class ChakraSlider extends StatefulWidget {
  const ChakraSlider({super.key});

  @override
  State<ChakraSlider> createState() => _ChakraSliderState();
}

class _ChakraSliderState extends State<ChakraSlider>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> chakras = [
    {
      'name': 'Muladhara',
      'subtitle': 'Root Chakra',
      'color': const Color(0xFFE74C3C),
      'mantra': 'LAM',
      'affirmation': 'I am grounded and safe',
      'element': 'Earth',
      'location': 'Base of spine',
      'quality': 'Grounded\nSafe',
    },
    {
      'name': 'Swadisthana',
      'subtitle': 'Sacral Chakra',
      'color': const Color(0xFFF39C12),
      'mantra': 'VAM',
      'affirmation': 'I honor my emotions',
      'element': 'Water',
      'location': 'Lower abdomen',
      'quality': 'Independent\nEmotions',
    },
    {
      'name': 'Manipura',
      'subtitle': 'Solar Plexus Chakra',
      'color': const Color(0xFFF1C40F),
      'mantra': 'RAM',
      'affirmation': 'I am confident and strong',
      'element': 'Fire',
      'location': 'Solar plexus',
      'quality': 'Joyful\nConfident',
    },
    {
      'name': 'Anahata',
      'subtitle': 'Heart Chakra',
      'color': const Color(0xFF27AE60),
      'mantra': 'YAM',
      'affirmation': 'I am love and compassion',
      'element': 'Air',
      'location': 'Heart center',
      'quality': 'Peaceful\nBalance',
    },
    {
      'name': 'Vishuddhi',
      'subtitle': 'Throat Chakra',
      'color': const Color(0xFF16A085),
      'mantra': 'HAM',
      'affirmation': 'I speak my truth',
      'element': 'Ether',
      'location': 'Throat',
      'quality': 'Honesty\nHealing',
    },
    {
      'name': 'Ajna',
      'subtitle': 'Third Eye Chakra',
      'color': const Color(0xFF2E3697),
      'mantra': 'AUM',
      'affirmation': 'I trust my intuition',
      'element': 'Light',
      'location': 'Between eyebrows',
      'quality': 'Clarity\nWisdom',
    },
    {
      'name': 'Sahasrara',
      'subtitle': 'Crown Chakra',
      'color': const Color(0xFF8E44AD),
      'mantra': 'OM',
      'affirmation': 'I am spiritual connection',
      'element': 'Consciousness',
      'location': 'Crown of head',
      'quality': 'Spirituality\nConnection',
    },
  ];

  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextChakra() {
    if (_currentIndex < chakras.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousChakra() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page View for Chakra Cards
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _animationController.forward(from: 0.0);
            },
            itemCount: chakras.length,
            itemBuilder: (context, index) {
              final chakra = chakras[index];
              return ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(_animationController),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _ChakraCard(chakra: chakra),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Navigation Arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: _previousChakra,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: chakras[_currentIndex]['color'],
                foregroundColor: Colors.white,
              ),
            ),
            Text(
              '${_currentIndex + 1} / ${chakras.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _nextChakra,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: chakras[_currentIndex]['color'],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            chakras.length,
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? chakras[index]['color']
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChakraCard extends StatelessWidget {
  final Map<String, dynamic> chakra;

  const _ChakraCard({required this.chakra});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            chakra['color'],
            chakra['color'].withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: chakra['color'].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Column(
              children: [
                Text(
                  chakra['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chakra['subtitle'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),

            // Chakra Symbol (Unicode Circle)
            Text(
              '✨',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            // Mantra
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Mantra: ${chakra['mantra']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Details Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DetailBox(
                  label: 'Element',
                  value: chakra['element'],
                ),
                _DetailBox(
                  label: 'Location',
                  value: chakra['location'],
                ),
              ],
            ),

            // Affirmation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"${chakra['affirmation']}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBox extends StatelessWidget {
  final String label;
  final String value;

  const _DetailBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
