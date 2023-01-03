import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mirukuru/core/network/json_convert_base.dart';

import 'my_page_user_car_model.dart';

class MyPageModel extends JsonConvert<MyPageModel> {
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
  String mobilePhone;
  List<UserCarModel>? userCarList;

  MyPageModel(
      {this.memberNum = '',
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
      this.mobilePhone = ''});

  String toJson() => json.encode(toMap());

  factory MyPageModel.fromJson(Map<String, dynamic> map) {
    return MyPageModel(
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
      mobilePhone: map['mobilePhone'] ?? '',
      userCarList: map['userCarList'] != null
          ? UserCarModel.fromListMap(
              List<Map<String, dynamic>>.from(map['userCarList']))
          : null,
    );
  }

  MyPageModel copyWith({
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
    String? mobilePhone,
    List<UserCarModel>? userCarList,
  }) {
    return MyPageModel(
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
      mobilePhone: mobilePhone ?? this.mobilePhone,
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
      'mobilePhone': mobilePhone
    };
  }

  factory MyPageModel.fromMap(Map<String, dynamic> map) {
    return MyPageModel(
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
      mobilePhone: map['mobilePhone'] ?? '',
      userCarList: map['userCarList'] != null
          ? List<UserCarModel>.from(
              map['userCarList']?.map((x) => UserCarModel.fromMap(x)))
          : null,
    );
  }

  @override
  String toString() {
    return 'MyPageModel(memberNum: $memberNum, userNum: $userNum, userName: $userName, userNameKana: $userNameKana, email: $email, zipCode: $zipCode, address1: $address1, address2: $address2, birthday: $birthday, gender: $gender, family: $family, jobCode: $jobCode, budget: $budget, mobilePhone:$mobilePhone, userCarList: $userCarList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyPageModel &&
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
        other.mobilePhone == mobilePhone &&
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
        mobilePhone.hashCode ^
        userCarList.hashCode;
  }
}
