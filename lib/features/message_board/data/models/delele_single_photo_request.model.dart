import 'dart:convert';

class DeleteSinglePhotoRequestModel {
  String memberNum;
  String userNum;
  String userCarNum;
  String upKind;
  String imgName;

  DeleteSinglePhotoRequestModel({
    required this.memberNum,
    required this.userNum,
    required this.userCarNum,
    required this.upKind,
    required this.imgName,
  });

  DeleteSinglePhotoRequestModel copyWith({
    String? memberNum,
    String? userNum,
    String? userCarNum,
    String? upKind,
    String? imgName,
  }) {
    return DeleteSinglePhotoRequestModel(
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

  factory DeleteSinglePhotoRequestModel.fromMap(Map<String, dynamic> map) {
    return DeleteSinglePhotoRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      upKind: map['upKind'] ?? '',
      imgName: map['imgName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteSinglePhotoRequestModel.fromJson(String source) =>
      DeleteSinglePhotoRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeletePhotoRequestModel(memberNum: $memberNum, userNum: $userNum, userCarNum: $userCarNum, upKind: $upKind, imgName: $imgName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteSinglePhotoRequestModel &&
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
