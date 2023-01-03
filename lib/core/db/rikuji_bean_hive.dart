import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class RikujiBeanHive extends HiveObject {
  @HiveField(0)
  int? nameKbn;
  @HiveField(1)
  String? nameCode;
  @HiveField(2)
  String? prefName;

  RikujiBeanHive({this.nameKbn, this.nameCode, this.prefName});
}

class RikujiBeanHiveAdapter extends TypeAdapter<RikujiBeanHive> {
  @override
  final int typeId = 2;

  @override
  RikujiBeanHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RikujiBeanHive(
      nameKbn: fields[0] as int?,
      nameCode: fields[1] as String?,
      prefName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RikujiBeanHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nameKbn)
      ..writeByte(1)
      ..write(obj.nameCode)
      ..writeByte(2)
      ..write(obj.prefName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RikujiBeanHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
