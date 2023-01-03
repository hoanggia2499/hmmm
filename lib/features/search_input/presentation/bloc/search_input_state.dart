part of 'search_input_bloc.dart';

abstract class SearchInputState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends SearchInputState {}

class Loading extends SearchInputState {}

class Loaded extends SearchInputState {}

class AlertState extends SearchInputState {
  final String errorContent;

  AlertState(this.errorContent);
  @override
  List<Object?> get props => [errorContent];
}

class UpdateNenshikiState extends SearchInputState {
  final String? firstValue;
  final String? secondValue;

  UpdateNenshikiState(this.firstValue, this.secondValue);

  @override
  List<Object?> get props => [firstValue, secondValue];
}

class UpdateDistanceState extends SearchInputState {
  String? firstValue;
  String? secondValue;

  UpdateDistanceState(this.firstValue, this.secondValue);

  @override
  List<Object?> get props => [firstValue, secondValue];
}

class UpdatePriceState extends SearchInputState {
  String? firstValue;
  String? secondValue;

  UpdatePriceState(this.firstValue, this.secondValue);

  @override
  List<Object?> get props => [firstValue, secondValue];
}

class UpdateHaikiryouState extends SearchInputState {
  String? firstValue;
  String? secondValue;

  UpdateHaikiryouState(this.firstValue, this.secondValue);

  @override
  List<Object?> get props => [firstValue, secondValue];
}

class LoadedBodyListDataState extends SearchInputState {
  final List<String> bodyList;
  final List<bool> initListSelectedValue;
  final int numbersOfChecked;
  LoadedBodyListDataState(
      this.bodyList, this.initListSelectedValue, this.numbersOfChecked);

  @override
  List<Object?> get props =>
      [bodyList, initListSelectedValue, numbersOfChecked];
}
