part of 'app_bloc.dart';

@immutable
abstract class AppBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoAction extends AppBlocState {
  final bool pageActing;

  NoAction({required this.pageActing});

  @override
  List<Object> get props => [pageActing];
}

class CancelAction extends AppBlocState {
  final Function? nextAction;

  CancelAction({this.nextAction});

  @override
  List<Object> get props => [];
}
