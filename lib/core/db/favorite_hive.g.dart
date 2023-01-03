// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteHiveAdapter extends TypeAdapter<FavoriteHive> {
  @override
  final int typeId = 4;

  @override
  FavoriteHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteHive(
      questionNo: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteHive obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.questionNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
