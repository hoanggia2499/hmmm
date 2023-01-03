import 'package:mirukuru/core/db/boxes.dart';
import 'package:mirukuru/core/db/item_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class MessageBoardLocalDataSource {
  Future<List<ItemSearchModel>> getFavoriteList(
      String tableName, Map<String, String> pic1Map);
  Future<void> addFavorite(
      ItemSearchModel item, String tableName, String questionNo);
  Future<void> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<String> getColorName(String colorCode);
  Future<List<NameBeanHive>> getNameBeanFromHiveDb(String tableName);
  Future<String> getInsurance(String code);
  Future<String> getSellTime(String code);
}

class MessageBoardLocalDataSourceImpl extends MessageBoardLocalDataSource {
  @override
  Future<void> addFavorite(
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
  Future<List<ItemSearchModel>> getFavoriteList(
      String tableName, Map<String, String> pic1Map) async {
    List<ItemSearchModel> itemSearchModelList = [];
    var hiveObj = await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<ItemSearchHive>());
    hiveObj.forEach((element) {
      var imgUrlValue = HelperFunction.instance
          .getImageUrl(element.fullExhNum, element.corner, pic1Map);
      var priceModel = HelperFunction.instance.getPrice(element.price);
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
          imageUrl: imgUrlValue,
          priceValue: priceModel.price,
          priceValue2: priceModel.price2,
          yen: priceModel.yen,
          questionNo: element.questionNo);
      itemSearchModelList.add(obj);
    });
    return itemSearchModelList;
  }

  @override
  Future<String> getColorName(String colorCode) async {
    var nameList = await getNameBeanFromHiveDb(Constants.NAME_BEAN_TABLE);
    var colorNameBeans = nameList.where((element) =>
        element.nameKbn == Constants.NAME_BEAN_TABLE_COLOR_NAME_CODE &&
        element.nameCode.toString() == colorCode);
    if (colorNameBeans.isNotEmpty) {
      return Future.value(colorNameBeans.first.name ?? "");
    }
    return Future.value("");
  }

  @override
  Future<List<NameBeanHive>> getNameBeanFromHiveDb(String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<NameBeanHive>());
  }

  @override
  Future<String> getInsurance(String code) async {
    var nameList = await getNameBeanFromHiveDb(Constants.NAME_BEAN_TABLE);

    var insureanceBeans = nameList.where((element) =>
        element.nameKbn == Constants.NAME_BEAN_TABLE_INSUREANCE_CODE &&
        element.nameCode.toString() == code);
    if (insureanceBeans.isNotEmpty) {
      return Future.value(insureanceBeans.first.name ?? "");
    }
    return Future.value("");
  }

  @override
  Future<String> getSellTime(String code) async {
    var nameList = await getNameBeanFromHiveDb(Constants.NAME_BEAN_TABLE);

    var sellTimeBeans = nameList.where((element) =>
        element.nameKbn == Constants.NAME_BEAN_TABLE_SELL_TIME_CODE &&
        element.nameCode.toString() == code);
    if (sellTimeBeans.isNotEmpty) {
      return Future.value(sellTimeBeans.first.name ?? "");
    }
    return Future.value("");
  }
}
