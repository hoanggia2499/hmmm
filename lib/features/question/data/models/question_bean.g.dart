// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionBean _$QuestionBeanFromJson(Map<String, dynamic> json) => QuestionBean(
      memberNum: json['memberNum'] as String? ?? '',
      userNum: json['userNum'] as int? ?? 0,
      deleteFlag: json['deleteFlag'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      fullExhNum: json['fullExhNum'] as String? ?? '',
      exhNum: json['exhNum'] as String? ?? '',
      asMakerName: json['asMakerName'] as String? ?? '',
      asnetCarName: json['asnetCarName'] as String? ?? '',
      question: json['question'] as String? ?? '',
      questionDate: json['questionDate'] as String? ?? '',
      questionKbn: json['questionKbn'] as int? ?? 0,
      questionNum: json['questionNum'] as int? ?? 0,
      sendNum: json['sendNum'] as int? ?? 0,
      userCarNum: json['userCarNum'] as int? ?? 0,
    );

Map<String, dynamic> _$QuestionBeanToJson(QuestionBean instance) =>
    <String, dynamic>{
      'memberNum': instance.memberNum,
      'userNum': instance.userNum,
      'questionNum': instance.questionNum,
      'questionDate': instance.questionDate,
      'questionKbn': instance.questionKbn,
      'question': instance.question,
      'exhNum': instance.exhNum,
      'userCarNum': instance.userCarNum,
      'sendNum': instance.sendNum,
      'deleteFlag': instance.deleteFlag,
      'fullExhNum': instance.fullExhNum,
      'id': instance.id,
      'asMakerName': instance.asMakerName,
      'asnetCarName': instance.asnetCarName,
    };
