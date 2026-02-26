class FertilityProfileModel {
  final String userId;
  final DateTime lmpDate;
  final int avgCycleLength;
  final bool cycleRegular;
  final DateTime? createdAt;

  FertilityProfileModel({
    required this.userId,
    required this.lmpDate,
    required this.avgCycleLength,
    required this.cycleRegular,
    this.createdAt,
  });

  factory FertilityProfileModel.fromMap(Map<String, dynamic> map) {
    return FertilityProfileModel(
      userId: map['user_id'] as String,
      lmpDate: DateTime.parse(map['lmp_date'] as String),
      avgCycleLength: (map['avg_cycle_length'] as num).toInt(),
      cycleRegular: map['cycle_regular'] as bool? ?? true,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'lmp_date': _formatDateOnly(lmpDate),
      'avg_cycle_length': avgCycleLength,
      'cycle_regular': cycleRegular,
    };
  }

  static String _formatDateOnly(DateTime date) {
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    return utcDate.toIso8601String().split('T').first;
  }
}
