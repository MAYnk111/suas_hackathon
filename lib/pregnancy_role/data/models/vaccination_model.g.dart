// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaccinationModelAdapter extends TypeAdapter<VaccinationModel> {
  @override
  final int typeId = 4;

  @override
  VaccinationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VaccinationModel(
      id: fields[0] as String,
      name: fields[1] as String,
      scheduledDate: fields[2] as DateTime,
      administeredDate: fields[3] as DateTime?,
      isCompleted: fields[4] as bool,
      batchNumber: fields[5] as String?,
      doctorName: fields[6] as String?,
      location: fields[7] as String?,
      ageInDays: fields[8] as int,
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VaccinationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scheduledDate)
      ..writeByte(3)
      ..write(obj.administeredDate)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.batchNumber)
      ..writeByte(6)
      ..write(obj.doctorName)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.ageInDays)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaccinationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
