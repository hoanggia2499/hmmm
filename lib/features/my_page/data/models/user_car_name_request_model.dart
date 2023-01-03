import 'dart:convert';

import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';

class UserCarNameRequestModel {
  String? makerCode;
  String? carCode;

  UserCarNameRequestModel({
    this.makerCode,
    this.carCode,
  });

  UserCarNameRequestModel copyWith({
    String? makerCode,
    String? carCode,
  }) {
    return UserCarNameRequestModel(
      makerCode: makerCode ?? this.makerCode,
      carCode: carCode ?? this.carCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'makerCode': makerCode,
      'carCode': carCode,
    };
  }

  factory UserCarNameRequestModel.fromMap(Map<String, dynamic> map) {
    return UserCarNameRequestModel(
      makerCode: map['makerCode'],
      carCode: map['carCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCarNameRequestModel.fromJson(String source) =>
      UserCarNameRequestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserCarNameRequestModel(makerCode: $makerCode, carCode: $carCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserCarNameRequestModel &&
        other.makerCode == makerCode &&
        other.carCode == carCode;
  }

  @override
  int get hashCode => makerCode.hashCode ^ carCode.hashCode;

  static UserCarNameRequestModel from(UserCarModel userCarList) =>
      UserCarNameRequestModel(
          carCode: userCarList.carCode, makerCode: userCarList.makerCode);
}
