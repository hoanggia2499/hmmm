import 'package:mirukuru/core/db/boxes.dart';
import 'package:mirukuru/core/db/item_search_hive.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class FavoriteListLocalDataSource {
  Future<List<ItemSearchModel>> getCarObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<void> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo);
  Future<void> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<void> removeCarObjectList(String tableName, int index);
}

class FavoriteListLocalDataSourceImpl extends FavoriteListLocalDataSource {
  @override
  Future<void> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo) async {
    var box = await Boxes.instance.getBox(tableName);
    final Map<dynamic, dynamic> imageCarMap = box.toMap();
    dynamic desiredKey;
    imageCarMap.forEach((key, value) {
      var questionNoValue = value.corner + value.fullExhNum;
      if (questionNoValue == questionNo) {
        desiredKey = key;
      }
    });

    box.delete(desiredKey);
  }

  @override
  Future<List<ItemSearchModel>> getCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    List<ItemSearchModel> itemSearchModelList = [];
    var hiveObj = await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<ItemSearchHive>());
    hiveObj.forEach((element) {
      var imgUrlValue = HelperFunction.instance
          .getImageUrl(element.fullExhNum, element.corner, pic1Map);

      var obj = ItemSearchModel(
          makerCode: element.makerCode,
          makerName: element.makerName,
          inspection: element.inspection,
          aaCount: element.aaCount,
          carGrade: element.carGrade,
          carLocation: element.carLocation,
          carMileage: element.carMileage,
          carModel: element.carModel,
          carName: element.carName,
          carVolume: element.carVolume,
          corner: element.corner,
          dTPointTotal: element.dT_PointTotal,
          exhNum: element.exhNum,
          fuelName: element.fuelName,
          fullExhNum: element.fullExhNum,
          price: element.price,
          repairflag: element.repairflag,
          shiftName: element.shiftName,
          stars: element.stars,
          sysColorName: element.sysColorName,
          tel: element.tel,
          priceValue: element.priceValue,
          priceValue2: element.priceValue2,
          yen: (element.priceValue == '' && element.priceValue2 == '')
              ? ""
              : "万円",
          imageUrl: imgUrlValue,
          questionNo: element.questionNo);

      itemSearchModelList.add(obj);
    });

    return itemSearchModelList;
  }

  @override
  Future<void> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo) async {
    ItemSearchHive itemSearchHive = ItemSearchHive(
        makerCode: item.makerCode,
        makerName: item.makerName,
        inspection: item.inspection,
        aaCount: item.aaCount,
        carGrade: item.carGrade,
        carLocation: item.carLocation,
        carMileage: item.carMileage,
        carModel: item.carModel,
        carName: item.carName,
        carVolume: item.carVolume,
        corner: item.corner,
        dT_PointTotal: item.dTPointTotal,
        exhNum: item.exhNum,
        fuelName: item.fuelName,
        fullExhNum: item.fullExhNum,
        price: item.price,
        repairflag: item.repairflag,
        shiftName: item.shiftName,
        stars: item.stars,
        sysColorName: item.sysColorName,
        tel: item.tel,
        questionNo: questionNo,
        priceValue: item.priceValue,
        priceValue2: item.priceValue2);
    var box = await Boxes.instance.getBox(tableName);
    await box.add(itemSearchHive);
  }

  @override
  Future<void> removeCarObjectList(String tableName, int index) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.deleteAt(index);
    Logging.log.info("delete car");
  }
}
