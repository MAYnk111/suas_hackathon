import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_meta_provider.dart';

class DailyTipsPage extends ConsumerWidget {
  const DailyTipsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMeta = ref.watch(userMetaProvider);
    final startDate = userMeta.startDate;
    final now = DateTime.now();
    
    // Calculate current week
    int currentWeek = 1;
    if (startDate != null) {
      currentWeek = (now.difference(startDate).inDays / 7).floor() + 1;
    }
    
    // Clamp to 1-40 range for pregnancy
    currentWeek = currentWeek.clamp(1, 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Timeline'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: 40,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isCurrent = week == currentWeek;
              final isPast = week < currentWeek;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      // Timeline column
                      Column(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent 
                                  ? Theme.of(context).colorScheme.primary 
                                  : isPast 
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              border: isCurrent 
                                  ? Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 2) 
                                  : null,
                              boxShadow: isCurrent 
                                  ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), blurRadius: 10)] 
                                  : null,
                            ),
                          ),
                          if (week < 40)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: isPast ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Content column
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isCurrent 
                                ? Theme.of(context).colorScheme.surface 
                                : Theme.of(context).colorScheme.surface.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: isCurrent 
                                ? Border.all(color: Theme.of(context).colorScheme.secondary) 
                                : Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
                            boxShadow: [
                            BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Week $week',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isCurrent ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Today', 
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondary, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getTipForWeek(week),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(height: 12),
                                const Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 14, color: Theme.of(context).colorScheme.tertiary),
                                    const SizedBox(width: 4),
                                    Text('Baby is developing taste buds now!', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getTipForWeek(int week) {
    final tips = [
      'Initiate prenatal supplementation: folic acid (400-800 mcg daily) supports neural tube development during गर्भावस्था (pregnancy).',
      'Maintain hydration: 8-10 glasses water daily supports increased blood volume and prevents gestational complications.',
      'Manage nausea through small, frequent meals; vitamin B6 supplementation may provide symptom relief.',
      'Invest in supportive maternity undergarments to accommodate breast engorgement during गर्भविकास (fetal development).',
      'Establish baseline prenatal care: schedule first obstetric assessment and baseline laboratory screening.',
      'Dietary safety: eliminate high-mercury fish (shark, swordfish), undercooked proteins to prevent fetal exposure to pathogens.',
      'Prioritize sleep hygiene: 8-10 hours nightly supports metabolic adjustment to गर्भावस्था (pregnancy).',
      'Initiate gentle cardiovascular activity: walking 30 minutes daily improves maternal cardiovascular adaptation.',
      'Apply moisturizers containing collagen/elastin to minimize striae gravidarum (stretch marks) formation.',
      'Ensure adequate dietary iron intake: 27 mg daily supports expanded maternal blood volume.',
      'Practice body awareness: fatigue and dizziness indicate need for rest and cardiovascular support.',
      'Seek peer support groups: psychosocial support improves emotional adaptation during गर्भावस्था (pregnancy).',
      'Consume evidence-based prenatal literature on labor physiology and newborn care preparation.',
      'Maintain postural alignment: support lumbar spine as center of gravity shifts with growing uterus.',
      'Elevate lower extremities: reduces dependent edema and venous insufficiency during pregnancy.',
      'Increase dietary fiber to 25-30g daily; prevent pregnancy-related constipation common during गर्भविकास (fetal development).',
      'Practice pelvic floor strengthening (Kegel exercises): strengthens perineal musculature for labor preparation.',
      'Limit prolonged standing: reduces varicose vein formation and lower extremity edema.',
      'Side-lying position (left) optimizes uterine-placental perfusion and fetal oxygenation.',
      'Maintain optimal ambient temperature and hydration: prevent overheating during metabolic demands of गर्भावस्था (pregnancy).',
    ];
    
    return tips[(week - 1) % tips.length];
  }
}

