import 'dart:convert';

class SellCarDeletePhotoModel {
  String memberNum;
  int userNum;
  int userCarNum;
  String upKind;

  SellCarDeletePhotoModel({
    required this.memberNum,
    required this.userNum,
    required this.userCarNum,
    required this.upKind,
  });

  SellCarDeletePhotoModel copyWith({
    String? memberNum,
    int? userNum,
    int? userCarNum,
    String? upKind,
  }) {
    return SellCarDeletePhotoModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
      upKind: upKind ?? this.upKind,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
      'upKind': upKind,
    };
  }

  factory SellCarDeletePhotoModel.fromMap(Map<String, dynamic> map) {
    return SellCarDeletePhotoModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum']?.toInt() ?? 0,
      userCarNum: map['userCarNum']?.toInt() ?? 0,
      upKind: map['upKind'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SellCarDeletePhotoModel.fromJson(String source) =>
      SellCarDeletePhotoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SellCarDeletePhotoModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum, upKind: $upKind)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SellCarDeletePhotoModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userCarNum == userCarNum &&
        other.upKind == upKind;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        userCarNum.hashCode ^
        upKind.hashCode;
  }
}
