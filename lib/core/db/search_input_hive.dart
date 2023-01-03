import 'package:hive/hive.dart';

part 'search_input_hive.g.dart';

@HiveType(typeId: 6)
class SearchInputHive extends HiveObject {
  @HiveField(0)
  String memberNum;
  @HiveField(1)
  int callCount;
  @HiveField(2)
  String makerCode1;
  @HiveField(3)
  String makerCode2;
  @HiveField(4)
  String makerCode3;
  @HiveField(5)
  String makerCode4;
  @HiveField(6)
  String makerCode5;
  @HiveField(7)
  String carName1;
  @HiveField(8)
  String carName2;
  @HiveField(9)
  String carName3;
  @HiveField(10)
  String carName4;
  @HiveField(11)
  String carName5;
  @HiveField(12)
  String nenshiki1;
  @HiveField(13)
  String nenshiki2;
  @HiveField(14)
  String distance1;
  @HiveField(15)
  String distance2;
  @HiveField(16)
  String haikiryou1;
  @HiveField(17)
  String haikiryou2;
  @HiveField(18)
  String price1;
  @HiveField(19)
  String price2;
  @HiveField(20)
  String inspection;
  @HiveField(21)
  String repair;
  @HiveField(22)
  String mission;
  @HiveField(23)
  String freeword;
  @HiveField(24)
  String color;
  @HiveField(25)
  String area;
  @HiveField(26)
  String makerName;
  SearchInputHive(
      {required this.memberNum,
      required this.callCount,
      required this.makerCode1,
      required this.makerCode2,
      required this.makerCode3,
      required this.makerCode4,
      required this.makerCode5,
      required this.carName1,
      required this.carName2,
      required this.carName3,
      required this.carName4,
      required this.carName5,
      required this.nenshiki1,
      required this.nenshiki2,
      required this.distance1,
      required this.distance2,
      required this.haikiryou1,
      required this.haikiryou2,
      required this.price1,
      required this.price2,
      required this.inspection,
      required this.repair,
      required this.mission,
      required this.freeword,
      required this.color,
      required this.area,
      required this.makerName});
}
