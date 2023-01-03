import 'dart:convert';

import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';

class CommentModel {
  final String questionDate;
  final String? question;
  final String sendDate;
  final int sendNum;
  final int? questionNum;
  final String? info;
  final List<Reply> replyList;

  CommentModel({
    required this.questionDate,
    required this.question,
    required this.sendDate,
    required this.sendNum,
    required this.questionNum,
    required this.info,
    required this.replyList,
  });

  CommentModel copyWith({
    DateTime? questionDate,
    String? question,
    DateTime? sendDate,
    int? sendNum,
    int? questionNum,
    String? info,
    List<Reply>? replyList,
  }) {
    return CommentModel(
      questionDate: DateUtil.formatDate(questionDate),
      question: question ?? this.question,
      sendDate: DateUtil.formatDate(sendDate),
      sendNum: sendNum ?? this.sendNum,
      questionNum: questionNum ?? this.questionNum,
      info: info ?? this.info,
      replyList: replyList ?? this.replyList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionDate': questionDate,
      'question': question,
      'sendDate': sendDate,
      'sendNum': sendNum,
      'questionNum': questionNum,
      'info': info,
      'replyList': replyList.map((x) => x.toMap()).toList(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      questionDate: map['questionDate'] ?? '',
      question: map['question'] ?? '',
      sendDate: map['sendDate'] ?? '',
      sendNum: map['sendNum']?.toInt() ?? 0,
      questionNum: map['questionNum']?.toInt() ?? 0,
      info: map['info'] ?? '',
      replyList:
          List<Reply>.from(map['replyList']?.map((x) => Reply.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Commentmodel(questionDate: $questionDate, question: $question, sendDate: $sendDate, sendNum: $sendNum, questionNum: $questionNum, info: $info, replyList: $replyList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.questionDate == questionDate &&
        other.question == question &&
        other.sendDate == sendDate &&
        other.sendNum == sendNum &&
        other.questionNum == questionNum &&
        other.info == info &&
        listEquals(other.replyList, replyList);
  }

  @override
  int get hashCode {
    return questionDate.hashCode ^
        question.hashCode ^
        sendDate.hashCode ^
        sendNum.hashCode ^
        questionNum.hashCode ^
        info.hashCode ^
        replyList.hashCode;
  }
}

class Reply {
  final String? sendDate;
  final String? info;

  Reply({
    required this.sendDate,
    required this.info,
  });

  Reply copyWith({
    DateTime? sendDate,
    String? info,
  }) {
    return Reply(
      sendDate: sendDate.toString(),
      info: info ?? this.info,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sendDate': sendDate,
      'info': info,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      sendDate: map['sendDate'] ?? '',
      info: map['info'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) => Reply.fromMap(json.decode(source));

  @override
  String toString() => 'Reply(sendDate: $sendDate, info: $info)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reply && other.sendDate == sendDate && other.info == info;
  }

  @override
  int get hashCode => sendDate.hashCode ^ info.hashCode;
}
