import 'package:mirukuru/core/db/boxes.dart';
import 'package:mirukuru/core/db/item_search_hive.dart';
import 'package:mirukuru/core/db/search_input_hive.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<ItemSearchModel>> getItemHistoryList();
  Future<void> addItemHistory(ItemSearchModel item);
  Future<List<SearchListModel>> getSearchInputList();
  Future<void> addSearchInputHistory(SearchListModel item);
  Future<List<ItemSearchModel>> getCarObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<void> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo);
  Future<void> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<List<SearchListModel>> getSearchHistoryObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<void> removeCarObjectList(
      ItemSearchModel item, String tableName, String questionNo, int index);
}

class HistoryLocalDataSourceImpl extends HistoryLocalDataSource {
  @override
  Future<void> addItemHistory(ItemSearchModel item) async {
    var box = await Boxes.instance.getBox(Constants.ITEM_SEARCH_BEAN_TABLE);
    if (box.length >= Constants.ITEM_SEARCH_BEAN_TABLE_MAX_LEN) {
      box.deleteAt(box.length - 1);
    }
    await box.add(item);
  }

  @override
  Future<void> addSearchInputHistory(SearchListModel item) async {
    var box = await Boxes.instance.getBox(Constants.SEARCH_INPUT_BEAN_TABLE);
    if (box.length >= Constants.SEARCH_INPUT_BEAN_TABLE_MAX_LEN) {
      box.deleteAt(box.length - 1);
    }
    await box.add(item);
  }

  @override
  Future<List<ItemSearchModel>> getItemHistoryList() async {
    var itemSearchHiveList = await Boxes.instance
        .getBox(Constants.ITEM_SEARCH_BEAN_TABLE)
        .then((box) => box.values.toList().cast<ItemSearchHive>());

    return itemSearchHiveList
        .map((e) => ItemSearchModel.mapFromHiveObject(e))
        .toList();
  }

  @override
  Future<List<SearchListModel>> getSearchInputList() async {
    var searchListHive = await Boxes.instance
        .getBox(Constants.SEARCH_INPUT_BEAN_TABLE)
        .then((box) => box.values.toList().cast<SearchInputHive>());

    return searchListHive
        .map((e) => SearchListModel.mapFromHiveObject(e))
        .toList();
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
  Future<List<ItemSearchModel>> getCarObjectList(
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
          priceValue: element.priceValue,
          priceValue2: element.priceValue2,
          imageUrl: imgUrlValue,
          yen: priceModel.yen,
          questionNo: element.questionNo);

      itemSearchModelList.add(obj);
    });

    return itemSearchModelList;
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
  Future<List<SearchListModel>> getSearchHistoryObjectList(
      String tableName, Map<String, String> pic1Map) async {
    List<SearchListModel> searchListModelList = [];
    var hiveObj = await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<SearchInputHive>());
    hiveObj.forEach((element) {
      var obj = SearchListModel(
          memberNum: element.memberNum,
          callCount: element.callCount,
          makerCode1: element.makerCode1,
          makerCode2: element.makerCode2,
          makerCode3: element.makerCode3,
          makerCode4: element.makerCode4,
          makerCode5: element.makerCode5,
          carName1: element.carName1,
          carName2: element.carName2,
          carName3: element.carName3,
          carName4: element.carName4,
          carName5: element.carName5,
          nenshiki1: element.nenshiki1,
          nenshiki2: element.nenshiki2,
          distance1: element.distance1,
          distance2: element.distance2,
          haikiryou1: element.haikiryou1,
          haikiryou2: element.haikiryou2,
          price1: element.price1,
          price2: element.price2,
          inspection: element.inspection,
          mission: element.mission,
          freeword: element.freeword,
          color: element.color,
          repair: element.repair,
          area: element.area);

      searchListModelList.add(obj);
    });

    return searchListModelList;
  }

  @override
  Future<void> removeCarObjectList(ItemSearchModel item, String tableName,
      String questionNo, int index) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.deleteAt(index);
    Logging.log.info("delete car");
  }
}
