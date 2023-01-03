import 'package:mirukuru/core/util/core_util.dart';
import '../../../../core/db/boxes.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/db/rikuji_bean_hive.dart';
import '../../../../core/db/user_car_list_hive.dart';
import '../model/local_data_model.dart';

abstract class CarRegisLocalDataSource {
  Future<List<RIKUJIModel>> getListRIKUJI();
  Future<List<NameBeanHive>> getNameBeanFromHiveDb();
  Future<void> deleteUserCarFromListHiveDb(String tableName, String userCarNum);
}

class CarRegisLocalDataSourceImpl extends CarRegisLocalDataSource {
  @override
  Future<List<RIKUJIModel>> getListRIKUJI() async {
    var listRaw = await Boxes.instance
        .getBox(Constants.RIKUJI_BEAN_TABLE)
        .then((box) => box.values.toList().cast<RikujiBeanHive>());

    List<RIKUJIModel> list = [];
    list.add(RIKUJIModel('指定なし', 0));

    list.addAll(listRaw
        .map((e) => RIKUJIModel(e.nameCode ?? '指定なし', e.nameKbn ?? 0))
        .toList());

    return list;
  }

  @override
  Future<void> deleteUserCarFromListHiveDb(
      String tableName, String userCarNum) async {
    final box = await Boxes.instance.getBox(Constants.USER_CAR_TABLE);
    final index = box.values
        .toList()
        .cast<UserCarHive>()
        .indexWhere((element) => element.userCarNum == userCarNum);
    if (index == -1) {
      return Logging.log.warn("cannot delete at index");
    } else {
      return await Boxes.instance
          .getBox(tableName)
          .then((box) => box.deleteAt(index));
    }
  }

  @override
  Future<List<NameBeanHive>> getNameBeanFromHiveDb() async {
    var listRaw = await Boxes.instance
        .getBox(Constants.NAME_BEAN_TABLE)
        .then((box) => box.values.toList().cast<NameBeanHive>());
    List<NameBeanHive> list = [];
    list.add(NameBeanHive(name: '指定なし', nameKbn: 0));
    list.addAll(listRaw);
    return list;
  }
}
