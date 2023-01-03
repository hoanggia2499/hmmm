import 'dart:convert';

import 'package:mirukuru/core/config/core_config.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';

class StoreInformationModel {
  String memberNum;
  String storeName;
  String storeName2;
  String tel;
  String email;
  String address1;
  String address2;
  String holiday;
  String salestime;
  String photo;
  String zipCode;
  String logoMark;

  String get getMemberNum => this.memberNum;

  set setMemberNum(String memberNum) => this.memberNum = memberNum;

  get getStoreName => this.storeName;

  set setStoreName(storeName) => this.storeName = storeName;

  get getStoreName2 => this.storeName2;

  set setStoreName2(storeName2) => this.storeName2 = storeName2;

  get getTel => this.tel;

  set setTel(tel) => this.tel = tel;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getAddress1 => this.address1;

  set setAddress1(address1) => this.address1 = address1;

  get getAddress2 => this.address2;

  set setAddress2(address2) => this.address2 = address2;

  get getHoliday => this.holiday;

  set setHoliday(holiday) => this.holiday = holiday;

  get getSalesTime => this.salestime;

  set setSalesTime(salestime) => this.salestime = salestime;

  get getPhoto => this.photo;

  set setPhoto(photo) => this.photo = photo;

  get getZipCode => this.zipCode;

  set setZipCode(zipCode) => this.zipCode = zipCode;

  get getLogoMark => this.logoMark;

  set setLogoMark(logoMark) => this.logoMark = logoMark;

  StoreInformationModel(
      {this.memberNum = '',
      this.storeName = '',
      this.storeName2 = '',
      this.tel = '',
      this.email = '',
      this.address1 = '',
      this.address2 = '',
      this.holiday = '',
      this.salestime = '',
      this.photo = '',
      this.zipCode = '',
      this.logoMark = ''});

  String displayFullAddress() {
    String formattedZipCode =
        "〒" + HelperFunction.instance.formatZipCode(zipCode);
    var inputs = [formattedZipCode, address1, address2];
    inputs.removeWhere((element) => element.isEmpty);
    return inputs.join("\n");
  }

  String getStorePhotoUrl() {
    Logging.log.info(
        'Store Image URL: ${Common.imageUrl}${this.memberNum}/${this.photo}');
    return "${Common.imageUrl}${this.memberNum}/${this.photo}";
  }

  StoreInformationModel copyWith({
    String? memberNum,
    String? storeName,
    String? storeName2,
    String? tel,
    String? email,
    String? address1,
    String? address2,
    String? holiday,
    String? salestime,
    String? photo,
    String? zipCode,
    String? logoMark,
  }) {
    return StoreInformationModel(
      memberNum: memberNum ?? this.memberNum,
      storeName: storeName ?? this.storeName,
      storeName2: storeName2 ?? this.storeName2,
      tel: tel ?? this.tel,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      holiday: holiday ?? this.holiday,
      salestime: salestime ?? this.salestime,
      photo: photo ?? this.photo,
      zipCode: zipCode ?? this.zipCode,
      logoMark: logoMark ?? this.logoMark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'storeName': storeName,
      'storeName2': storeName2,
      'tel': tel,
      'email': email,
      'address1': address1,
      'address2': address2,
      'holiday': holiday,
      'salestime': salestime,
      'photo': photo,
      'zipCode': zipCode,
      'logoMark': logoMark,
    };
  }

  factory StoreInformationModel.fromMap(Map<String, dynamic> map) {
    return StoreInformationModel(
      memberNum: map['memberNum'] ?? '',
      storeName: map['storeName'] ?? '',
      storeName2: map['storeName2'] ?? '',
      tel: map['tel'] ?? '',
      email: map['email'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      holiday: map['holiday'] ?? '',
      salestime: map['salestime'] ?? '',
      photo: map['photo'] ?? '',
      zipCode: map['zipCode'] ?? '',
      logoMark: map['logoMark'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInformationModel.fromJson(String source) =>
      StoreInformationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StoreInformationModel(memberNum: $memberNum, storeName: $storeName, tel: $tel, email: $email, address1: $address1, address2: $address2, holiday: $holiday, salestime: $salestime, photo: $photo, zipCode: $zipCode, logoMark: $logoMark)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreInformationModel &&
        other.memberNum == memberNum &&
        other.storeName == storeName &&
        other.storeName2 == storeName2 &&
        other.tel == tel &&
        other.email == email &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.holiday == holiday &&
        other.salestime == salestime &&
        other.photo == photo &&
        other.zipCode == zipCode &&
        other.logoMark == logoMark;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        storeName.hashCode ^
        storeName2.hashCode ^
        tel.hashCode ^
        email.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        holiday.hashCode ^
        salestime.hashCode ^
        photo.hashCode ^
        zipCode.hashCode ^
        logoMark.hashCode;
  }
}
