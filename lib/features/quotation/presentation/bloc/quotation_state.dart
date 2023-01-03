import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../search_detail/data/models/search_car_model.dart';

@immutable
abstract class QuotationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends QuotationState {}

class Loading extends QuotationState {}

class Error extends QuotationState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends QuotationState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class Loaded extends QuotationState {
  final List<SearchCarModel> searchCarModelList;

  Loaded({required this.searchCarModelList});

  @override
  List<Object> get props => [searchCarModelList];
}

class InquirySentState extends QuotationState {}
