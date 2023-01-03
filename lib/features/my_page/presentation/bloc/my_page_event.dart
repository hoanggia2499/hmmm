import 'package:equatable/equatable.dart';

import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';

abstract class MyPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMyPageInformationEvent extends MyPageEvent {
  final MyPageRequestModel request;

  LoadMyPageInformationEvent(this.request);
}

class SaveMyPageInformationEvent extends MyPageEvent {
  final MyPageUpdateModel inputModel;

  SaveMyPageInformationEvent(this.inputModel);
}

class LoadUserCarNameListEvent extends MyPageEvent {
  final List<UserCarNameRequestModel> requestList;

  LoadUserCarNameListEvent({
    required this.requestList,
  });
}

class GetUserCarNameListEvent extends MyPageEvent {
  final MyPageModel myPageModel;

  GetUserCarNameListEvent({
    required this.myPageModel,
  });
}

class BackToMyPageScreenEvent extends MyPageEvent {
  final int selectedUserCarNameIndex;

  BackToMyPageScreenEvent(this.selectedUserCarNameIndex);
}
