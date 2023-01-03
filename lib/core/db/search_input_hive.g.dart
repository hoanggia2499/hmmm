// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_input_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchInputHiveAdapter extends TypeAdapter<SearchInputHive> {
  @override
  final int typeId = 6;

  @override
  SearchInputHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchInputHive(
      memberNum: fields[0] as String,
      callCount: fields[1] as int,
      makerCode1: fields[2] as String,
      makerCode2: fields[3] as String,
      makerCode3: fields[4] as String,
      makerCode4: fields[5] as String,
      makerCode5: fields[6] as String,
      carName1: fields[7] as String,
      carName2: fields[8] as String,
      carName3: fields[9] as String,
      carName4: fields[10] as String,
      carName5: fields[11] as String,
      nenshiki1: fields[12] as String,
      nenshiki2: fields[13] as String,
      distance1: fields[14] as String,
      distance2: fields[15] as String,
      haikiryou1: fields[16] as String,
      haikiryou2: fields[17] as String,
      price1: fields[18] as String,
      price2: fields[19] as String,
      inspection: fields[20] as String,
      repair: fields[21] as String,
      mission: fields[22] as String,
      freeword: fields[23] as String,
      color: fields[24] as String,
      area: fields[25] as String,
      makerName: fields[26] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchInputHive obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.memberNum)
      ..writeByte(1)
      ..write(obj.callCount)
      ..writeByte(2)
      ..write(obj.makerCode1)
      ..writeByte(3)
      ..write(obj.makerCode2)
      ..writeByte(4)
      ..write(obj.makerCode3)
      ..writeByte(5)
      ..write(obj.makerCode4)
      ..writeByte(6)
      ..write(obj.makerCode5)
      ..writeByte(7)
      ..write(obj.carName1)
      ..writeByte(8)
      ..write(obj.carName2)
      ..writeByte(9)
      ..write(obj.carName3)
      ..writeByte(10)
      ..write(obj.carName4)
      ..writeByte(11)
      ..write(obj.carName5)
      ..writeByte(12)
      ..write(obj.nenshiki1)
      ..writeByte(13)
      ..write(obj.nenshiki2)
      ..writeByte(14)
      ..write(obj.distance1)
      ..writeByte(15)
      ..write(obj.distance2)
      ..writeByte(16)
      ..write(obj.haikiryou1)
      ..writeByte(17)
      ..write(obj.haikiryou2)
      ..writeByte(18)
      ..write(obj.price1)
      ..writeByte(19)
      ..write(obj.price2)
      ..writeByte(20)
      ..write(obj.inspection)
      ..writeByte(21)
      ..write(obj.repair)
      ..writeByte(22)
      ..write(obj.mission)
      ..writeByte(23)
      ..write(obj.freeword)
      ..writeByte(24)
      ..write(obj.color)
      ..writeByte(25)
      ..write(obj.area)
      ..writeByte(26)
      ..write(obj.makerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchInputHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
