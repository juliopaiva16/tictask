// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimePointAdapter extends TypeAdapter<TimePoint> {
  @override
  final int typeId = 1;

  @override
  TimePoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimePoint(
      timestamp: fields[0] as DateTime,
      isStart: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimePoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.isStart);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
