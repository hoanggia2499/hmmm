import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';

@immutable
abstract class QuotationListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends QuotationListState {}

class Loading extends QuotationListState {}

class Loaded extends QuotationListState {
  final List<QuestionBean> listQuestionBean;

  Loaded({required this.listQuestionBean});

  @override
  List<Object> get props => [listQuestionBean];
}

class Error extends QuotationListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends QuotationListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class SendMailState extends QuotationListState {}
