import 'package:mirukuru/core/db/boxes.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';

abstract class SearchInputLocalDataSource {
  Future<List<CarSearchHive>> getCarListSearchFromHiveDb(String tableName);
  Future<List<NameBeanHive>> getNameBeanFromHiveDb(String tableName);
}

class SearchInputLocalDataSourceImpl extends SearchInputLocalDataSource {
  @override
  Future<List<CarSearchHive>> getCarListSearchFromHiveDb(
      String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<CarSearchHive>());
  }

  @override
  Future<List<NameBeanHive>> getNameBeanFromHiveDb(String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<NameBeanHive>());
  }
}
