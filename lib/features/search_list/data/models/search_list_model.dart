import 'dart:convert';

import 'package:mirukuru/core/db/search_input_hive.dart';

import '../../../../core/network/paginated_data_request_model.dart';

class SearchListModel extends PaginatedDataRequestModel {
  String memberNum;
  int callCount;
  String makerName;
  String makerCode1;
  String makerCode2;
  String makerCode3;
  String makerCode4;
  String makerCode5;
  String carName1;
  String carName2;
  String carName3;
  String carName4;
  String carName5;
  String nenshiki1; // year
  String nenshiki2;
  String distance1;
  String distance2;
  String haikiryou1; //cc
  String haikiryou2;
  String price1;
  String price2;
  String inspection;
  String repair;
  String mission; //Manual Transmission
  String freeword;
  String color;
  String area;

  SearchListModel({
    int pageIndex = 1,
    int pageSize = 10,
    this.memberNum = '',
    this.callCount = 1,
    this.makerName = '',
    this.makerCode1 = '',
    this.makerCode2 = '',
    this.makerCode3 = '',
    this.makerCode4 = '',
    this.makerCode5 = '',
    this.carName1 = '',
    this.carName2 = '',
    this.carName3 = '',
    this.carName4 = '',
    this.carName5 = '',
    this.nenshiki1 = '',
    this.nenshiki2 = '',
    this.distance1 = '',
    this.distance2 = '',
    this.haikiryou1 = '',
    this.haikiryou2 = '',
    this.price1 = '',
    this.price2 = '',
    this.inspection = '',
    this.repair = '',
    this.mission = '',
    this.freeword = '',
    this.color = '',
    this.area = '',
  }) : super(pageIndex: pageIndex, pageSize: pageSize);

  factory SearchListModel.mapFromHiveObject(SearchInputHive hiveObj) {
    return new SearchListModel(
        memberNum: hiveObj.memberNum,
        callCount: hiveObj.callCount,
        makerCode1: hiveObj.makerCode1,
        makerCode2: hiveObj.makerCode2,
        makerCode3: hiveObj.makerCode3,
        makerCode4: hiveObj.makerCode4,
        makerCode5: hiveObj.makerCode5,
        carName1: hiveObj.carName1,
        carName2: hiveObj.carName2,
        carName3: hiveObj.carName3,
        carName4: hiveObj.carName4,
        carName5: hiveObj.carName5,
        nenshiki1: hiveObj.nenshiki1,
        nenshiki2: hiveObj.nenshiki2,
        distance1: hiveObj.distance1,
        distance2: hiveObj.distance2,
        haikiryou1: hiveObj.haikiryou1,
        haikiryou2: hiveObj.haikiryou2,
        price1: hiveObj.price1,
        price2: hiveObj.price2,
        inspection: hiveObj.inspection,
        mission: hiveObj.mission,
        freeword: hiveObj.freeword,
        color: hiveObj.color,
        repair: hiveObj.repair,
        area: hiveObj.area,
        makerName: hiveObj.makerName);
  }

