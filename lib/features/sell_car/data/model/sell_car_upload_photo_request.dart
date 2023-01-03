import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class SellCarUploadPhotoRequestModel {
  String? memberNum;
  int? userNum;
  int? userCarNum;
  String? upKind;
  List<XFile?>? files;

  SellCarUploadPhotoRequestModel({
    this.memberNum,
    this.userNum,
    this.userCarNum,
    this.upKind,
    this.files,
  });

  SellCarUploadPhotoRequestModel copyWith({
    String? memberNum,
    int? userNum,
    int? userCarNum,
    String? upKind,
    List<XFile?>? files,
  }) {
    return SellCarUploadPhotoRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      userCarNum: userCarNum ?? this.userCarNum,
      upKind: upKind ?? this.upKind,
      files: files ?? this.files,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SellCarUploadPhotoRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.userCarNum == userCarNum &&
        other.upKind == upKind &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        userCarNum.hashCode ^
        upKind.hashCode ^
        files.hashCode;
  }
}
