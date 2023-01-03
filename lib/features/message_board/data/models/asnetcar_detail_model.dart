import 'dart:convert';

class AsnetCarDetailModel {
  final String tel;
  final int repairFlag;
  final String dtPointTotal;
  final String carName;
  final String makerName;
  final String carGrade;
  final String corner;
  final int aaCount;
  final int exhNum;
  final String fullExhNum;
  final int carModel;
  final int carVolume;
  final int carMileage;
  final String inspection;
  final String sysColorName;
  final String fuelName;
  final String carLocation;
  final String shiftName;
  final String price;
  final String stars;

  AsnetCarDetailModel({
    this.tel = '',
    this.repairFlag = 0,
    this.dtPointTotal = '',
    this.carName = '',
    this.makerName = '',
    this.carGrade = '',
    this.corner = '',
    this.aaCount = 0,
    this.exhNum = 0,
    this.fullExhNum = '',
    this.carModel = 0,
    this.carVolume = 0,
    this.carMileage = 0,
    this.inspection = '',
    this.sysColorName = '',
    this.fuelName = '',
    this.carLocation = '',
    this.shiftName = '',
    this.price = '0',
    this.stars = '',
  });

  AsnetCarDetailModel copyWith({
    String? tel,
    int? repairFlag,
    String? dtPointTotal,
    String? carName,
    String? makerName,
    String? carGrade,
    String? corner,
    int? aaCount,
    int? exhNum,
    String? fullExhNum,
    int? carModel,
    int? carVolume,
    int? carMileage,
    String? inspection,
    String? sysColorName,
    String? fuelName,
    String? carLocation,
    String? shiftName,
    String? price,
    String? stars,
  }) {
    return AsnetCarDetailModel(
      tel: tel ?? this.tel,
      repairFlag: repairFlag ?? this.repairFlag,
      dtPointTotal: dtPointTotal ?? this.dtPointTotal,
      carName: carName ?? this.carName,
      makerName: makerName ?? this.makerName,
      carGrade: carGrade ?? this.carGrade,
      corner: corner ?? this.corner,
      aaCount: aaCount ?? this.aaCount,
      exhNum: exhNum ?? this.exhNum,
      fullExhNum: fullExhNum ?? this.fullExhNum,
      carModel: carModel ?? this.carModel,
      carVolume: carVolume ?? this.carVolume,
      carMileage: carMileage ?? this.carMileage,
      inspection: inspection ?? this.inspection,
      sysColorName: sysColorName ?? this.sysColorName,
      fuelName: fuelName ?? this.fuelName,
      carLocation: carLocation ?? this.carLocation,
      shiftName: shiftName ?? this.shiftName,
      price: price ?? this.price,
      stars: stars ?? this.stars,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tel': tel,
      'repairFlag': repairFlag,
      'dtPointTotal': dtPointTotal,
      'carName': carName,
      'makerName': makerName,
      'carGrade': carGrade,
      'corner': corner,
      'aaCount': aaCount,
      'exhNum': exhNum,
      'fullExhNum': fullExhNum,
      'carModel': carModel,
      'carVolume': carVolume,
      'carMileage': carMileage,
      'inspection': inspection,
      'sysColorName': sysColorName,
      'fuelName': fuelName,
      'carLocation': carLocation,
      'shiftName': shiftName,
      'price': price,
      'stars': stars,
    };
  }

  factory AsnetCarDetailModel.fromMap(Map<String, dynamic> map) {
    return AsnetCarDetailModel(
      tel: map['tel'] ?? '',
      repairFlag: map['repairFlag']?.toInt() ?? 0,
      dtPointTotal: map['dtPointTotal'] ?? '',
      carName: map['carName'] ?? '',
      makerName: map['makerName'] ?? '',
      carGrade: map['carGrade'] ?? '',
      corner: map['corner'] ?? '',
      aaCount: map['aaCount']?.toInt() ?? 0,
      exhNum: map['exhNum']?.toInt() ?? 0,
      fullExhNum: map['fullExhNum'] ?? '',
      carModel: map['carModel']?.toInt() ?? 0,
      carVolume: map['carVolume']?.toInt() ?? 0,
      carMileage: map['carMileage']?.toInt() ?? 0,
      inspection: map['inspection'] ?? '',
      sysColorName: map['sysColorName'] ?? '',
      fuelName: map['fuelName'] ?? '',
      carLocation: map['carLocation'] ?? '',
      shiftName: map['shiftName'] ?? '',
      price: map['price'] ?? '',
      stars: map['stars'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AsnetCarDetailModel.fromJson(String source) =>
      AsnetCarDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuotationDetailModel(tel: $tel, repairFlag: $repairFlag, dtPointTotal: $dtPointTotal, carName: $carName, makerName: $makerName, carGrade: $carGrade, corner: $corner, aaCount: $aaCount, exhNum: $exhNum, fullExhNum: $fullExhNum, carModel: $carModel, carVolume: $carVolume, carMileage: $carMileage, inspection: $inspection, sysColorName: $sysColorName, fuelName: $fuelName, carLocation: $carLocation, shiftName: $shiftName, price: $price, stars: $stars)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AsnetCarDetailModel &&
        other.tel == tel &&
        other.repairFlag == repairFlag &&
        other.dtPointTotal == dtPointTotal &&
        other.carName == carName &&
        other.makerName == makerName &&
        other.carGrade == carGrade &&
        other.corner == corner &&
        other.aaCount == aaCount &&
        other.exhNum == exhNum &&
        other.fullExhNum == fullExhNum &&
        other.carModel == carModel &&
        other.carVolume == carVolume &&
        other.carMileage == carMileage &&
        other.inspection == inspection &&
        other.sysColorName == sysColorName &&
        other.fuelName == fuelName &&
        other.carLocation == carLocation &&
        other.shiftName == shiftName &&
        other.price == price &&
        other.stars == stars;
  }

  @override
  int get hashCode {
    return tel.hashCode ^
        repairFlag.hashCode ^
        dtPointTotal.hashCode ^
        carName.hashCode ^
        makerName.hashCode ^
        carGrade.hashCode ^
        corner.hashCode ^
        aaCount.hashCode ^
        exhNum.hashCode ^
        fullExhNum.hashCode ^
        carModel.hashCode ^
        carVolume.hashCode ^
        carMileage.hashCode ^
        inspection.hashCode ^
        sysColorName.hashCode ^
        fuelName.hashCode ^
        carLocation.hashCode ^
        shiftName.hashCode ^
        price.hashCode ^
        stars.hashCode;
  }
}
