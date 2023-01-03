import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class ItemSearchHive {
  @HiveField(0)
  String carName;
  @HiveField(1)
  String makerName;
  @HiveField(2)
  String makerCode;
  @HiveField(3)
  String carGrade;
  @HiveField(4)
  String corner;
  @HiveField(5)
  String fullExhNum;
  @HiveField(6)
  String inspection;
  @HiveField(7)
  String sysColorName;
  @HiveField(8)
  String fuelName;
  @HiveField(9)
  String carLocation;
  @HiveField(10)
  String shiftName;
  @HiveField(11)
  String dT_PointTotal;
  @HiveField(12)
  int aaCount;
  @HiveField(13)
  int exhNum;
  @HiveField(14)
  int carVolume;
  @HiveField(15)
  int carMileage;
  @HiveField(16)
  int carModel;
  @HiveField(17)
  int repairflag;
  @HiveField(18)
  String tel;
  @HiveField(19)
  int price;
  @HiveField(20)
  int stars;
  @HiveField(21)
  String questionNo;
  @HiveField(22)
  dynamic priceValue;
  @HiveField(23)
  dynamic priceValue2;

  ItemSearchHive(
      {this.inspection = '',
      this.carName = '',
      this.makerCode = '',
      this.makerName = '',
      this.aaCount = 0,
      this.carGrade = '',
      this.carLocation = '',
      this.carMileage = 0,
      this.carModel = 0,
      this.carVolume = 0,
      this.corner = '',
      this.dT_PointTotal = '',
      this.exhNum = 0,
      this.fuelName = '',
      this.fullExhNum = '',
      this.price = 0,
      this.repairflag = 0,
      this.shiftName = '',
      this.stars = 0,
      this.sysColorName = '',
      this.tel = '',
      this.questionNo = '',
      this.priceValue = '',
      this.priceValue2 = ''});
}

class ItemSearchHiveAdapter extends TypeAdapter<ItemSearchHive> {
  @override
  final int typeId = 5;

  @override
  ItemSearchHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemSearchHive(
      inspection: fields[6] as String,
      carName: fields[0] as String,
      makerCode: fields[2] as String,
      makerName: fields[1] as String,
      aaCount: fields[12] as int,
      carGrade: fields[3] as String,
      carLocation: fields[9] as String,
      carMileage: fields[15] as int,
      carModel: fields[16] as int,
      carVolume: fields[14] as int,
      corner: fields[4] as String,
      dT_PointTotal: fields[11] as String,
      exhNum: fields[13] as int,
      fuelName: fields[8] as String,
      fullExhNum: fields[5] as String,
      price: fields[19] as int,
      repairflag: fields[17] as int,
      shiftName: fields[10] as String,
      stars: fields[20] as int,
      sysColorName: fields[7] as String,
      tel: fields[18] as String,
      questionNo: fields[21] as String,
      priceValue: fields[22] as dynamic,
      priceValue2: fields[23] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ItemSearchHive obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.carName)
      ..writeByte(1)
      ..write(obj.makerName)
      ..writeByte(2)
      ..write(obj.makerCode)
      ..writeByte(3)
      ..write(obj.carGrade)
      ..writeByte(4)
      ..write(obj.corner)
      ..writeByte(5)
      ..write(obj.fullExhNum)
      ..writeByte(6)
      ..write(obj.inspection)
      ..writeByte(7)
      ..write(obj.sysColorName)
      ..writeByte(8)
      ..write(obj.fuelName)
      ..writeByte(9)
      ..write(obj.carLocation)
      ..writeByte(10)
      ..write(obj.shiftName)
      ..writeByte(11)
      ..write(obj.dT_PointTotal)
      ..writeByte(12)
      ..write(obj.aaCount)
      ..writeByte(13)
      ..write(obj.exhNum)
      ..writeByte(14)
      ..write(obj.carVolume)
      ..writeByte(15)
      ..write(obj.carMileage)
      ..writeByte(16)
      ..write(obj.carModel)
      ..writeByte(17)
      ..write(obj.repairflag)
      ..writeByte(18)
      ..write(obj.tel)
      ..writeByte(19)
      ..write(obj.price)
      ..writeByte(20)
      ..write(obj.stars)
      ..writeByte(21)
      ..write(obj.questionNo)
      ..writeByte(22)
      ..write(obj.priceValue)
      ..writeByte(23)
      ..write(obj.priceValue2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemSearchHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
