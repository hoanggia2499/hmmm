import 'package:mirukuru/core/db/boxes.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';

abstract class CarListLocalDataSource {
  Future<void> deleteCarListSearch(String tableName);
  Future<void> addAllCarListSearchToHiveDb(
      List<CarSearchHive> carSearchList, String tableName);
  Future<void> addCarListSearch(CarSearchHive carSearchHive, String tableName);
}

class CarListLocalDataSourceImpl implements CarListLocalDataSource {
  @override
  Future<void> deleteCarListSearch(String tableName) async {
    await Boxes.instance.getBox(tableName).then((value) => value.clear());
  }

  @override
  Future<void> addAllCarListSearchToHiveDb(
      List<CarSearchHive> carSearchList, String tableName) async {
    /*  for (CarSearchHive carSearch in carSearchList) {
      CarSearchHive carSearchHive = CarSearchHive(
          asnetCarCode: carSearch.asnetCarCode,
          carGroup: carSearch.carGroup,
          makerCode: carSearch.makerCode,
          makerName: carSearch.makerName);
      await addCarListSearch(carSearchHive, tableName);
    } */
    var box = await Boxes.instance.getBox(tableName);
    await box.addAll(carSearchList);
  }

  @override
  Future<void> addCarListSearch(
      CarSearchHive carSearchHive, String tableName) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.add(carSearchHive);
  }
}
