part of 'search_top_bloc.dart';

abstract class SearchTopState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends SearchTopState {}

class Empty extends SearchTopState {}

class TimeOut extends SearchTopState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class Error extends SearchTopState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class LoadedGetNumberOfUnread extends SearchTopState {
  final int numberUnread;

  LoadedGetNumberOfUnread({required this.numberUnread});

  @override
  List<Object> get props => [numberUnread];
}

class LoadedCompanyGet extends SearchTopState {
  final CompanyGetModel companyGetModel;

  LoadedCompanyGet({required this.companyGetModel});

  @override
  List<Object> get props => [companyGetModel];
}

class CheckedUpdateVersion extends SearchTopState {}
