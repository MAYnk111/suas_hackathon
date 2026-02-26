import 'package:hive/hive.dart';

part 'pregnant_weekly_summary_model.g.dart';

@HiveType(typeId: 26)
class PregnantWeeklySummaryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime weekStart; // Start of the week (Monday)

  @HiveField(3)
  final int? gestationalWeek;

  @HiveField(4)
  final double? weightKg; // Weight at end of week (optional)

  @HiveField(5)
  final double? weightChangeKg; // Change from previous week

  @HiveField(6)
  final Map<String, int>? symptomFrequency; // e.g., {'fatigue': 5, 'nausea': 3}

  @HiveField(7)
  final int? totalBabyMovementDays; // Days logged movement

  @HiveField(8)
  final double? avgDailyWaterIntakeMl;

  @HiveField(9)
  final int? prenatalVitaminsDaysTaken; // Out of 7

  @HiveField(10)
  final String? predominantActivity; // 'rest', 'light', 'moderate'

  @HiveField(11)
  final List<String> appointments; // Appointment/scan dates

  @HiveField(12)
  final List<String> riskIndicators; // Non-diagnostic informational flags

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  PregnantWeeklySummaryModel({
    required this.id,
    required this.userId,
    required this.weekStart,
    this.gestationalWeek,
    this.weightKg,
    this.weightChangeKg,
    this.symptomFrequency,
    this.totalBabyMovementDays,
    this.avgDailyWaterIntakeMl,
    this.prenatalVitaminsDaysTaken,
    this.predominantActivity,
    List<String>? appointments,
    List<String>? riskIndicators,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : appointments = appointments ?? [],
        riskIndicators = riskIndicators ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  PregnantWeeklySummaryModel copyWith({
    String? id,
    String? userId,
    DateTime? weekStart,
    int? gestationalWeek,
    double? weightKg,
    double? weightChangeKg,
    Map<String, int>? symptomFrequency,
    int? totalBabyMovementDays,
    double? avgDailyWaterIntakeMl,
    int? prenatalVitaminsDaysTaken,
    String? predominantActivity,
    List<String>? appointments,
    List<String>? riskIndicators,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PregnantWeeklySummaryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weekStart: weekStart ?? this.weekStart,
      gestationalWeek: gestationalWeek ?? this.gestationalWeek,
      weightKg: weightKg ?? this.weightKg,
      weightChangeKg: weightChangeKg ?? this.weightChangeKg,
      symptomFrequency: symptomFrequency ?? this.symptomFrequency,
      totalBabyMovementDays: totalBabyMovementDays ?? this.totalBabyMovementDays,
      avgDailyWaterIntakeMl: avgDailyWaterIntakeMl ?? this.avgDailyWaterIntakeMl,
      prenatalVitaminsDaysTaken: prenatalVitaminsDaysTaken ?? this.prenatalVitaminsDaysTaken,
      predominantActivity: predominantActivity ?? this.predominantActivity,
      appointments: appointments ?? this.appointments,
      riskIndicators: riskIndicators ?? this.riskIndicators,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'week_start': weekStart.toIso8601String(),
      'gestational_week': gestationalWeek,
      'weight_kg': weightKg,
      'weight_change_kg': weightChangeKg,
      'symptom_frequency': symptomFrequency,
      'total_baby_movement_days': totalBabyMovementDays,
      'avg_daily_water_intake_ml': avgDailyWaterIntakeMl,
      'prenatal_vitamins_days_taken': prenatalVitaminsDaysTaken,
      'predominant_activity': predominantActivity,
      'appointments': appointments,
      'risk_indicators': riskIndicators,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PregnantWeeklySummaryModel.fromMap(Map<String, dynamic> map) {
    return PregnantWeeklySummaryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      weekStart: DateTime.parse(map['week_start'] as String),
      gestationalWeek: map['gestational_week'] as int?,
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      weightChangeKg: (map['weight_change_kg'] as num?)?.toDouble(),
      symptomFrequency: map['symptom_frequency'] != null
          ? Map<String, int>.from(map['symptom_frequency'] as Map)
          : null,
      totalBabyMovementDays: map['total_baby_movement_days'] as int?,
      avgDailyWaterIntakeMl: (map['avg_daily_water_intake_ml'] as num?)?.toDouble(),
      prenatalVitaminsDaysTaken: map['prenatal_vitamins_days_taken'] as int?,
      predominantActivity: map['predominant_activity'] as String?,
      appointments: List<String>.from(map['appointments'] as List? ?? []),
      riskIndicators: List<String>.from(map['risk_indicators'] as List? ?? []),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
