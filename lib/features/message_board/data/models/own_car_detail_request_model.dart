import 'dart:convert';

class OwnCarDetailRequestModel {
  final String? memberNum;
  final String? userNum;
  final String? userCarNum;
  OwnCarDetailRequestModel({
    this.memberNum,
    this.userNum,
    this.userCarNum,
  });

  OwnCarDetailRequestModel copyWith({
    String? memberNum,
    String? userNum,
    String? userCarNum,
  }) {
    return OwnCarDetailRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
    };
  }

  factory OwnCarDetailRequestModel.fromMap(Map<String, dynamic> map) {
    return OwnCarDetailRequestModel(
      memberNum: map['memberNum'],
      userNum: map['userNum'],
      userCarNum: map['userCarNum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OwnCarDetailRequestModel.fromJson(String source) =>
      OwnCarDetailRequestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OwnCarDetailRequestModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OwnCarDetailRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userCarNum == userCarNum;
  }

  @override
  int get hashCode =>
      memberNum.hashCode ^ userNum.hashCode ^ userCarNum.hashCode;
}
