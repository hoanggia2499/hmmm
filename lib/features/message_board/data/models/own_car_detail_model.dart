import 'dart:convert';
import 'package:mirukuru/core/util/core_util.dart';

class OwnCarDetailModel {
  String? memberNum;
  String? userNum;
  String? userCarNum;
  String? carGrade;
  String? plateNo1;
  String? plateNo2;
  String? plateNo3;
  String? plateNo4;
  String? platformNum;
  String? makerCode;
  String? carCode;
  String? nHokenInc;
  String? carModel;
  String? sellTime;
  String? inspectionDate;
  String? nHokenEndDay;
  String? colorName;
  String? mileage;

  OwnCarDetailModel({
    required this.memberNum,
    required this.userNum,
    required this.userCarNum,
    required this.carGrade,
    required this.plateNo1,
    required this.plateNo2,
    required this.plateNo3,
    required this.plateNo4,
    required this.platformNum,
    required this.makerCode,
    required this.carCode,
    required this.nHokenInc,
    required this.carModel,
    required this.sellTime,
    required this.inspectionDate,
    required this.nHokenEndDay,
    required this.colorName,
    required this.mileage,
  });

  OwnCarDetailModel copyWith({
    String? memberNum,
    String? userNum,
    String? userCarNum,
    String? carGrade,
    String? plateNo1,
    String? plateNo2,
    String? plateNo3,
    String? plateNo4,
    String? platformNum,
    String? makerCode,
    String? carCode,
    String? nHokenInc,
    String? carModel,
    String? sellTime,
    String? inspectionDate,
    String? nHokenEndDay,
    String? colorName,
    String? mileage,
  }) {
    return OwnCarDetailModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
      carGrade: carGrade ?? this.carGrade,
      plateNo1: plateNo1 ?? this.plateNo1,
      plateNo2: plateNo2 ?? this.plateNo2,
      plateNo3: plateNo3 ?? this.plateNo3,
      plateNo4: plateNo4 ?? this.plateNo4,
      platformNum: platformNum ?? this.platformNum,
      makerCode: makerCode ?? this.makerCode,
      carCode: carCode ?? this.carCode,
      nHokenInc: nHokenInc ?? this.nHokenInc,
      carModel: carModel ?? this.carModel,
      sellTime: sellTime ?? this.sellTime,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      nHokenEndDay: nHokenEndDay ?? this.nHokenEndDay,
      colorName: colorName ?? this.colorName,
      mileage: mileage ?? this.mileage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
      'carGrade': carGrade,
      'plateNo1': plateNo1,
      'plateNo2': plateNo2,
      'plateNo3': plateNo3,
      'plateNo4': plateNo4,
      'platformNum': platformNum,
      'makerCode': makerCode,
      'carCode': carCode,
      'nHokenInc': nHokenInc,
      'carModel': carModel,
      'sellTime': sellTime,
      'inspectionDate': inspectionDate,
      'nHokenEndDay': nHokenEndDay,
      'colorName': colorName,
      'mileage': mileage,
    };
  }

  factory OwnCarDetailModel.fromMap(Map<String, dynamic> map) {
    return OwnCarDetailModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      carGrade: map['carGrade'] ?? '',
      plateNo1: map['plateNo1'] ?? '',
      plateNo2: map['plateNo2'] ?? '',
      plateNo3: map['plateNo3'] ?? '',
      plateNo4: map['plateNo4'] ?? '',
      platformNum: map['platformNum'] ?? '',
      makerCode: map['makerCode'] ?? '',
      carCode: map['carCode'] ?? '',
      nHokenInc: map['nHokenInc'] ?? '',
      carModel: map['carModel'] ?? '',
      sellTime: map['sellTime'] ?? '',
      inspectionDate: map['inspectionDate'] ?? '',
      nHokenEndDay: map['nHokenEndDay'] ?? '',
      colorName: map['colorName'] ?? '',
      mileage: map['mileage'] ?? '',
    );
  }

  factory OwnCarDetailModel.undefined() => OwnCarDetailUndefinedModel();

  String toJson() => json.encode(toMap());

  factory OwnCarDetailModel.fromJson(String source) =>
      OwnCarDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OwnCarDetailModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum, carGrade: $carGrade, plateNo1: $plateNo1, plateNo2: $plateNo2, plateNo3: $plateNo3, plateNo4: $plateNo4, platformNum: $platformNum, makerCode: $makerCode, carCode: $carCode, nHokenInc: $nHokenInc, carModel: $carModel, sellTime: $sellTime, inspectionDate: $inspectionDate, nHokenEndDay: $nHokenEndDay, colorName: $colorName, mileage: $mileage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OwnCarDetailModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userCarNum == userCarNum &&
        other.carGrade == carGrade &&
        other.plateNo1 == plateNo1 &&
        other.plateNo2 == plateNo2 &&
        other.plateNo3 == plateNo3 &&
        other.plateNo4 == plateNo4 &&
        other.platformNum == platformNum &&
        other.makerCode == makerCode &&
        other.carCode == carCode &&
        other.nHokenInc == nHokenInc &&
        other.carModel == carModel &&
        other.sellTime == sellTime &&
        other.inspectionDate == inspectionDate &&
        other.nHokenEndDay == nHokenEndDay &&
        other.colorName == colorName &&
        other.mileage == mileage;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        userCarNum.hashCode ^
        carGrade.hashCode ^
        plateNo1.hashCode ^
        plateNo2.hashCode ^
        plateNo3.hashCode ^
        plateNo4.hashCode ^
        platformNum.hashCode ^
        makerCode.hashCode ^
        carCode.hashCode ^
        nHokenInc.hashCode ^
        carModel.hashCode ^
        sellTime.hashCode ^
        inspectionDate.hashCode ^
        nHokenEndDay.hashCode ^
        colorName.hashCode ^
        mileage.hashCode;
  }

  static String displayCarModel(String carModel) {
    if (carModel != "    ") {
      return HelperFunction.instance
          .getJapanYearFromAd(int.tryParse(carModel) ?? 0);
    }
    return "";
  }

  static String displayMileage(String? rawMileage) {
    return "${rawMileage ?? 0}km";
  }

  static String displayName(String makerName, String carName, String carGrade) {
    return "$makerName $carName $carGrade";
  }
}

class OwnCarDetailUndefinedModel extends OwnCarDetailModel {
  OwnCarDetailUndefinedModel(
      {super.memberNum,
      super.userNum,
      super.userCarNum,
      super.carGrade,
      super.plateNo1,
      super.plateNo2,
      super.plateNo3,
      super.plateNo4,
      super.platformNum,
      super.makerCode,
      super.carCode,
      super.nHokenInc,
      super.carModel,
      super.sellTime,
      super.inspectionDate,
      super.nHokenEndDay,
      super.colorName,
      super.mileage});
}
