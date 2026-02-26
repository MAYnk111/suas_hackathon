// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalRecordModelAdapter extends TypeAdapter<MedicalRecordModel> {
  @override
  final int typeId = 5;

  @override
  MedicalRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalRecordModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      type: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      doctorName: fields[5] as String?,
      location: fields[6] as String?,
      attachments: (fields[7] as List?)?.cast<String>(),
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalRecordModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.doctorName)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.attachments)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
