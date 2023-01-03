import 'dart:convert';

class SellCarDeleteSinglePhotoRequestModel {
  String memberNum;
  String userNum;
  String userCarNum;
  String upKind;
  String imgName;

  SellCarDeleteSinglePhotoRequestModel({
    required this.memberNum,
    required this.userNum,
    required this.userCarNum,
    required this.upKind,
    required this.imgName,
  });

  SellCarDeleteSinglePhotoRequestModel copyWith({
    String? memberNum,
    String? userNum,
    String? userCarNum,
    String? upKind,
    String? imgName,
  }) {
    return SellCarDeleteSinglePhotoRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
      upKind: upKind ?? this.upKind,
      imgName: imgName ?? this.imgName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
      'upKind': upKind,
      'imgName': imgName,
    };
  }

  factory SellCarDeleteSinglePhotoRequestModel.fromMap(
      Map<String, dynamic> map) {
    return SellCarDeleteSinglePhotoRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      upKind: map['upKind'] ?? '',
      imgName: map['imgName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SellCarDeleteSinglePhotoRequestModel.fromJson(String source) =>
      SellCarDeleteSinglePhotoRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeletePhotoRequestModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum, upKind: $upKind, imgName: $imgName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SellCarDeleteSinglePhotoRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userCarNum == userCarNum &&
        other.upKind == upKind &&
        other.imgName == imgName;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        userCarNum.hashCode ^
        upKind.hashCode ^
        imgName.hashCode;
  }
}
