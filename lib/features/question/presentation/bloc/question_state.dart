import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';

@immutable
abstract class QuestionState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends QuestionState {}

class Loading extends QuestionState {}

class Loaded extends QuestionState {
  final String agreement;

  Loaded({required this.agreement});

  @override
  List<Object> get props => [agreement];
}

class Error extends QuestionState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends QuestionState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class QuestionListState extends QuestionState {
  final List<QuestionBean> result;

  QuestionListState({required this.result});

  @override
  List<Object> get props => [];
}

class DeleteQuestionState extends QuestionState {
  final List<DeletedQuestion> deletedQuestions;

  DeleteQuestionState({required this.deletedQuestions});

  @override
  List<Object> get props => [deletedQuestions];
}

class DeletedQuestion {
  String id;
  String questionNum;

  DeletedQuestion({
    required this.id,
    required this.questionNum,
  });
}
