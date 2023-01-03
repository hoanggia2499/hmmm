import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'my_page_user_car_model.dart';

class MyPageInputModel {
  String memberNum;
  String userNum;
  String username; // お名前
  String usernameKana; // ふりがな
  String email; // メールアドレス
  String zipCode; // 郵便番号
  String address1; // ご住所1
  String address2; // ご住所2
  DateTime? birthday; // 生年月日
  int gender; // 性別
  int family; // 家族構成
  int jobCode; // 職業区分
  int budget; // 車買い換え予算
  List<UserCarModel> userCarList;

  factory MyPageInputModel.convertFrom(MyPageModel myPageModel) {
    return MyPageInputModel(
      memberNum: myPageModel.memberNum,
      userNum: myPageModel.userNum,
      username: myPageModel.userName,
      usernameKana: myPageModel.userNameKana,
      email: myPageModel.email,
      zipCode: HelperFunction.instance.formatZipCode(myPageModel.zipCode),
      address1: myPageModel.address1,
      address2: myPageModel.address2,
      gender: int.tryParse(myPageModel.gender) != null
          ? int.parse(myPageModel.gender)
          : -1,
      family: int.tryParse(myPageModel.family) != null
          ? int.parse(myPageModel.family)
          : -1,
      jobCode: int.tryParse(myPageModel.jobCode) != null
          ? int.parse(myPageModel.jobCode)
          : -1,
      budget: int.tryParse(myPageModel.budget) != null
          ? int.parse(myPageModel.budget)
          : -1,
      birthday: myPageModel.birthday.isNotEmpty
          ? HelperFunction.instance.parseDateString(myPageModel.birthday)
          : null,
    );
  }

  MyPageInputModel({
    List<UserCarModel>? userCarList,
    this.memberNum = "",
    this.userNum = "",
    this.username = "",
    this.usernameKana = "",
    this.email = "",
    this.zipCode = "",
    this.address1 = "",
    this.address2 = "",
    this.birthday,
    this.gender = -1,
    this.family = -1,
    this.jobCode = -1,
    this.budget = -1,
  }) : this.userCarList =
            userCarList != null ? userCarList : List.empty(growable: true);

  static DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  static String fromDateTime(DateTime birthday) {
    return dateFormat.format(birthday).replaceAll("/", "");
  }

  MyPageUpdateModel toUpdatePayload() {
    return MyPageUpdateModel(
        memberNum: this.memberNum,
        userNum: this.userNum.toString(),
        username: this.username,
        usernameKana: this.usernameKana,
        email: this.email,
        zipCode: this.zipCode.replaceAll("-", ""),
        address1: this.address1,
        address2: this.address2,
        birthday: this.birthday != null ? fromDateTime(this.birthday!) : null,
        gender: this.gender == -1 ? null : this.gender.toString(),
        family: this.family == -1 ? null : this.family.toString(),
        jobCode: this.jobCode == -1 ? null : this.jobCode.toString(),
        budget: this.budget == -1 ? null : this.budget.toString());
  }

  MyPageInputModel copyWith({
    String? memberNum,
    String? userNum,
    String? username,
    String? usernameKana,
    String? email,
    String? zipCode,
    String? address1,
    String? address2,
    DateTime? birthday,
    int? gender,
    int? family,
    int? jobCode,
    int? budget,
    List<UserCarModel>? userCarList,
  }) {
    return MyPageInputModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      username: username ?? this.username,
      usernameKana: usernameKana ?? this.usernameKana,
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
      'username': username,
      'usernameKana': usernameKana,
      'email': email,
      'zipCode': zipCode,
      'address1': address1,
      'address2': address2,
      'birthday': birthday?.millisecondsSinceEpoch,
      'gender': gender,
      'family': family,
      'jobCode': jobCode,
      'budget': budget,
      'userCarList': userCarList.map((x) => x.toMap()).toList(),
    };
  }

  factory MyPageInputModel.fromMap(Map<String, dynamic> map) {
    return MyPageInputModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      username: map['username'] ?? '',
      usernameKana: map['usernameKana'] ?? '',
      email: map['email'] ?? '',
      zipCode: map['zipCode'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      gender: map['gender']?.toInt() ?? 0,
      family: map['family']?.toInt() ?? 0,
      jobCode: map['jobCode']?.toInt() ?? 0,
      budget: map['budget']?.toInt() ?? 0,
      userCarList: List<UserCarModel>.from(
          map['userCarList']?.map((x) => UserCarModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyPageInputModel.fromJson(String source) =>
      MyPageInputModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyPageInputModel(memberNum: $memberNum, userNum: $userNum, username: $username, usernameKana: $usernameKana, email: $email, zipCode: $zipCode, address1: $address1, address2: $address2, birthday: $birthday, gender: $gender, family: $family, jobCode: $jobCode, budget: $budget, userCarNameList: $userCarList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyPageInputModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.username == username &&
        other.usernameKana == usernameKana &&
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
        username.hashCode ^
        usernameKana.hashCode ^
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
