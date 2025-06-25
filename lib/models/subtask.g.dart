// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubtaskAdapter extends TypeAdapter<Subtask> {
  @override
  final int typeId = 2;

  @override
  Subtask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subtask(
      id: fields[0] as String,
      title: fields[1] as String,
      timePoints: (fields[2] as List).cast<TimePoint>(),
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Subtask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.timePoints)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
