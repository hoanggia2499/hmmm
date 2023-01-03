import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';

abstract class QuestionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadQuestions extends QuestionEvent {
  final QuestionBeanParam questionBeanParam;
  final bool isLoadAll;

  LoadQuestions({required this.questionBeanParam, this.isLoadAll = false});

  @override
  List<Object> get props => [questionBeanParam];
}

class DeleteQuestionInit extends QuestionEvent {
  DeleteQuestionInit(this.deleteQuestionParam, this.context);

  DeleteQuestionParam deleteQuestionParam;
  final BuildContext context;
  @override
  List<Object> get props => [deleteQuestionParam, context];
}

class SortQuestionList extends QuestionEvent {}
