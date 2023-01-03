part of 'new_question_bloc.dart';

abstract class NewQuestionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NewQuestionInitEvent extends NewQuestionEvent {
  final UserInfoRequestModel request;

  NewQuestionInitEvent(this.request);
}

class PostNewQuestionEvent extends NewQuestionEvent {
  final NewQuestionModel request;

  PostNewQuestionEvent(this.request);
}

class GetLocalDataEvent extends NewQuestionEvent {}

class DeleteAllPhotosEvent extends NewQuestionEvent {
  final NewQuestionModel request;

  DeleteAllPhotosEvent(this.request);
}

class UpLoadPhotosEvent extends NewQuestionEvent {
  final NewQuestionModel request;

  UpLoadPhotosEvent(this.request);
}

class NewQuestionUpdatePhoto extends NewQuestionEvent {
  @override
  List<Object> get props => super.props;
}

class OnSelectDivisionEvent extends NewQuestionEvent {
  final int indexSelectQuestionKbnType;

  OnSelectDivisionEvent(this.indexSelectQuestionKbnType);
}

class OnSelectOwnerCarEvent extends NewQuestionEvent {
  final int indexSelectOwnerCar;

  OnSelectOwnerCarEvent(this.indexSelectOwnerCar);
}

class UpdatePhoto extends NewQuestionEvent {
  @override
  List<Object> get props => super.props;
}
