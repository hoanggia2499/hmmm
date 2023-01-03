import 'package:mirukuru/core/network/json_convert_base.dart';

class RikujiList extends JsonConvert<RikujiList> {
  int nameKbn;
  String nameCode;
  String prefName;

  RikujiList({this.nameKbn = 0, this.nameCode = '', this.prefName = ''});

  factory RikujiList.fromJson(Map<String, dynamic> json) {
    return RikujiList(
      nameKbn: json['nameKbn'] as int,
      nameCode: json['nameCode'] as String,
      prefName: json['prefName'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nameKbn': nameKbn,
        'nameCode': nameCode,
        'prefName': prefName,
      };
}
