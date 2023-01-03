import 'package:mirukuru/core/network/json_convert_base.dart';

import '../../../car_regist/data/model/post_own_car_request.dart';
import 'user_car_name_model.dart';

class UserCarModel extends JsonConvert<UserCarModel> {
  String? memberNum;
  String? userNum;
  String? userCarNum;
  String? carGrade;
  String? plateNo1;
  String? plateNo2;
  String? plateNo3;
  String? plateNo4;
  String? makerCode;
  String? carCode;
  String? nHokenInc;
  String? carModel;
  String? sellTime;
  String? inspectionDate;
  String? nHokenEndDay;
  String? platformNum;
  String? colorName;
  UserCarNameModel? userCarNameModel;
  int? mileage;

  UserCarModel({
    this.memberNum,
    this.userNum,
    this.userCarNum,
    this.carGrade,
    this.plateNo1,
    this.plateNo2,
    this.plateNo3,
    this.plateNo4,
    this.makerCode,
    this.carCode,
    this.nHokenInc,
    this.carModel,
    this.sellTime,
    this.inspectionDate,
    this.nHokenEndDay,
    this.platformNum,
    this.colorName,
    this.userCarNameModel,
    this.mileage,
  });

  factory UserCarModel.convertForm(PostOwnCarRequestModel request) {
    return UserCarModel(
      memberNum: request.memberNum,
      userNum: request.userNum.toString(),
      userCarNum:
          request.userCarNum != null ? request.userCarNum.toString() : null,
      carGrade: request.carGrade,
      plateNo1: request.plateNo1 != null ? request.plateNo1.toString() : null,
      plateNo2: request.plateNo2 != null ? request.plateNo2.toString() : null,
      plateNo3: request.plateNo3,
      plateNo4: request.plateNo4 != null ? request.plateNo4.toString() : null,
      makerCode: request.makerCode,
      carCode: request.carCode,
      nHokenInc:
          request.nHokenInc != null ? request.nHokenInc.toString() : null,
      carModel: request.carModel,
      sellTime: request.sellTime,
      inspectionDate: request.inspectionDate,
      nHokenEndDay: request.nHokenEndDay,
      platformNum: request.platformNum,
      colorName:
          request.bodyColor != null ? request.bodyColor.toString() : null,
      userCarNameModel: request.userCarNameModel,
      mileage: request.mileage,
    );
  }

  UserCarModel.fromJson(Map<String, dynamic> json) {
    if (json["memberNum"] is String) this.memberNum = json["memberNum"];
    if (json["userNum"] is String) this.userNum = json["userNum"];
    if (json["userCarNum"] is String) this.userCarNum = json["userCarNum"];
    this.carGrade = json["carGrade"];
    if (json["plateNo1"] is String) this.plateNo1 = json["plateNo1"];
    this.plateNo2 = json["plateNo2"];
    this.plateNo3 = json["plateNo3"];
    this.plateNo4 = json["plateNo4"];
    if (json["makerCode"] is String) this.makerCode = json["makerCode"];
    if (json["carCode"] is String) this.carCode = json["carCode"];
    if (json["nHokenInc"] is String) this.nHokenInc = json["nHokenInc"];
    this.carModel = json["carModel"];
    if (json["sellTime"] is String) this.sellTime = json["sellTime"];
    this.inspectionDate = json["inspectionDate"];
    this.nHokenEndDay = json["nHokenEndDay"];
    if (json["platformNum"] is String) this.platformNum = json["platformNum"];
    if (json["colorName"] is String) this.colorName = json["colorName"];
    if (json["mileage"] is int) this.mileage = json["mileage"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["memberNum"] = this.memberNum;
    data["userNum"] = this.userNum;
    data["userCarNum"] = this.userCarNum;
    data["carGrade"] = this.carGrade;
    data["plateNo1"] = this.plateNo1;
    data["plateNo2"] = this.plateNo2;
    data["plateNo3"] = this.plateNo3;
    data["plateNo4"] = this.plateNo4;
    data["makerCode"] = this.makerCode;
    data["carCode"] = this.carCode;
    data["nHokenInc"] = this.nHokenInc;
    data["carModel"] = this.carModel;
    data["sellTime"] = this.sellTime;
    data["inspectionDate"] = this.inspectionDate;
    data["nHokenEndDay"] = this.nHokenEndDay;
    data["platformNum"] = this.platformNum;
    data["colorName"] = this.colorName;
    data["mileage"] = this.mileage;
    return data;
  }

  static List<UserCarModel> fromListMap(List<Map<String, dynamic>> listMap) {
    if (listMap.isNotEmpty) {
      return listMap.map((e) => UserCarModel.fromMap(e)).toList();
    }
    return List.empty();
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': this.memberNum,
      'userNum': this.userNum,
      'userCarNum': this.userCarNum,
      'carGrade': this.carGrade,
      'plateNo1': this.plateNo1,
      'plateNo2': this.plateNo2,
      'plateNo3': this.plateNo3,
      'plateNo4': this.plateNo4,
      'makerCode': this.makerCode,
      'carCode': this.carCode,
      'nhokenInc': this.nHokenInc,
      'carModel': this.carModel,
      'sellTime': this.sellTime,
      'inspectionDate': this.inspectionDate,
      'nhokenEndDay': this.nHokenEndDay,
      'platformNum': this.platformNum,
      'colorName': this.colorName,
      'userCarNameModel': this.userCarNameModel,
      'mileage': this.mileage
    };
  }

  factory UserCarModel.fromMap(Map<String, dynamic> map) {
    return UserCarModel(
        memberNum: map['memberNum'],
        userNum: map['userNum'],
        userCarNum: map['userCarNum'],
        carGrade: map['carGrade'],
        plateNo1: map['plateNo1'],
        plateNo2: map['plateNo2'],
        plateNo3: map['plateNo3'],
        plateNo4: map['plateNo4'],
        makerCode: map['makerCode'],
        carCode: map['carCode'],
        nHokenInc: map['nHokenInc'],
        carModel: map['carModel'],
        sellTime: map['sellTime'],
        inspectionDate: map['inspectionDate'],
        nHokenEndDay: map['nHokenEndDay'],
        platformNum: map['platformNum'],
        colorName: map['colorName'],
        mileage: map['mileage'],
        userCarNameModel: UserCarNameModel(
            makerCode: map['makerCode'],
            userCarNum: map['userCarNum'],
            asnetCarCode: map['carCode']));
  }
}
