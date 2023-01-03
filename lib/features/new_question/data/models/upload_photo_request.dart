import 'package:image_picker/image_picker.dart';

import 'new_question_model.dart';

class UploadPhotoRequestModel extends NewQuestionModel {
  UploadPhotoRequestModel({
    String? memberNum,
    int? userNum,
    int? userCarNum,
    String? upKind,
    List<XFile?>? files,
  }) : super(
          memberNum: memberNum,
          userNum: userNum,
          userCarNum: userCarNum,
          upKind: upKind,
          files: files,
        );

  factory UploadPhotoRequestModel.fromJson(Map<String, dynamic> json) {
    return UploadPhotoRequestModel(
      memberNum: json['memberNum'],
      userNum: json['userNum'],
      userCarNum: json['userCarNum'],
      upKind: json['upKind'],
      files: json['files'],
    );
  }

  factory UploadPhotoRequestModel.convertForm(NewQuestionModel request) {
    return UploadPhotoRequestModel(
      memberNum: request.memberNum,
      userCarNum: request.userCarNum,
      userNum: request.userNum,
      upKind: request.upKind,
      files: request.files,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
      'upKind': upKind,
      'files': files,
    };
  }
}
