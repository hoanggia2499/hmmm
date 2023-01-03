import 'package:mirukuru/core/db/item_search_hive.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_response.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_model.dart';

class ItemSearchModel {
  String carName;
  String makerName;
  String makerCode;
  String carGrade;
  String corner;
  String fullExhNum;
  String inspection;
  String sysColorName;
  String fuelName;
  String carLocation;
  String shiftName;
  String dTPointTotal;
  int aaCount;
  int exhNum;
  int carVolume;
  int carMileage;
  int carModel;

  int repairflag;
  String tel;
  int price;
  int stars;

  String priceValue;
  String priceValue2;
  String yen;
  String imageUrl;
  String questionNo;

  ItemSearchModel(
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
      this.dTPointTotal = '',
      this.exhNum = 0,
      this.fuelName = '',
      this.fullExhNum = '',
      this.price = 0,
      this.repairflag = 0,
      this.shiftName = '',
      this.stars = 0,
      this.sysColorName = '',
      this.tel = '',
      this.imageUrl = '',
      this.yen = '',
      this.priceValue = '',
      this.priceValue2 = '',
      this.questionNo = ''});

  factory ItemSearchModel.fromJson(Map<String, dynamic> json) {
    return ItemSearchModel(
      carName: json['carName'] ?? '',
      makerName: json['makerName'] ?? '',
      makerCode: json['makerCode'] ?? '',
      carGrade: json['carGrade'] ?? '',
      corner: json['corner'] ?? '',
      fullExhNum: json['fullExhNum'] ?? '',
      inspection: json['inspection'] ?? '',
      sysColorName: json['sysColorName'] ?? '',
      fuelName: json['fuelName'] ?? '',
      carLocation: json['carLocation'] ?? '',
      shiftName: json['shiftName'] ?? '',
      dTPointTotal: json['dT_PointTotal'] ?? '',
      aaCount: json['aaCount'] ?? '',
      exhNum: json['exhNum'] ?? '',
      carVolume: json['carVolume'] ?? '',
      carMileage: json['carMileage'] ?? '',
      carModel: json['carModel'] ?? '',
      questionNo: json['questionNo'] ?? '',
      price: json['price'] ?? '',
      repairflag: json['repairflag'] ?? '',
      tel: json['tel'] ?? '',
      stars: json['stars'] ?? '',
    );
  }

  factory ItemSearchModel.convertFrom(
      AsnetCarDetailModel? asnetCarDetailModel) {
    if (asnetCarDetailModel == null) {
      return ItemSearchModel();
    }
    var priceModel =
        HelperFunction.instance.getPrice(int.parse(asnetCarDetailModel.price));

    var imgUrl = HelperFunction.instance.getFrontImageUrl(
        asnetCarDetailModel.fullExhNum, asnetCarDetailModel.corner);

    return ItemSearchModel(
        carName: asnetCarDetailModel.carName,
        makerName: asnetCarDetailModel.makerName,
        makerCode: "",
        carGrade: asnetCarDetailModel.carGrade,
        corner: asnetCarDetailModel.corner,
        fullExhNum: asnetCarDetailModel.fullExhNum,
        inspection: asnetCarDetailModel.inspection,
        sysColorName: asnetCarDetailModel.sysColorName,
        fuelName: asnetCarDetailModel.fuelName,
        carLocation: asnetCarDetailModel.carLocation,
        shiftName: asnetCarDetailModel.shiftName,
        dTPointTotal: asnetCarDetailModel.dtPointTotal,
        aaCount: asnetCarDetailModel.aaCount,
        exhNum: asnetCarDetailModel.exhNum,
        carVolume: asnetCarDetailModel.carVolume,
        carMileage: asnetCarDetailModel.carMileage,
        carModel: asnetCarDetailModel.carModel,
        questionNo:
            "${asnetCarDetailModel.corner}${asnetCarDetailModel.fullExhNum}",
        priceValue: priceModel.price,
        priceValue2: priceModel.price2,
        yen: priceModel.yen,
        imageUrl: imgUrl);
  }

  factory ItemSearchModel.convertFromCarSP(CarSPResponseModel? model) {
    if (model == null) {
      return ItemSearchModel();
    }
    /*  var priceModel =
        HelperFunction.instance.getPrice(int.parse(model.price ?? ""));

    var imgUrl = HelperFunction.instance
        .getFrontImageUrl(model.fullExhNum ?? "", model.corner ?? "");
 */
    return ItemSearchModel(
        carName: model.carName ?? "",
        makerName: model.makerName ?? "",
        makerCode: "",
        carGrade: model.carGrade ?? "",
        corner: model.corner ?? "",
        fullExhNum: model.fullExhNum ?? "",
        inspection: model.inspection ?? "",
        sysColorName: model.sysColorName ?? "",
        fuelName: model.fuelName ?? "",
        carLocation: model.carLocation ?? "",
        shiftName: model.shiftName ?? "",
        dTPointTotal: model.dtPointTotal ?? "",
        aaCount: model.aaCount ?? 0,
        exhNum: model.exhNum ?? 0,
        carVolume: model.carVolume ?? 0,
        carMileage: model.carMileage ?? 0,
        carModel: model.carModel ?? 0,
        questionNo: "${model.corner}${model.fullExhNum}");
  }
  factory ItemSearchModel.mapFromHiveObject(ItemSearchHive hiveObj) {
    var priceModel = HelperFunction.instance.getPrice(hiveObj.price);

    var imgUrl = HelperFunction.instance
        .getFrontImageUrl(hiveObj.fullExhNum, hiveObj.corner);

    return ItemSearchModel(
        carName: hiveObj.carName,
        makerName: hiveObj.makerName,
        makerCode: hiveObj.makerCode,
        carGrade: hiveObj.carGrade,
        corner: hiveObj.corner,
        fullExhNum: hiveObj.fullExhNum,
        inspection: hiveObj.inspection,
        sysColorName: hiveObj.sysColorName,
        fuelName: hiveObj.fuelName,
        carLocation: hiveObj.carLocation,
        shiftName: hiveObj.shiftName,
        dTPointTotal: hiveObj.dT_PointTotal,
        aaCount: hiveObj.aaCount,
        exhNum: hiveObj.exhNum,
        carVolume: hiveObj.carVolume,
        carMileage: hiveObj.carMileage,
        carModel: hiveObj.carModel,
        questionNo: hiveObj.questionNo,
        priceValue: priceModel.price,
        priceValue2: priceModel.price2,
        yen: priceModel.yen,
        imageUrl: imgUrl);
  }
}
