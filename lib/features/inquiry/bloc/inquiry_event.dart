part of 'inquiry_bloc.dart';

abstract class InquiryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitEvent extends InquiryEvent {}
