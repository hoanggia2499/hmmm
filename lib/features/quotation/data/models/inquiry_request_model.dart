import 'dart:convert';

class InquiryRequestModel {
  String memberNum;
  int userNum;
  String exhNum;
  int userCarNum;
  int makerCode;
  String makerName;
  String carName;
  int id;
  int questionKbn; // ID = 5
  String question;
  String? sellTime; // In case there is an assessment (ID = 4)
  String? sellPeriod; // In case there is an assessment (ID = 4)

  factory InquiryRequestModel.from(
      String memberNum,
      int userNum,
      String exhNum,
      int makerCode,
      String makerName,
      String carName,
      int id,
      String question) {
    return InquiryRequestModel(
      memberNum: memberNum,
      userNum: userNum,
      exhNum: exhNum,
      userCarNum: 0,
      makerCode: makerCode,
      makerName: makerName,
      carName: carName,
      id: id,
      question: question,
      questionKbn: 0,
      sellTime: null,
      sellPeriod: null,
    );
  }

  InquiryRequestModel({
    required this.memberNum,
    required this.userNum,
    required this.exhNum,
    required this.userCarNum,
    required this.makerCode,
    required this.makerName,
    required this.carName,
    required this.id,
    required this.questionKbn,
    required this.question,
    required this.sellTime,
    required this.sellPeriod,
  });

  InquiryRequestModel copyWith({
    String? memberNum,
    int? userNum,
    String? exhNum,
    int? userCarNum,
    int? makerCode,
    String? makerName,
    String? carName,
    int? id,
    int? questionKbn,
    String? question,
    String? sellTime,
    String? sellPeriod,
  }) {
    return InquiryRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      exhNum: exhNum ?? this.exhNum,
      userCarNum: userCarNum ?? this.userCarNum,
      makerCode: makerCode ?? this.makerCode,
      makerName: makerName ?? this.makerName,
      carName: carName ?? this.carName,
      id: id ?? this.id,
      questionKbn: questionKbn ?? this.questionKbn,
      question: question ?? this.question,
      sellTime: sellTime ?? this.sellTime,
      sellPeriod: sellPeriod ?? this.sellPeriod,
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
      'questionKbn': questionKbn,
      'question': question,
      'sellTime': sellTime,
      'sellPeriod': sellPeriod,
    };
  }

  factory InquiryRequestModel.fromMap(Map<String, dynamic> map) {
    return InquiryRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum'] ?? '',
      exhNum: map['exhNum'] ?? '',
      userCarNum: map['userCarNum'] ?? '',
      makerCode: map['makerCode'] ?? '',
      makerName: map['makerName'] ?? '',
      carName: map['carName'] ?? '',
      id: map['id'] ?? '',
      questionKbn: map['questionKbn'] ?? '',
      question: map['question'] ?? '',
      sellTime: map['sellTime'] ?? '',
      sellPeriod: map['sellPeriod'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InquiryRequestModel.fromJson(String source) =>
      InquiryRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuotationRequestModel(memberNum: $memberNum, userNum: $userNum, exhNum: $exhNum, userCarNum: $userCarNum, makerCode: $makerCode, makerName: $makerName, carName: $carName, id: $id, questionKbn: $questionKbn, question: $question, sellTime: $sellTime, sellPeriod: $sellPeriod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InquiryRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.exhNum == exhNum &&
        other.userCarNum == userCarNum &&
        other.makerCode == makerCode &&
        other.makerName == makerName &&
        other.carName == carName &&
        other.id == id &&
        other.questionKbn == questionKbn &&
        other.question == question &&
        other.sellTime == sellTime &&
        other.sellPeriod == sellPeriod;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        exhNum.hashCode ^
        userCarNum.hashCode ^
        makerCode.hashCode ^
        makerName.hashCode ^
        carName.hashCode ^
        id.hashCode ^
        questionKbn.hashCode ^
        question.hashCode ^
        sellTime.hashCode ^
        sellPeriod.hashCode;
  }
}
