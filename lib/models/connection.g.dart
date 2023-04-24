// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConnectionAdapter extends TypeAdapter<Connection> {
  @override
  final int typeId = 2;

  @override
  Connection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Connection(
      fields[3] as String,
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Connection obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.endpoint)
      ..writeByte(1)
      ..write(obj.accessKey)
      ..writeByte(2)
      ..write(obj.secretKey)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.bucket);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
