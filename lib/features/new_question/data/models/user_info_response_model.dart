import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mirukuru/core/network/json_convert_base.dart';

import 'car_name_response_V2.dart';

class UserInfoResponseModel extends JsonConvert<UserInfoResponseModel> {
  String memberNum;
  String userNum;
  String userName; // お名前
  String userNameKana; // ふりがな
  String email; // メールアドレス
  String zipCode; // 郵便番号
  String address1; // ご住所1
  String address2; // ご住所2
  String birthday; // 生年月日
  String gender; // 性別
  String family; // 家族構成
  String jobCode; // 職業区分
  String budget; // 車買い換え予算
  List<CarNameResponseV2>? userCarList;

  UserInfoResponseModel({
    this.memberNum = '',
    this.userNum = '',
    this.userName = '',
    this.userNameKana = '',
    this.email = '',
    this.zipCode = '',
    this.address1 = '',
    this.address2 = '',
    this.birthday = '',
    this.gender = '',
    this.family = '',
    this.jobCode = '',
    this.budget = '',
    this.userCarList,
  });

  String toJson() => json.encode(toMap());

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> map) {
    return UserInfoResponseModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userName: map['userName'] ?? '',
      userNameKana: map['userNameKana'] ?? '',
      email: map['email'] ?? '',
      zipCode: map['zipCode'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      birthday: map['birthday'] ?? '',
      gender: map['gender'] ?? '',
      family: map['family'] ?? '',
      jobCode: map['jobCode'] ?? '',
      budget: map['budget'] ?? '',
      userCarList: map['userCarList'] != null
          ? CarNameResponseV2.fromListMap(
              List<Map<String, dynamic>>.from(map['userCarList']))
          : null,
    );
  }

  UserInfoResponseModel copyWith({
    String? memberNum,
    String? userNum,
    String? userName,
    String? userNameKana,
    String? email,
    String? zipCode,
    String? address1,
    String? address2,
    String? birthday,
    String? gender,
    String? family,
    String? jobCode,
    String? budget,
    List<CarNameResponseV2>? userCarList,
  }) {
    return UserInfoResponseModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userName: userName ?? this.userName,
      userNameKana: userNameKana ?? this.userNameKana,
      email: email ?? this.email,
      zipCode: zipCode ?? this.zipCode,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      family: family ?? this.family,
      jobCode: jobCode ?? this.jobCode,
      budget: budget ?? this.budget,
      userCarList: userCarList ?? this.userCarList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userName': userName,
      'userNameKana': userNameKana,
      'email': email,
      'zipCode': zipCode,
      'address1': address1,
      'address2': address2,
      'birthday': birthday,
      'gender': gender,
      'family': family,
      'jobCode': jobCode,
      'budget': budget,
    };
  }

  factory UserInfoResponseModel.fromMap(Map<String, dynamic> map) {
    return UserInfoResponseModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userName: map['userName'] ?? '',
      userNameKana: map['userNameKana'] ?? '',
      email: map['email'] ?? '',
      zipCode: map['zipCode'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      birthday: map['birthday'] ?? '',
      gender: map['gender'] ?? '',
      family: map['family'] ?? '',
      jobCode: map['jobCode'] ?? '',
      budget: map['budget'] ?? '',
      userCarList: map['userCarList'] != null
          ? List<CarNameResponseV2>.from(
              map['userCarList']?.map((x) => CarNameResponseV2.fromMap(x)))
          : null,
    );
  }

  @override
  String toString() {
    return 'UserInfoResponseModel(memberNum: $memberNum, userNum: $userNum, userName: $userName, userNameKana: $userNameKana, email: $email, zipCode: $zipCode, address1: $address1, address2: $address2, birthday: $birthday, gender: $gender, family: $family, jobCode: $jobCode, budget: $budget, userCarList: $userCarList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfoResponseModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userName == userName &&
        other.userNameKana == userNameKana &&
        other.email == email &&
        other.zipCode == zipCode &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.birthday == birthday &&
        other.gender == gender &&
        other.family == family &&
        other.jobCode == jobCode &&
        other.budget == budget &&
        listEquals(other.userCarList, userCarList);
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        userName.hashCode ^
        userNameKana.hashCode ^
        email.hashCode ^
        zipCode.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        birthday.hashCode ^
        gender.hashCode ^
        family.hashCode ^
        jobCode.hashCode ^
        budget.hashCode ^
        userCarList.hashCode;
  }
}
