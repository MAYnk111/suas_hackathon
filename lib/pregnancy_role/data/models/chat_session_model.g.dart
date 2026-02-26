// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSessionModelAdapter extends TypeAdapter<ChatSessionModel> {
  @override
  final int typeId = 31;

  @override
  ChatSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSessionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      lastUpdated: fields[2] as DateTime,
      messages: (fields[3] as List).cast<ChatMessageModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatSessionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lastUpdated)
      ..writeByte(3)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
