import 'dart:convert';

class MyPageUpdateModel {
  String? memberNum;
  String? userNum;
  String? username; // お名前
  String? usernameKana; // ふりがな
  String? email; // メールアドレス
  String? zipCode; // 郵便番号
  String? address1; // ご住所1
  String? address2; // ご住所2
  String? birthday; // 生年月日
  String? gender; // 性別
  String? family; // 家族構成
  String? jobCode; // 職業区分
  String? budget; // 車買い換え予算

  MyPageUpdateModel({
    this.memberNum,
    this.userNum,
    this.username,
    this.usernameKana,
    this.email,
    this.zipCode,
    this.address1,
    this.address2,
    this.birthday,
    this.gender,
    this.family,
    this.jobCode,
    this.budget,
  });

  MyPageUpdateModel copyWith({
    String? memberNum,
    String? userNum,
    String? username,
    String? usernameKana,
    String? email,
    String? zipCode,
    String? address1,
    String? address2,
    String? birthday,
    String? gender,
    String? family,
    String? jobCode,
    String? budget,
  }) {
    return MyPageUpdateModel(
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "memberNum": memberNum,
      "userNum": userNum,
      "username": username,
      "usernameKana": usernameKana,
      "email": email,
      "zipCode": zipCode,
      "address1": address1,
      "address2": address2,
      "birthday": birthday,
      "gender": gender,
      "family": family,
      "jobCode": jobCode,
      "budget": budget,
    };
  }

  factory MyPageUpdateModel.fromMap(Map<String, dynamic> map) {
    return MyPageUpdateModel(
      memberNum: map['memberNum'],
      userNum: map['userNum'],
      username: map['username'],
      usernameKana: map['usernameKana'],
      email: map['email'],
      zipCode: map['zipCode'],
      address1: map['address1'],
      address2: map['address2'],
      birthday: map['birthday'],
      gender: map['gender'],
      family: map['family'],
      jobCode: map['jobCode'],
      budget: map['budget'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyPageUpdateModel.fromJson(String source) =>
      MyPageUpdateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyPageUpdateModel(memberNum: $memberNum, userNum: $userNum, username: $username, usernameKana: $usernameKana, email: $email, zipCode: $zipCode, address1: $address1, address2: $address2, birthday: $birthday, gender: $gender, family: $family, jobCode: $jobCode, budget: $budget)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyPageUpdateModel &&
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
        other.budget == budget;
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
        budget.hashCode;
  }
}
