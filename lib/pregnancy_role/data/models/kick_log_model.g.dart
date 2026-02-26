// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kick_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KickLogModelAdapter extends TypeAdapter<KickLogModel> {
  @override
  final int typeId = 21;

  @override
  KickLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KickLogModel(
      id: fields[0] as String,
      sessionStart: fields[1] as DateTime,
      sessionEnd: fields[2] as DateTime,
      kickCount: fields[3] as int,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, KickLogModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionStart)
      ..writeByte(2)
      ..write(obj.sessionEnd)
      ..writeByte(3)
      ..write(obj.kickCount)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KickLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
