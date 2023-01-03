import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class UserCarHive extends HiveObject {
  @HiveField(0)
  String? memberNum;
  @HiveField(1)
  String? userNum;
  @HiveField(2)
  String? userCarNum;
  @HiveField(3)
  String? carGrade;
  @HiveField(4)
  String? plateNo1;
  @HiveField(5)
  String? plateNo2;
  @HiveField(6)
  String? plateNo3;
  @HiveField(7)
  String? plateNo4;
  @HiveField(8)
  String? platformNum;
  @HiveField(9)
  String? makerCode;
  @HiveField(10)
  String? carCode;
  @HiveField(11)
  String? nHokenInc;
  @HiveField(12)
  String? carModel;
  @HiveField(13)
  String? sellTime;
  @HiveField(14)
  String? inspectionDate;
  @HiveField(15)
  String? nHokenEndDay;
  @HiveField(16)
  String? colorName;
  @HiveField(17)
  int? mileage;
  @HiveField(18)
  String? mobilePhone;
  UserCarHive(
      {this.memberNum,
      this.userNum,
      this.userCarNum,
      this.carGrade,
      this.plateNo1,
      this.plateNo2,
      this.plateNo3,
      this.plateNo4,
      this.platformNum,
      this.makerCode,
      this.carCode,
      this.nHokenInc,
      this.carModel,
      this.sellTime,
      this.inspectionDate,
      this.nHokenEndDay,
      this.colorName,
      this.mileage,
      this.mobilePhone});
}

class UserCarHiveAdapter extends TypeAdapter<UserCarHive> {
  @override
  final int typeId = 7;

  @override
  UserCarHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCarHive(
        memberNum: fields[0] as String?,
        userNum: fields[1] as String?,
        userCarNum: fields[2] as String?,
        carGrade: fields[3] as String?,
        plateNo1: fields[4] as String?,
        plateNo2: fields[5] as String?,
        plateNo3: fields[6] as String?,
        plateNo4: fields[7] as String?,
        platformNum: fields[8] as String?,
        makerCode: fields[9] as String?,
        carCode: fields[10] as String?,
        nHokenInc: fields[11] as String?,
        carModel: fields[12] as String?,
        sellTime: fields[13] as String?,
        inspectionDate: fields[14] as String?,
        nHokenEndDay: fields[15] as String?,
        colorName: fields[16] as String?,
        mileage: fields[17] as int?,
        mobilePhone: fields[18] as String?);
  }

  @override
  void write(BinaryWriter writer, UserCarHive obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.memberNum)
      ..writeByte(1)
      ..write(obj.userNum)
      ..writeByte(2)
      ..write(obj.userCarNum)
      ..writeByte(3)
      ..write(obj.carGrade)
      ..writeByte(4)
      ..write(obj.plateNo1)
      ..writeByte(5)
      ..write(obj.plateNo2)
      ..writeByte(6)
      ..write(obj.plateNo3)
      ..writeByte(7)
      ..write(obj.plateNo4)
      ..writeByte(8)
      ..write(obj.platformNum)
      ..writeByte(9)
      ..write(obj.makerCode)
      ..writeByte(10)
      ..write(obj.carCode)
      ..writeByte(11)
      ..write(obj.nHokenInc)
      ..writeByte(12)
      ..write(obj.carModel)
      ..writeByte(13)
      ..write(obj.sellTime)
      ..writeByte(14)
      ..write(obj.inspectionDate)
      ..writeByte(15)
      ..write(obj.nHokenEndDay)
      ..writeByte(16)
      ..write(obj.colorName)
      ..writeByte(17)
      ..write(obj.mileage)
      ..writeByte(18)
      ..write(obj.mobilePhone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCarHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
