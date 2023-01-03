import 'new_question_model.dart';

class NewQuestionRequestModel extends NewQuestionModel {
  NewQuestionRequestModel({
    String? memberNum,
    int? userNum,
    String? exhNum,
    int? userCarNum,
    int? makerCode,
    String? makerName,
    String? carName,
    int? id,
    String? question,
    String? questionKbn,
  }) : super(
          memberNum: memberNum,
          userNum: userNum,
          exhNum: exhNum,
          userCarNum: userCarNum,
          makerCode: makerCode,
          makerName: makerName,
          carName: carName,
          id: id,
          question: question,
          questionKbn: questionKbn,
        );

  factory NewQuestionRequestModel.convertForm(NewQuestionModel request) {
    return NewQuestionRequestModel(
        memberNum: request.memberNum,
        userCarNum: request.userCarNum,
        userNum: request.userNum,
        exhNum: request.exhNum,
        id: request.id,
        makerCode: request.makerCode,
        makerName: request.makerName,
        carName: request.carName,
        question: request.question,
        questionKbn: request.questionKbn);
  }

  factory NewQuestionRequestModel.fromJson(Map<String, dynamic> map) {
    return NewQuestionRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      exhNum: map['exhNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      makerCode: map['makerCode'] ?? '',
      makerName: map['makerName'] ?? '',
      carName: map['carName'] ?? '',
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      questionKbn: map['questionKbn'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'exhNum': exhNum,
      'userCarNum': userCarNum,
      'makerCode': makerCode,
      'makerName': makerName,
      'carName': carName,
      'id': id,
      'question': question,
      'questionKbn': questionKbn,
    };
  }
}
