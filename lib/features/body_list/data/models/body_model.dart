import 'package:mirukuru/core/network/json_convert_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'body_model.g.dart';

@JsonSerializable()
class BodyModel extends JsonConvert<BodyModel> {
  String makerCode;
  String makerName;
  String carGroup;
  int asnetCarCode;
  int numOfCarASOne;

  BodyModel(
      {this.makerName = '',
      this.makerCode = '',
      this.carGroup = '',
      this.asnetCarCode = 0,
      this.numOfCarASOne = 0});

  factory BodyModel.fromJson(Map<String, dynamic> json) =>
      _$BodyModelFromJson(json);

  Map<String, dynamic> toJson() => _$BodyModelToJson(this);
}
