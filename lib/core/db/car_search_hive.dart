import 'package:hive/hive.dart';

part 'car_list_search_hive.g.dart';

@HiveType(typeId: 3)
class CarSearchHive extends HiveObject {
  @HiveField(0)
  String? makerCode;
  @HiveField(1)
  String? makerName;
  @HiveField(2)
  String? asnetCarCode;
  @HiveField(3)
  String? carGroup;

  CarSearchHive(
      {this.asnetCarCode, this.carGroup, this.makerCode, this.makerName});
}
