// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoriesAdapter extends TypeAdapter<Memories> {
  @override
  final int typeId = 2;

  @override
  Memories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Memories()..memories = (fields[0] as List).cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, Memories obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.memories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
