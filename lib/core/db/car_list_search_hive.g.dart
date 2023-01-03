// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_search_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarSearchHiveAdapter extends TypeAdapter<CarSearchHive> {
  @override
  final int typeId = 3;

  @override
  CarSearchHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarSearchHive(
      asnetCarCode: fields[2] as String?,
      carGroup: fields[3] as String?,
      makerCode: fields[0] as String?,
      makerName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CarSearchHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.makerCode)
      ..writeByte(1)
      ..write(obj.makerName)
      ..writeByte(2)
      ..write(obj.asnetCarCode)
      ..writeByte(3)
      ..write(obj.carGroup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarSearchHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
