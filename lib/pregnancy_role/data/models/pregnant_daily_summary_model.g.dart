// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnant_daily_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PregnantDailySummaryModelAdapter
    extends TypeAdapter<PregnantDailySummaryModel> {
  @override
  final int typeId = 25;

  @override
  PregnantDailySummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PregnantDailySummaryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
      gestationalWeek: fields[3] as int?,
      gestationalDay: fields[4] as int?,
      trimester: fields[5] as String?,
      babyMovementLogged: fields[6] as bool,
      kickCount: fields[7] as int?,
      symptoms: (fields[8] as List?)?.cast<String>(),
      waterIntakeMl: fields[9] as double?,
      prenatalVitaminsTaken: fields[10] as bool,
      restActivityLevel: fields[11] as String?,
      notes: fields[12] as String?,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PregnantDailySummaryModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.gestationalWeek)
      ..writeByte(4)
      ..write(obj.gestationalDay)
      ..writeByte(5)
      ..write(obj.trimester)
      ..writeByte(6)
      ..write(obj.babyMovementLogged)
      ..writeByte(7)
      ..write(obj.kickCount)
      ..writeByte(8)
      ..write(obj.symptoms)
      ..writeByte(9)
      ..write(obj.waterIntakeMl)
      ..writeByte(10)
      ..write(obj.prenatalVitaminsTaken)
      ..writeByte(11)
      ..write(obj.restActivityLevel)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PregnantDailySummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
