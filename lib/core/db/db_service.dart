import 'dart:io';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/core/db/item_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/db/rikuji_bean_hive.dart';
import 'package:mirukuru/core/db/user_car_list_hive.dart';
import 'package:mirukuru/core/db/search_input_hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

class DbService {
  static DbService instance = DbService._internal();

  factory DbService() {
    return instance;
  }

  DbService._internal();

  Future initHiveDB() async {
    var dir;

    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    }
    var rootPath = Directory(join(dir!.path, "MIRUKURU")).path;
    Hive.init(rootPath);
    Hive.registerAdapter(NameBeanHiveAdapter(), override: true);
    Hive.registerAdapter(RikujiBeanHiveAdapter(), override: true);
    Hive.registerAdapter(CarSearchHiveAdapter(), override: true);
    Hive.registerAdapter(FavoriteHiveAdapter(), override: true);
    Hive.registerAdapter(ItemSearchHiveAdapter(), override: true);
    Hive.registerAdapter(UserCarHiveAdapter(), override: true);
    Hive.registerAdapter(SearchInputHiveAdapter(), override: true);
  }
}
