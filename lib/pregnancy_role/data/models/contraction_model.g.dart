// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contraction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractionModelAdapter extends TypeAdapter<ContractionModel> {
  @override
  final int typeId = 22;

  @override
  ContractionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractionModel(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
      durationSeconds: fields[3] as int,
      intervalSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ContractionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.durationSeconds)
      ..writeByte(4)
      ..write(obj.intervalSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
