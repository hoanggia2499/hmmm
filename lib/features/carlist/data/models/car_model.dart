import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/network/json_convert_base.dart';

class CarModel extends JsonConvert<CarModel> with EquatableMixin {
  String makerCode;
  String carGroup;
  String asnetCarCode;
  int numOfCarASOne;

  CarModel(
      {this.makerCode = '',
      this.asnetCarCode = '',
      this.carGroup = '',
      this.numOfCarASOne = 0});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      makerCode: json['makerCode'] ?? '',
      carGroup: json['carGroup'] ?? '',
      asnetCarCode: json['asnetCarCode'] ?? '',
      numOfCarASOne: json['numOfCarASOne'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'makerCode': makerCode,
        'carGroup': carGroup,
        'asnetCarCode': asnetCarCode,
        'numOfCarASOne': numOfCarASOne,
      };

  @override
  List<Object?> get props => [makerCode, carGroup, asnetCarCode, numOfCarASOne];
}
