import 'dart:convert';

import 'package:mirukuru/core/network/json_convert_base.dart';

class InformListResponseModel extends JsonConvert<InformListResponseModel> {
  String? title;
  String? info;
  String? sendDate;
  String? confirmDate;
  String? picFile;
  int? sendNum;
  String? pdfFile;
  String? carSPNo1;
  String? carSPNo2;
  String? carSPNo3;
  String? carSPNo4;
  String? carSPNo5;
  int? logoffFlag;

  InformListResponseModel({
    this.title,
    this.info,
    this.sendDate,
    this.confirmDate,
    this.picFile,
    this.sendNum,
    this.pdfFile,
    this.carSPNo1,
    this.carSPNo2,
    this.carSPNo3,
    this.carSPNo4,
    this.carSPNo5,
    this.logoffFlag,
  });

  String toJson() => json.encode(toMap());

  factory InformListResponseModel.fromJson(Map<String, dynamic> map) {
    return InformListResponseModel(
      title: map['title'],
      info: map['info'],
      sendDate: map['sendDate'],
      confirmDate: map['confirmDate'],
      picFile: map['picFile'],
      sendNum: map['sendNum'],
      pdfFile: map['pdfFile'],
      carSPNo1: map['carSPNo1'],
      carSPNo2: map['carSPNo2'],
      carSPNo3: map['carSPNo3'],
      carSPNo4: map['carSPNo4'],
      carSPNo5: map['carSPNo5'],
      logoffFlag: map['logoffFlag'],
    );
  }

  InformListResponseModel copyWith({
    String? title,
    String? info,
    String? sendDate,
    String? confirmDate,
    String? picFile,
    int? sendNum,
    String? pdfFile,
    String? carSPNo1,
    String? carSPNo2,
    String? carSPNo3,
    String? carSPNo4,
    String? carSPNo5,
    int? logoffFlag,
  }) {
    return InformListResponseModel(
      title: title ?? this.title,
      info: info ?? this.info,
      sendDate: sendDate ?? this.sendDate,
      confirmDate: confirmDate ?? this.confirmDate,
      picFile: picFile ?? this.picFile,
      sendNum: sendNum ?? this.sendNum,
      pdfFile: pdfFile ?? this.pdfFile,
      carSPNo1: carSPNo1 ?? this.carSPNo1,
      carSPNo2: carSPNo2 ?? this.carSPNo2,
      carSPNo3: carSPNo3 ?? this.carSPNo3,
      carSPNo4: carSPNo4 ?? this.carSPNo4,
      carSPNo5: carSPNo5 ?? this.carSPNo5,
      logoffFlag: logoffFlag ?? this.logoffFlag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'info': info,
      'sendDate': sendDate,
      'confirmDate': confirmDate,
      'picFile': picFile,
      'sendNum': sendNum,
      'pdfFile': pdfFile,
      'carSPNo1': carSPNo1,
      'carSPNo2': carSPNo2,
      'carSPNo3': carSPNo3,
      'carSPNo4': carSPNo4,
      'carSPNo5': carSPNo5,
      'logoffFlag': logoffFlag,
    };
  }

  factory InformListResponseModel.fromMap(Map<String, dynamic> map) {
    return InformListResponseModel(
      title: map['title'] ?? '',
      info: map['info'] ?? '',
      sendDate: map['sendDate'] ?? '',
      confirmDate: map['confirmDate'] ?? '',
      picFile: map['picFile'] ?? '',
      sendNum: map['sendNum'] ?? '',
      pdfFile: map['pdfFile'] ?? '',
      carSPNo1: map['carSPNo1'] ?? '',
      carSPNo2: map['carSPNo2'] ?? '',
      carSPNo3: map['carSPNo3'] ?? '',
      carSPNo4: map['carSPNo4'] ?? '',
      carSPNo5: map['carSPNo5'] ?? '',
      logoffFlag: map['logoffFlag'] ?? '',
    );
  }

  @override
  String toString() {
    return 'InformListResponseModel(title: $title, info: $info, sendDate: $sendDate, confirmDate: $confirmDate, picFile: $picFile, sendNum: $sendNum, pdfFile: $pdfFile, carSPNo1: $carSPNo1, carSPNo2: $carSPNo2, carSPNo3: $carSPNo3, carSPNo4: $carSPNo4, carSPNo5: $carSPNo5, logoffFlag: $logoffFlag)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InformListResponseModel &&
        other.title == title &&
        other.info == info &&
        other.sendDate == sendDate &&
        other.confirmDate == confirmDate &&
        other.picFile == picFile &&
        other.sendNum == sendNum &&
        other.pdfFile == pdfFile &&
        other.carSPNo1 == carSPNo1 &&
        other.carSPNo2 == carSPNo2 &&
        other.carSPNo3 == carSPNo3 &&
        other.carSPNo4 == carSPNo4 &&
        other.carSPNo5 == carSPNo5 &&
        other.logoffFlag == logoffFlag;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        info.hashCode ^
        sendDate.hashCode ^
        confirmDate.hashCode ^
        picFile.hashCode ^
        sendNum.hashCode ^
        pdfFile.hashCode ^
        carSPNo1.hashCode ^
        carSPNo2.hashCode ^
        carSPNo3.hashCode ^
        carSPNo4.hashCode ^
        carSPNo5.hashCode ^
        logoffFlag.hashCode;
  }
}
