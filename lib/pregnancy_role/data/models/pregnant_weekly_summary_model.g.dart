// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnant_weekly_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PregnantWeeklySummaryModelAdapter
    extends TypeAdapter<PregnantWeeklySummaryModel> {
  @override
  final int typeId = 26;

  @override
  PregnantWeeklySummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PregnantWeeklySummaryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      weekStart: fields[2] as DateTime,
      gestationalWeek: fields[3] as int?,
      weightKg: fields[4] as double?,
      weightChangeKg: fields[5] as double?,
      symptomFrequency: (fields[6] as Map?)?.cast<String, int>(),
      totalBabyMovementDays: fields[7] as int?,
      avgDailyWaterIntakeMl: fields[8] as double?,
      prenatalVitaminsDaysTaken: fields[9] as int?,
      predominantActivity: fields[10] as String?,
      appointments: (fields[11] as List?)?.cast<String>(),
      riskIndicators: (fields[12] as List?)?.cast<String>(),
      notes: fields[13] as String?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PregnantWeeklySummaryModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.weekStart)
      ..writeByte(3)
      ..write(obj.gestationalWeek)
      ..writeByte(4)
      ..write(obj.weightKg)
      ..writeByte(5)
      ..write(obj.weightChangeKg)
      ..writeByte(6)
      ..write(obj.symptomFrequency)
      ..writeByte(7)
      ..write(obj.totalBabyMovementDays)
      ..writeByte(8)
      ..write(obj.avgDailyWaterIntakeMl)
      ..writeByte(9)
      ..write(obj.prenatalVitaminsDaysTaken)
      ..writeByte(10)
      ..write(obj.predominantActivity)
      ..writeByte(11)
      ..write(obj.appointments)
      ..writeByte(12)
      ..write(obj.riskIndicators)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PregnantWeeklySummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
