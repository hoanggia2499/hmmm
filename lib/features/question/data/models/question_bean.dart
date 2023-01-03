import 'package:json_annotation/json_annotation.dart';

part 'question_bean.g.dart';

@JsonSerializable()
class QuestionBean {
  String memberNum;
  int userNum;
  int questionNum;
  String questionDate;
  int questionKbn;
  String question;
  String exhNum;
  int userCarNum;
  //String confirmDate;
  //String sendDate;
  int sendNum;
  int deleteFlag;
// String corner;
  String fullExhNum;
  //String sendID;
  //String replyFlag;
  //String info;
  int id;
  //String makerCode;
  //String carCode;
  String asMakerName;
  String asnetCarName;

  QuestionBean(
      {this.memberNum = '',
      this.userNum = 0,
      this.deleteFlag = 0,
      this.id = 0,
      this.fullExhNum = '',
      this.exhNum = '',
      this.asMakerName = '',
      this.asnetCarName = '',
      this.question = '',
      this.questionDate = '',
      this.questionKbn = 0,
      this.questionNum = 0,
      this.sendNum = 0,
      this.userCarNum = 0});

  factory QuestionBean.fromJson(Map<String, dynamic> json) =>
      _$QuestionBeanFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBeanToJson(this);
}
