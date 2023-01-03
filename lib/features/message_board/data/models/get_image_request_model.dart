import 'dart:convert';

class GetImageRequestModel {
  String memberNum;
  String userNum;
  String userCarNum;
  String upKind;

  GetImageRequestModel({
    required this.memberNum,
    required this.userNum,
    required this.userCarNum,
    required this.upKind,
  });

  GetImageRequestModel copyWith({
    String? memberNum,
    String? userNum,
    String? userCarNum,
    String? upKind,
  }) {
    return GetImageRequestModel(
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

  factory GetImageRequestModel.fromMap(Map<String, dynamic> map) {
    return GetImageRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      upKind: map['upKind'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GetImageRequestModel.fromJson(String source) =>
      GetImageRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetImageRequestModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum, upKind: $upKind)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetImageRequestModel &&
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
