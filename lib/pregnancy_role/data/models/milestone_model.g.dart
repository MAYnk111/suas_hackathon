// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneModelAdapter extends TypeAdapter<MilestoneModel> {
  @override
  final int typeId = 23;

  @override
  MilestoneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MilestoneModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      ageMonthsMin: fields[3] as int,
      ageMonthsMax: fields[4] as int,
      isCompleted: fields[5] as bool,
      completedDate: fields[6] as DateTime?,
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MilestoneModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.ageMonthsMin)
      ..writeByte(4)
      ..write(obj.ageMonthsMax)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedDate)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
