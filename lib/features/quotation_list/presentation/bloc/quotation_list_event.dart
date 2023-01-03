import 'package:equatable/equatable.dart';

abstract class QuotationListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QuotationListInit extends QuotationListEvent {}
