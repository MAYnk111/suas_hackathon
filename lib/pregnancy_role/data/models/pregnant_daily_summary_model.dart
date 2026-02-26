import 'package:hive/hive.dart';

part 'pregnant_daily_summary_model.g.dart';

@HiveType(typeId: 25)
class PregnantDailySummaryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final int? gestationalWeek;

  @HiveField(4)
  final int? gestationalDay;

  @HiveField(5)
  final String? trimester; // 1st, 2nd, 3rd

  @HiveField(6)
  final bool babyMovementLogged; // Yes / No

  @HiveField(7)
  final int? kickCount; // Optional if logged

  @HiveField(8)
  final List<String> symptoms; // e.g., ['fatigue', 'nausea', 'back_pain']

  @HiveField(9)
  final double? waterIntakeMl; // Liters in ml

  @HiveField(10)
  final bool prenatalVitaminsTaken; // Yes / No

  @HiveField(11)
  final String? restActivityLevel; // 'rest', 'light_activity', 'moderate_activity'

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  PregnantDailySummaryModel({
    required this.id,
    required this.userId,
    required this.date,
    this.gestationalWeek,
    this.gestationalDay,
    this.trimester,
    this.babyMovementLogged = false,
    this.kickCount,
    List<String>? symptoms,
    this.waterIntakeMl,
    this.prenatalVitaminsTaken = false,
    this.restActivityLevel,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : symptoms = symptoms ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  PregnantDailySummaryModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? gestationalWeek,
    int? gestationalDay,
    String? trimester,
    bool? babyMovementLogged,
    int? kickCount,
    List<String>? symptoms,
    double? waterIntakeMl,
    bool? prenatalVitaminsTaken,
    String? restActivityLevel,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PregnantDailySummaryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      gestationalWeek: gestationalWeek ?? this.gestationalWeek,
      gestationalDay: gestationalDay ?? this.gestationalDay,
      trimester: trimester ?? this.trimester,
      babyMovementLogged: babyMovementLogged ?? this.babyMovementLogged,
      kickCount: kickCount ?? this.kickCount,
      symptoms: symptoms ?? this.symptoms,
      waterIntakeMl: waterIntakeMl ?? this.waterIntakeMl,
      prenatalVitaminsTaken: prenatalVitaminsTaken ?? this.prenatalVitaminsTaken,
      restActivityLevel: restActivityLevel ?? this.restActivityLevel,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'gestational_week': gestationalWeek,
      'gestational_day': gestationalDay,
      'trimester': trimester,
      'baby_movement_logged': babyMovementLogged,
      'kick_count': kickCount,
      'symptoms': symptoms,
      'water_intake_ml': waterIntakeMl,
      'prenatal_vitamins_taken': prenatalVitaminsTaken,
      'rest_activity_level': restActivityLevel,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PregnantDailySummaryModel.fromMap(Map<String, dynamic> map) {
    return PregnantDailySummaryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      date: DateTime.parse(map['date'] as String),
      gestationalWeek: map['gestational_week'] as int?,
      gestationalDay: map['gestational_day'] as int?,
      trimester: map['trimester'] as String?,
      babyMovementLogged: (map['baby_movement_logged'] as bool?) ?? false,
      kickCount: map['kick_count'] as int?,
      symptoms: List<String>.from(map['symptoms'] as List? ?? []),
      waterIntakeMl: (map['water_intake_ml'] as num?)?.toDouble(),
      prenatalVitaminsTaken: (map['prenatal_vitamins_taken'] as bool?) ?? false,
      restActivityLevel: map['rest_activity_level'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
