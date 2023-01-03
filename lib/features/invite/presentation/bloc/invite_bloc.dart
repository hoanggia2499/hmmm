import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/invite/domain/usecases/invite_friend.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_event.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/util/error_code.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteFriend inviteFriend;

  InviteBloc(this.inviteFriend) : super(Empty()) {
    on<InviteFriendEvent>(_onInviteFriend);
  }

  Future _onInviteFriend(
      InviteFriendEvent event, Emitter<InviteState> emit) async {
    emit(Loading());
    try {
      final callInviteFriend = await inviteFriend.call(event.request);

      callInviteFriend.fold((error) async {
        Logging.log.warn(error);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }

        return false;
      }, (result) async {
        if (result == null) {
          emit(Empty());
        }

        emit(InvitedFriend());

        event.request.isEmail()
            ? await sendMail(
                event.request.email ?? "",
                result?.invitationMailSubject ?? "",
                result?.generateInviteContent(true, event.storeName,
                        event.request.inviteCode ?? "") ??
                    "")
            : await sendSms(
                event.request.mobilePhone ?? "",
                result?.generateInviteContent(false, event.storeName,
                        event.request.inviteCode ?? "") ??
                    "");

        if (emit.isDone) return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future sendMail(
    String recipientEmail,
    String subject,
    String body,
  ) {
    var emailLaunchUri = Uri(
        scheme: "mailto",
        path: recipientEmail,
        query: HelperFunction.instance.encodeQueryParameters(<String, String>{
          'subject': subject,
          'body': body,
        }));

    return launchUrl(emailLaunchUri);
  }

  Future sendSms(String mobilePhone, String content) {
    var smsLaunchUri = Uri(
        scheme: "sms",
        path: mobilePhone,
        queryParameters: <String, String>{'body': content});

    return launchUrl(smsLaunchUri);
  }
}
