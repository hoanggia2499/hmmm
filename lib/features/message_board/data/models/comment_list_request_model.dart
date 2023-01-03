import 'dart:convert';

class CommentListRequestModel {
  final String memberNum;
  final int userNum;
  final String? exhNum;
  final String? userCarNum;
  final String? id;
  final int? questionKbn;

  CommentListRequestModel(
      {required this.memberNum,
      required this.userNum,
      this.exhNum,
      this.id,
      this.questionKbn,
      this.userCarNum = "0"});

  CommentListRequestModel copyWith({
    String? memberNum,
    int? userNum,
    String? exhNum,
    String? id,
    int? questionKbn,
    String? userCarNum,
  }) {
    return CommentListRequestModel(
        memberNum: memberNum ?? this.memberNum,
        userNum: userNum ?? this.userNum,
        exhNum: exhNum ?? this.exhNum,
        id: id ?? this.id,
        questionKbn: questionKbn ?? this.questionKbn,
        userCarNum: userCarNum ?? this.userCarNum);
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'exhNum': exhNum,
      'id': id,
      'questionKbn': questionKbn,
      'userCarNum': userCarNum,
    };
  }

  factory CommentListRequestModel.fromMap(Map<String, dynamic> map) {
    return CommentListRequestModel(
        memberNum: map['memberNum'] ?? '',
        userNum: map['userNum']?.toInt() ?? 0,
        exhNum: map['exhNum'],
        id: map['id'],
        questionKbn: map['questionKbn']?.toInt(),
        userCarNum: map['userCarNum'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CommentListRequestModel.fromJson(String source) =>
      CommentListRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentListRequestModel(memberNum: $memberNum, userNum: $userNum, exhNum: $exhNum, id: $id, questionKbn: $questionKbn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentListRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum &&
        other.exhNum == exhNum &&
        other.id == id &&
        other.questionKbn == questionKbn &&
        other.userCarNum == userCarNum;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        userNum.hashCode ^
        exhNum.hashCode ^
        id.hashCode ^
        questionKbn.hashCode ^
        userCarNum.hashCode;
  }
}
