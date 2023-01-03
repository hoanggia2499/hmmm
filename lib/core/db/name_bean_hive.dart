import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class NameBeanHive extends HiveObject {
  @HiveField(0)
  int? nameKbn;
  @HiveField(1)
  int? nameCode;
  @HiveField(2)
  String? name;

  NameBeanHive({this.nameKbn, this.nameCode, this.name});
}

class NameBeanHiveAdapter extends TypeAdapter<NameBeanHive> {
  @override
  final int typeId = 1;

  @override
  NameBeanHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameBeanHive(
      nameKbn: fields[0] as int?,
      nameCode: fields[1] as int?,
      name: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NameBeanHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nameKbn)
      ..writeByte(1)
      ..write(obj.nameCode)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameBeanHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
