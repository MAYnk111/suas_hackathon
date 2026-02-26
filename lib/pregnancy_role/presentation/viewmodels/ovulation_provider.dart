import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/domain/services/ovulation_service.dart';

final ovulationServiceProvider = Provider<OvulationService>((ref) {
  return OvulationService();
});

final ovulationHealthProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(ovulationServiceProvider);
  return await service.healthCheck();
});

final ovulationPredictionProvider =
    FutureProvider.family<OvulationPrediction, Map<String, double>>((ref, params) async {
  final service = ref.watch(ovulationServiceProvider);
  
  return await service.predictOvulation(
    meanCycleLength: params['meanCycleLength'] ?? 28,
    lengthOfLutealPhase: params['lengthOfLutealPhase'] ?? 14,
    lengthOfMenses: params['lengthOfMenses'] ?? 5,
    prevCycleLength: params['prevCycleLength'] ?? 28,
    cycleStd: params['cycleStd'] ?? 1.5,
  );
});

