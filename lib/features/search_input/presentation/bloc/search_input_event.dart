part of 'search_input_bloc.dart';

abstract class SearchInputEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends SearchInputEvent {}

class UpdateValueEvent extends SearchInputEvent {
  final String? firstValue;
  final String? secondValue;
  final TypeUpdate type;

  UpdateValueEvent({
    required this.firstValue,
    required this.secondValue,
    required this.type,
  });
}

class GetBodyListEvent extends SearchInputEvent {
  final List<bool> initListSelectedValue;
  int numbersOfChecked;

  GetBodyListEvent({
    required this.initListSelectedValue,
    required this.numbersOfChecked,
  });
}
