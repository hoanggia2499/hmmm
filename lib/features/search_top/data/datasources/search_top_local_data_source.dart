import '../../../../core/db/boxes.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/db/rikuji_bean_hive.dart';

abstract class SearchTopLocalDataSource {
  Future<void> addNameBean(NameBeanHive nameBeanHive, String tableName);
  Future<void> deleteDropDownList(String tableName);
  Future<void> addAllNameBean(
      List<NameBeanHive> nameBeanHiveList, String tableName);
  Future<List<NameBeanHive>> getNameBean(String tableName);
  Future<void> addRikujiBean(RikujiBeanHive rikujiBeanHive, String tableName);
  Future<void> addAllRikujiBean(
      List<RikujiBeanHive> rikujiBeanHiveList, String tableName);
  Future<List<RikujiBeanHive>> getRikujiBean(String tableName);
}

class SearchTopLocalDataSourceImpl implements SearchTopLocalDataSource {
  @override
  Future<void> addNameBean(NameBeanHive nameBeanHive, String tableName) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.add(nameBeanHive);
  }

  @override
  Future<void> addAllNameBean(
      List<NameBeanHive> nameBeanHiveList, String tableName) async {
    for (NameBeanHive nameBeanHive in nameBeanHiveList) {
      NameBeanHive nameBean = NameBeanHive(
          nameKbn: nameBeanHive.nameKbn,
          nameCode: nameBeanHive.nameCode,
          name: nameBeanHive.name);
      await addNameBean(nameBean, tableName);
    }
  }

  @override
  Future<void> addRikujiBean(
      RikujiBeanHive rikujiBeanHive, String tableName) async {
    var box = await Boxes.instance.getBox(tableName);
    await box.add(rikujiBeanHive);
  }

  @override
  Future<void> addAllRikujiBean(
      List<RikujiBeanHive> rikujiBeanHiveList, String tableName) async {
    for (RikujiBeanHive rikujiBeanHive in rikujiBeanHiveList) {
      RikujiBeanHive rikujiBean = RikujiBeanHive(
          nameKbn: rikujiBeanHive.nameKbn,
          nameCode: rikujiBeanHive.nameCode,
          prefName: rikujiBeanHive.prefName);
      await addRikujiBean(rikujiBean, tableName);
    }
  }

  @override
  Future<void> deleteDropDownList(String tableName) async {
    await Boxes.instance.getBox(tableName).then((value) => value.clear());
  }

  @override
  Future<List<NameBeanHive>> getNameBean(String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<NameBeanHive>());
  }

  @override
  Future<List<RikujiBeanHive>> getRikujiBean(String tableName) async {
    return await Boxes.instance
        .getBox(tableName)
        .then((box) => box.values.toList().cast<RikujiBeanHive>());
  }
}
