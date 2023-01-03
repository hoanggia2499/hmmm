import 'dart:convert';

class NewCommentRequestModel {
  final String memberNum;
  final int userNum;
  final int id;
  final String exhNum;
  final int userCarNum;
  final int questionKbn;
  final String question;

  NewCommentRequestModel({
    required this.memberNum,
    required this.userNum,
    required this.id,
    required this.exhNum,
    required this.userCarNum,
    required this.questionKbn,
    required this.question,
  });

  NewCommentRequestModel copyWith({
    String? memberNum,
    int? userNum,
    int? id,
    String? exhNum,
    int? userCarNum,
    int? questionKbn,
    String? question,
  }) {
    return NewCommentRequestModel(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      id: id ?? this.id,
      exhNum: exhNum ?? this.exhNum,
      userCarNum: userCarNum ?? this.userCarNum,
      questionKbn: questionKbn ?? this.questionKbn,
      question: question ?? this.question,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'id': id,
      'exhNum': exhNum,
      'userCarNum': userCarNum,
      'questionKbn': questionKbn,
      'question': question,
    };
  }

  factory NewCommentRequestModel.fromMap(Map<String, dynamic> map) {
    return NewCommentRequestModel(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      exhNum: map['exhNum'] ?? '',
      userCarNum: map['userCarNum']?.toInt() ?? 0,
      questionKbn: map['questionKbn']?.toInt() ?? 0,
      question: map['question'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewCommentRequestModel.fromJson(String source) =>
      NewCommentRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewCommentRequestModel(memberNum: $memberNum, userNum: $userNum, id: $id, exhNum: $exhNum, userCarNum: $userCarNum, questionKbn: $questionKbn, question: $question)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewCommentRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.id == id &&
        other.exhNum == exhNum &&
        other.userCarNum == userCarNum &&
        other.questionKbn == questionKbn &&
        other.question == question;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        id.hashCode ^
        exhNum.hashCode ^
        userCarNum.hashCode ^
        questionKbn.hashCode ^
        question.hashCode;
  }
}
