part of 'app_bloc.dart';

@immutable
abstract class AppBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddActionEvent extends AppBlocEvent {
  final Function? currentAction;

  AddActionEvent({this.currentAction});
}
