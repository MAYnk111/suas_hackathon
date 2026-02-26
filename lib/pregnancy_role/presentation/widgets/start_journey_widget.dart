import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_meta_provider.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/pregnancy_tracking_page.dart';
import 'package:sudha_app/pregnancy_role/core/utils/image_path_helper.dart';
import 'package:sudha_app/common/widgets/crash_safe_image.dart';
import 'package:sudha_app/common/widgets/safe_image.dart';

class StartJourneyWidget extends ConsumerWidget {
  const StartJourneyWidget({super.key});

  Widget _safeImageAsset(
    String? imagePath, {
    BoxFit? fit,
  }) {
    print('IMAGE PATH DEBUG: $imagePath');
    final resolvedPath =
        (imagePath != null && imagePath.isNotEmpty)
            ? imagePath
            : ImagePathHelper.defaultImage;
    
    // Use safe image helper for maximum protection
    return safeImage(
      resolvedPath,
      fit: fit ?? BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMeta = ref.watch(userMetaProvider);
    final startDate = userMeta.startDate;
    
    int daysPassed = 0;
    if (startDate != null) {
      daysPassed = DateTime.now().difference(startDate).inDays;
    }
    
    // Total pregnancy days ~280
    final double progress = (daysPassed / 280).clamp(0.0, 1.0);
    final int weeksPregnant = (daysPassed / 7).floor();
    final int currentMonth = ((weeksPregnant / 4).floor() + 1).clamp(1, 9);
    final String imagePath = ImagePathHelper.fetusImage(currentMonth);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PregnancyTrackingPage()),
        );
      },
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Baby Image Background
              _safeImageAsset(
                imagePath,
                fit: BoxFit.cover,
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Month $currentMonth',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Week $weeksPregnant • $daysPassed days',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.visibility, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'View',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${280 - daysPassed} days to go',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


