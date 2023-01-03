import '../../../../core/db/boxes.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/util/constants.dart';

abstract class SellCarLocalDataSource {
  Future<List<NameBeanHive>> getNameBeanFromHiveDb();
}

class SellCarLocalDataSourceImpl extends SellCarLocalDataSource {
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