  SearchListModel copyWith({
    String? memberNum,
    int? callCount,
    String? makerName,
    String? makerCode1,
    String? makerCode2,
    String? makerCode3,
    String? makerCode4,
    String? makerCode5,
    String? carName1,
    String? carName2,
    String? carName3,
    String? carName4,
    String? carName5,
    String? nenshiki1,
    String? nenshiki2,
    String? distance1,
    String? distance2,
    String? haikiryou1,
    String? haikiryou2,
    String? price1,
    String? price2,
    String? inspection,
    String? repair,
    String? mission,
    String? freeword,
    String? color,
    String? area,
    int? pageIndex,
    int? pageSize,
  }) {
    return SearchListModel(
        memberNum: memberNum ?? this.memberNum,
        callCount: callCount ?? this.callCount,
        makerName: makerName ?? this.makerName,
        makerCode1: makerCode1 ?? this.makerCode1,
        makerCode2: makerCode2 ?? this.makerCode2,
        makerCode3: makerCode3 ?? this.makerCode3,
        makerCode4: makerCode4 ?? this.makerCode4,
        makerCode5: makerCode5 ?? this.makerCode5,
        carName1: carName1 ?? this.carName1,
        carName2: carName2 ?? this.carName2,
        carName3: carName3 ?? this.carName3,
        carName4: carName4 ?? this.carName4,
        carName5: carName5 ?? this.carName5,
        nenshiki1: nenshiki1 ?? this.nenshiki1,
        nenshiki2: nenshiki2 ?? this.nenshiki2,
        distance1: distance1 ?? this.distance1,
        distance2: distance2 ?? this.distance2,
        haikiryou1: haikiryou1 ?? this.haikiryou1,
        haikiryou2: haikiryou2 ?? this.haikiryou2,
        price1: price1 ?? this.price1,
        price2: price2 ?? this.price2,
        inspection: inspection ?? this.inspection,
        repair: repair ?? this.repair,
        mission: mission ?? this.mission,
        freeword: freeword ?? this.freeword,
        color: color ?? this.color,
        area: area ?? this.area,
        pageIndex: pageIndex ?? this.pageIndex,
        pageSize: pageSize ?? this.pageSize);
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'callCount': callCount,
      'makerName': makerName,
      'makerCode1': makerCode1,
      'makerCode2': makerCode2,
      'makerCode3': makerCode3,
      'makerCode4': makerCode4,
      'makerCode5': makerCode5,
      'carName1': carName1,
      'carName2': carName2,
      'carName3': carName3,
      'carName4': carName4,
      'carName5': carName5,
      'nenshiki1': nenshiki1,
      'nenshiki2': nenshiki2,
      'distance1': distance1,
      'distance2': distance2,
      'haikiryou1': haikiryou1,
      'haikiryou2': haikiryou2,
      'price1': price1,
      'price2': price2,
      'inspection': inspection,
      'repair': repair,
      'mission': mission,
      'freeword': freeword,
      'color': color,
      'area': area,
    };
  }

  factory SearchListModel.fromMap(Map<String, dynamic> map) {
    return SearchListModel(
      memberNum: map['memberNum'] ?? '',
      callCount: map['callCount']?.toInt() ?? 0,
      makerName: map['makerName'] ?? '',
      makerCode1: map['makerCode1'] ?? '',
      makerCode2: map['makerCode2'] ?? '',
      makerCode3: map['makerCode3'] ?? '',
      makerCode4: map['makerCode4'] ?? '',
      makerCode5: map['makerCode5'] ?? '',
      carName1: map['carName1'] ?? '',
      carName2: map['carName2'] ?? '',
      carName3: map['carName3'] ?? '',
      carName4: map['carName4'] ?? '',
      carName5: map['carName5'] ?? '',
      nenshiki1: map['nenshiki1'] ?? '',
      nenshiki2: map['nenshiki2'] ?? '',
      distance1: map['distance1'] ?? '',
      distance2: map['distance2'] ?? '',
      haikiryou1: map['haikiryou1'] ?? '',
      haikiryou2: map['haikiryou2'] ?? '',
      price1: map['price1'] ?? '',
      price2: map['price2'] ?? '',
      inspection: map['inspection'] ?? '',
      repair: map['repair'] ?? '',
      mission: map['mission'] ?? '',
      freeword: map['freeword'] ?? '',
      color: map['color'] ?? '',
      area: map['area'] ?? '',
      pageIndex: map['page'] ?? 0,
      pageSize: map['per_page'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchListModel.fromJson(String source) =>
      SearchListModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SearchListModel(memberNum: $memberNum, callCount: $callCount, makerName: $makerName, makerCode1: $makerCode1, makerCode2: $makerCode2, makerCode3: $makerCode3, makerCode4: $makerCode4, makerCode5: $makerCode5, carName1: $carName1, carName2: $carName2, carName3: $carName3, carName4: $carName4, carName5: $carName5, nenshiki1: $nenshiki1, nenshiki2: $nenshiki2, distance1: $distance1, distance2: $distance2, haikiryou1: $haikiryou1, haikiryou2: $haikiryou2, price1: $price1, price2: $price2, inspection: $inspection, repair: $repair, mission: $mission, freeword: $freeword, color: $color, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchListModel &&
        other.memberNum == memberNum &&
        other.callCount == callCount &&
        other.makerName == makerName &&
        other.makerCode1 == makerCode1 &&
        other.makerCode2 == makerCode2 &&
        other.makerCode3 == makerCode3 &&
        other.makerCode4 == makerCode4 &&
        other.makerCode5 == makerCode5 &&
        other.carName1 == carName1 &&
        other.carName2 == carName2 &&
        other.carName3 == carName3 &&
        other.carName4 == carName4 &&
        other.carName5 == carName5 &&
        other.nenshiki1 == nenshiki1 &&
        other.nenshiki2 == nenshiki2 &&
        other.distance1 == distance1 &&
        other.distance2 == distance2 &&
        other.haikiryou1 == haikiryou1 &&
        other.haikiryou2 == haikiryou2 &&
        other.price1 == price1 &&
        other.price2 == price2 &&
        other.inspection == inspection &&
        other.repair == repair &&
        other.mission == mission &&
        other.freeword == freeword &&
        other.color == color &&
        other.area == area;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        callCount.hashCode ^
        makerName.hashCode ^
        makerCode1.hashCode ^
        makerCode2.hashCode ^
        makerCode3.hashCode ^
        makerCode4.hashCode ^
        makerCode5.hashCode ^
        carName1.hashCode ^
        carName2.hashCode ^
        carName3.hashCode ^
        carName4.hashCode ^
        carName5.hashCode ^
        nenshiki1.hashCode ^
        nenshiki2.hashCode ^
        distance1.hashCode ^
        distance2.hashCode ^
        haikiryou1.hashCode ^
        haikiryou2.hashCode ^
        price1.hashCode ^
        price2.hashCode ^
        inspection.hashCode ^
        repair.hashCode ^
        mission.hashCode ^
        freeword.hashCode ^
        color.hashCode ^
        area.hashCode;
  }
}
