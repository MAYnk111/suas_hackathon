// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diaper_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaperModelAdapter extends TypeAdapter<DiaperModel> {
  @override
  final int typeId = 7;

  @override
  DiaperModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaperModel(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      status: fields[2] as String,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiaperModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaperModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
