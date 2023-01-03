import 'package:mirukuru/core/config/common.dart';

class InviteFriendResponseModel {
  String? invitationMailSubject;
  String? invitationMailBody;
  String? invitationSmsMailBody;

  InviteFriendResponseModel(
      {this.invitationMailSubject = '',
      this.invitationMailBody = '',
      this.invitationSmsMailBody = ''});

  InviteFriendResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["invitationMailSubject"] is String) {
      this.invitationMailSubject = json["invitationMailSubject"] ?? "";
    }
    if (json["invitationMailBody"] is String) {
      this.invitationMailBody = json["invitationMailBody"] ?? "";
    }
    if (json["invitationSMSMailBody"] is String) {
      this.invitationSmsMailBody = json["invitationSMSMailBody"] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["invitationMailSubject"] = this.invitationMailSubject;
    data["invitationMailBody"] = this.invitationMailBody;
    data["invitationSMSMailBody"] = this.invitationSmsMailBody;
    return data;
  }

  String generateInviteContent(
      bool isMail, String storeName, String inviteCode) {
    String inviteUrl = "${Common.apSrvURL}/r/$inviteCode";
    String body =
        (isMail ? this.invitationMailBody : this.invitationSmsMailBody) ?? "";
    return "$storeName$body\n\n$inviteUrl";
  }
}
