import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';

abstract class InviteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InviteFriendEvent extends InviteEvent {
  final InviteFriendRequestModel request;
  final String storeName;

  InviteFriendEvent(this.request, this.storeName);
}
