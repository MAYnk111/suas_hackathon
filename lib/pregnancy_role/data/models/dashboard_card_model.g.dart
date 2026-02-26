// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardCardModelAdapter extends TypeAdapter<DashboardCardModel> {
  @override
  final int typeId = 20;

  @override
  DashboardCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardCardModel(
      id: fields[0] as String,
      title: fields[1] as String,
      widgetType: fields[2] as String,
      order: fields[3] as int,
      isVisible: fields[4] as bool,
      settings: (fields[5] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardCardModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.widgetType)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.isVisible)
      ..writeByte(5)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
