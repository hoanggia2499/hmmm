import 'package:mirukuru/core/network/json_convert_base.dart';

class NameList extends JsonConvert<NameList> {
  int nameKbn;
  int nameCode;
  String name;

  NameList({this.name = '', this.nameCode = 0, this.nameKbn = 0});

  factory NameList.fromJson(Map<String, dynamic> json) {
    return NameList(
      name: json['name'] ?? '',
      nameCode: json['nameCode'] ?? 0,
      nameKbn: json['nameKbn'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nameKbn': nameKbn,
        'nameCode': nameCode,
        'name': name,
      };
}
