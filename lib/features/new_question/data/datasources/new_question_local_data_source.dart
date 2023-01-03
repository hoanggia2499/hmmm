import '../../../../core/db/boxes.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/util/constants.dart';

abstract class NewQuestionLocalDataSource {
  Future<List<NameBeanHive>> getNameBeanFromHiveDb();
}

class NewQuestionLocalDataSourceImpl extends NewQuestionLocalDataSource {
  @override
  Future<List<NameBeanHive>> getNameBeanFromHiveDb() async {
    var listRaw = await Boxes.instance
        .getBox(Constants.NAME_BEAN_TABLE)
        .then((box) => box.values.toList().cast<NameBeanHive>());
    List<NameBeanHive> list = [];
    list.addAll(listRaw);
    return list;
  }
}
