import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/ovulation_provider.dart';

class OvulationPredictionPage extends ConsumerStatefulWidget {
  const OvulationPredictionPage({super.key});

  @override
  ConsumerState<OvulationPredictionPage> createState() => _OvulationPredictionPageState();
}

class _OvulationPredictionPageState extends ConsumerState<OvulationPredictionPage> {
  late TextEditingController _meanCycleController;
  late TextEditingController _lutealPhaseController;
  late TextEditingController _menesesLengthController;
  late TextEditingController _prevCycleController;
  late TextEditingController _cycleStdController;

  bool _isLoading = false;
  Map<String, double>? _predictionParams;

  @override
  void initState() {
    super.initState();
    _meanCycleController = TextEditingController(text: '28');
    _lutealPhaseController = TextEditingController(text: '14');
    _menesesLengthController = TextEditingController(text: '5');
    _prevCycleController = TextEditingController(text: '28');
    _cycleStdController = TextEditingController(text: '1.5');
  }

  @override
  void dispose() {
    _meanCycleController.dispose();
    _lutealPhaseController.dispose();
    _menesesLengthController.dispose();
    _prevCycleController.dispose();
    _cycleStdController.dispose();
    super.dispose();
  }

  void _predictOvulation() {
    final meanCycle = double.tryParse(_meanCycleController.text) ?? 28;
    final lutealPhase = double.tryParse(_lutealPhaseController.text) ?? 14;
    final menseLength = double.tryParse(_menesesLengthController.text) ?? 5;
    final prevCycle = double.tryParse(_prevCycleController.text) ?? 28;
    final cycleStd = double.tryParse(_cycleStdController.text) ?? 1.5;

    setState(() {
      _isLoading = true;
      _predictionParams = {
        'meanCycleLength': meanCycle,
        'lengthOfLutealPhase': lutealPhase,
        'lengthOfMenses': menseLength,
        'prevCycleLength': prevCycle,
        'cycleStd': cycleStd,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ovulation Prediction'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Card(
                color: colorScheme.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Ovulation Prediction',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your cycle details to predict your ovulation day and fertile window. Works best with 3+ logged cycles.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields Section
              Text(
                'Your Cycle Parameters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Mean Cycle Length
              _buildInputField(
                context,
                label: 'Average Cycle Length (days)',
                hint: '28',
                controller: _meanCycleController,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 12),

              // Luteal Phase Length
              _buildInputField(
                context,
                label: 'Luteal Phase Length (days)',
                hint: '14',
                controller: _lutealPhaseController,
                icon: Icons.nights_stay,
                subtitle: 'Usually 12-14 days',
              ),
              const SizedBox(height: 12),

              // Menses Length
              _buildInputField(
                context,
                label: 'Period Duration (days)',
                hint: '5',
                controller: _menesesLengthController,
                icon: Icons.bloodtype,
              ),
              const SizedBox(height: 12),

              // Previous Cycle Length
              _buildInputField(
                context,
                label: 'Previous Cycle Length (days)',
                hint: '28',
                controller: _prevCycleController,
                icon: Icons.history,
              ),
              const SizedBox(height: 12),

              // Cycle Variability
              _buildInputField(
                context,
                label: 'Cycle Variability (Std Dev)',
                hint: '1.5',
                controller: _cycleStdController,
                icon: Icons.show_chart,
                subtitle: 'How much your cycles vary (0 = regular)',
              ),
              const SizedBox(height: 24),

              // Predict Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _predictOvulation,
                  icon: const Icon(Icons.favorite),
                  label: _isLoading ? const Text('Predicting...') : const Text('Predict Ovulation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Prediction Result
              if (_predictionParams != null)
                _buildPredictionResult(context, colorScheme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: '   ',
            suffixText: '   ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionResult(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Consumer(
      builder: (context, ref, child) {
        final prediction = ref.watch(ovulationPredictionProvider(_predictionParams!));

        return prediction.when(
          data: (result) {
            final ovulationDay = result.predictedOvulationDay.toInt();
            final fertileStart = result.fertileWindow.first;
            final fertileEnd = result.fertileWindow.last;

            return Column(
              children: [
                // Success Card
                Card(
                  color: Colors.green.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              'Prediction Complete',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildResultRow(
                          context,
                          '❤️ Predicted Ovulation Day',
                          'Day $ovulationDay',
                          colorScheme,
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow(
                          context,
                          '🌸 Fertile Window',
                          'Days $fertileStart - $fertileEnd',
                          colorScheme,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.orange.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Try to have intercourse during the fertile window for the best chance of conception.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.orange.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Calendar View
                _buildCalendarView(context, ovulationDay, fertileStart, fertileEnd, colorScheme),
              ],
            );
          },
          loading: () => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Predicting your ovulation...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          error: (error, stack) {
            print('Error: $error');
            return Card(
              color: Colors.red.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Prediction Failed',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Could not reach the prediction service. Please check your internet connection and try again.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade900,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: $error',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade700,
                            fontFamily: 'monospace',
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 16,
              ),
        ),
      ],
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    int ovulationDay,
    int fertileStart,
    int fertileEnd,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Cycle Calendar',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 35,
              itemBuilder: (context, index) {
                final day = index + 1;
                bool isFertile = day >= fertileStart && day <= fertileEnd;
                bool isOvulation = day == ovulationDay;

                Color bgColor;
                Color textColor;

                if (isOvulation) {
                  bgColor = Colors.red.shade400;
                  textColor = Colors.white;
                } else if (isFertile) {
                  bgColor = Colors.orange.shade300;
                  textColor = Colors.white;
                } else {
                  bgColor = colorScheme.surface;
                  textColor = colorScheme.onSurface;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isOvulation ? Border.all(color: Colors.red, width: 2) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isOvulation ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ovulation Day',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Fertile Window',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

