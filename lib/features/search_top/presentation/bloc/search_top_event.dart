part of 'search_top_bloc.dart';

abstract class SearchTopEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TopInit extends SearchTopEvent {
  final BuildContext context;
  final bool isNameLoaded;

  TopInit({required this.context, this.isNameLoaded = false});

  @override
  List<Object> get props => [context, isNameLoaded];
}

class GetNumberOfUnreadInit extends SearchTopEvent {
  GetNumberOfUnreadInit(this.memberNum, this.userNum);

  final String memberNum;
  final int userNum;

  @override
  List<Object> get props => [memberNum, userNum];
}

class CompanyGetInit extends SearchTopEvent {
  CompanyGetInit(this.memberNum, this.context);

  final String memberNum;
  final BuildContext context;
  @override
  List<Object> get props => [memberNum, context];
}

class CheckUpdateEvent extends SearchTopEvent {
  final BuildContext context;

  CheckUpdateEvent({required this.context});
}
