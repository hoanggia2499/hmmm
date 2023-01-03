import 'new_question_model.dart';

class DeletePhotoRequestModel extends NewQuestionModel {
  DeletePhotoRequestModel({
    String? memberNum,
    int? userNum,
    int? userCarNum,
    String? upKind,
  }) : super(
            memberNum: memberNum,
            userNum: userNum,
            userCarNum: userCarNum,
            upKind: upKind);

  factory DeletePhotoRequestModel.fromJson(Map<String, dynamic> json) {
    return DeletePhotoRequestModel(
      memberNum: json['memberNum'],
      userNum: json['userNum'],
      userCarNum: json['userCarNum'],
      upKind: json['upKind'],
    );
  }

  factory DeletePhotoRequestModel.convertForm(NewQuestionModel delete) {
    return DeletePhotoRequestModel(
      memberNum: delete.memberNum,
      userCarNum: delete.userCarNum,
      userNum: delete.userNum,
      upKind: delete.upKind,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'userCarNum': userCarNum,
      'upKind': upKind,
    };
  }
}
