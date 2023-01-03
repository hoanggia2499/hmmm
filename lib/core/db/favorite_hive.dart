import 'package:hive/hive.dart';

part 'favorite_hive.g.dart';

@HiveType(typeId: 4)
class FavoriteHive extends HiveObject {
  @HiveField(0)
  String? questionNo;

  FavoriteHive({this.questionNo});
}
