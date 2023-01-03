import 'package:mirukuru/core/network/json_convert_base.dart';

class CarNameResponseV2 extends JsonConvert<CarNameResponseV2> {
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
  String? colorName;

  CarNameResponseV2(
      {this.memberNum,
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
      this.colorName});

  CarNameResponseV2.fromJson(Map<String, dynamic> json) {
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
    if (json["colorName"] is String) this.colorName = json["colorName"];
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
    data["colorName"] = this.colorName;
    return data;
  }

  factory CarNameResponseV2.fromMap(Map<String, dynamic> map) {
    return CarNameResponseV2(
      memberNum: map['memberNum'],
      userCarNum: map['userCarNum'],
      carGrade: map['carGrade'],
      plateNo1: map['plateNo1'],
      plateNo2: map['plateNo2'],
      plateNo3: map['plateNo3'],
      plateNo4: map['plateNo4'],
      makerCode: map['makerCode'],
      carCode: map['carCode'],
      nHokenInc: map['nHokenInc'],
      nHokenEndDay: map['nHokenEndDay'],
      carModel: map['carModel'],
      sellTime: map['sellTime'],
      inspectionDate: map['inspectionDate'],
      colorName: map['colorName'],
    );
  }

  static List<CarNameResponseV2> fromListMap(
      List<Map<String, dynamic>> listMap) {
    if (listMap.isNotEmpty) {
      return listMap.map((e) => CarNameResponseV2.fromMap(e)).toList();
    }
    return List.empty();
  }
}
