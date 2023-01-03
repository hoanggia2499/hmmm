import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/util/constants.dart';
import '../../../my_page/data/models/my_page_user_car_model.dart';
import '../../../my_page/data/models/user_car_name_model.dart';

class PostOwnCarRequestModel extends Equatable {
  final String? memberNum;
  final int? userNum;
  final int? userCarNum;
  final int? plateNo1;
  final int? plateNo2;
  final String? plateNo3;
  final int? plateNo4;
  final String? makerCode;
  final String? carGrade;
  final String? carCode;
  final String? carModel;
  final String? platformNum;
  final int? bodyColor;
  final int? mileage;
  final String? inspectionDate;
  final int? inspectionFlag;
  final String? sellTime;
  final String? buyTime;
  final int? nHokenKbn;
  final int? nHokenInc;
  final String? nHokenEndDay;
  List<XFile?>? files;

  final UserCarNameModel? userCarNameModel;
  PostOwnCarRequestModel({
    this.memberNum,
    this.userNum,
    this.userCarNum,
    this.plateNo1,
    this.plateNo2,
    this.plateNo3,
    this.plateNo4,
    this.makerCode,
    this.carGrade,
    this.carCode,
    this.carModel,
    this.platformNum,
    this.bodyColor,
    this.mileage,
    this.inspectionDate,
    this.inspectionFlag,
    this.sellTime,
    this.buyTime,
    this.nHokenKbn,
    this.nHokenInc,
    this.nHokenEndDay,
    this.files,
    this.userCarNameModel,
  });

  factory PostOwnCarRequestModel.convertForm(UserCarModel request) {
    return PostOwnCarRequestModel(
      memberNum: request.memberNum,
      userNum: int.parse(request.userNum ?? "0"),
      userCarNum: int.parse(request.userCarNum ?? "0"),
      plateNo1: request.plateNo1 != null
          ? int.parse(request.plateNo1 ?? "0")
          : 4111, // check app native
      plateNo2:
          request.plateNo2 != null ? int.parse(request.plateNo2 ?? "0") : null,
      plateNo3: request.plateNo3,
      plateNo4:
          request.plateNo4 != null ? int.parse(request.plateNo4 ?? "0") : null,
      makerCode: request.makerCode,
      carGrade: request.carGrade,
      carCode: request.carCode,
      carModel: request.carModel,
      platformNum: request.platformNum,
      bodyColor: int.parse(request.colorName ?? "0"),
      mileage: request.mileage,
      inspectionDate: request.inspectionDate != null
          ? DateFormat("yyyy/MM/dd HH:mm:ss")
              .parse(
                request.inspectionDate!,
              )
              .toString()
          : null,
      // inspectionFlag: request.inspectionFlag ,
      sellTime: request.sellTime,
      // buyTime: request.buyTime ,
      // nHokenKbn: request.nHokenKbn ,
      nHokenInc: int.parse(request.nHokenInc ?? "0"),
      nHokenEndDay: request.nHokenEndDay,
    );
  }

  static String getColorName(String? colorCode, List<NameBeanHive> nameList) {
    var colorNameBeans = nameList.firstWhere(
        (element) =>
            element.nameKbn == Constants.NAME_BEAN_TABLE_COLOR_NAME_CODE &&
            element.nameCode.toString() == colorCode,
        orElse: () => NameBeanHive(name: ""));
    return colorNameBeans.name ?? "";
  }

  static String getSellTime(String? code, List<NameBeanHive> nameList) {
    var sellTimeBeans = nameList.firstWhere(
        (element) =>
            element.nameKbn == Constants.NAME_BEAN_TABLE_SELL_TIME_CODE &&
            element.nameCode.toString() == code,
        orElse: () => NameBeanHive(name: ""));

    return sellTimeBeans.name ?? "";
  }

  static String getInsurance(String? code, List<NameBeanHive> nameList) {
    var insureanceBeans = nameList.firstWhere(
        (element) =>
            element.nameKbn == Constants.NAME_BEAN_TABLE_INSUREANCE_CODE &&
            element.nameCode.toString() == code,
        orElse: () => NameBeanHive(name: ""));

    return insureanceBeans.name ?? "";
  }

  PostOwnCarRequestModel copyWith({
    String? memberNum,
    int? userNum,
    int? userCarNum,
    int? plateNo1,
    int? plateNo2,
    String? plateNo3,
    int? plateNo4,
    String? makerCode,
    String? carGrade,
    String? carCode,
    String? carModel,
    String? platformNum,
    int? bodyColor,
    int? mileage,
    DateTime? inspectionDate,
    int? inspectionFlag,
    String? sellTime,
    String? buyTime,
    int? nHokenKbn,
    int? nHokenInc,
    String? nHokenEndDay,
    List<XFile?>? files,
  }) {
    return PostOwnCarRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
      plateNo1: plateNo1 ?? this.plateNo1,
      plateNo2: plateNo2 ?? this.plateNo2,
      plateNo3: plateNo3 ?? this.plateNo3,
      plateNo4: plateNo4 ?? this.plateNo4,
      makerCode: makerCode ?? this.makerCode,
      carGrade: carGrade ?? this.carGrade,
      carCode: carCode ?? this.carCode,
      carModel: carModel != "0000" ? carModel ?? this.carModel : null,
      platformNum: platformNum ?? this.platformNum,
      bodyColor: bodyColor ?? this.bodyColor,
      mileage: mileage ?? this.mileage,
      inspectionDate: inspectionDate != DateTime.utc(0000)
          ? inspectionDate?.toIso8601String() ?? this.inspectionDate
          : null,
      inspectionFlag: inspectionFlag ?? this.inspectionFlag,
      sellTime: sellTime ?? this.sellTime,
      buyTime: buyTime ?? this.buyTime,
      nHokenKbn: nHokenKbn ?? this.nHokenKbn,
      nHokenInc: nHokenInc ?? this.nHokenInc,
      nHokenEndDay:
          nHokenEndDay != "0000" ? nHokenEndDay ?? this.nHokenEndDay : null,
      files: files ?? this.files,
    );
  }

  @override
  List<Object?> get props => [
        memberNum,
        userNum,
        userCarNum,
        plateNo1,
        plateNo2,
        plateNo3,
        plateNo4,
        makerCode,
        carGrade,
        carCode,
        carModel,
        platformNum,
        bodyColor,
        mileage,
        inspectionDate,
        inspectionFlag,
        sellTime,
        buyTime,
        nHokenKbn,
        nHokenInc,
        nHokenEndDay,
        files,
      ];
}
