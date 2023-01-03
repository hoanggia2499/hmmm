import 'package:mirukuru/core/network/json_convert_base.dart';
import 'package:mirukuru/features/search_top/data/models/rikuji_list.dart';

import 'name_list.dart';

class NameModel extends JsonConvert<NameModel> {
  List<NameList> nameList;
  List<RikujiList> rikujiList;

  NameModel({this.nameList = const [], this.rikujiList = const []});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      nameList: (json['nameList'] as List<dynamic>?)
              ?.map((e) => NameList.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rikujiList: (json['rikujiList'] as List<dynamic>?)
              ?.map((e) => RikujiList.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{};
}
