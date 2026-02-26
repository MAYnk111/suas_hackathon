// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PregnancyModelAdapter extends TypeAdapter<PregnancyModel> {
  @override
  final int typeId = 0;

  @override
  PregnancyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PregnancyModel(
      id: fields[0] as String,
      dueDate: fields[1] as DateTime,
      lastPeriodDate: fields[2] as DateTime,
      currentMonth: fields[3] as int,
      monthlyChecklists: (fields[4] as Map?)?.cast<int, bool>(),
      completedTests: (fields[5] as List?)?.cast<String>(),
      riskSymptoms: (fields[6] as List?)?.cast<String>(),
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PregnancyModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dueDate)
      ..writeByte(2)
      ..write(obj.lastPeriodDate)
      ..writeByte(3)
      ..write(obj.currentMonth)
      ..writeByte(4)
      ..write(obj.monthlyChecklists)
      ..writeByte(5)
      ..write(obj.completedTests)
      ..writeByte(6)
      ..write(obj.riskSymptoms)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PregnancyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
