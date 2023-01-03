import '../../../../core/util/helper_function.dart';

class InviteFriendRequestModel {
  String? memberNum;
  int? inviteUserNum;
  String? email;
  String? mobilePhone;
  String? inviteCode;
  String? isMail; // "1" - Email; "0" - Mobile Phone

  InviteFriendRequestModel(
      {this.memberNum = '',
      this.inviteUserNum = -1,
      this.email = '',
      this.mobilePhone = '',
      this.inviteCode = '',
      this.isMail = ''});

  InviteFriendRequestModel.createFrom(
      {this.memberNum,
      this.inviteUserNum,
      this.email,
      this.mobilePhone,
      bool isMail = true})
      : this.inviteCode = HelperFunction.instance.generateRandomString(),
        this.isMail = isMail ? "1" : "0";

  InviteFriendRequestModel.fromJson(Map<String, dynamic> json) {
    if (json["memberNum"] is String) {
      this.memberNum = json["memberNum"];
    }
    if (json["inviteUserNum"] is String) {
      this.inviteUserNum = json["inviteUserNum"];
    }
    if (json["email"] is String) {
      this.email = json["email"];
    }
    if (json["mobilePhone"] is String) {
      this.mobilePhone = json["mobilePhone"];
    }
    if (json["inviteCode"] is String) {
      this.inviteCode = json["inviteCode"];
    }
    if (json["isMail"] is String) {
      this.isMail = json["isMail"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["memberNum"] = this.memberNum;
    data["inviteUserNum"] = this.inviteUserNum;
    data["email"] = this.email;
    data["mobilePhone"] = this.mobilePhone;
    data["inviteCode"] = this.inviteCode;
    data["isMail"] = this.isMail;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'inviteUserNum': inviteUserNum.toString(),
      'email': email,
      'mobilePhone': mobilePhone,
      'inviteCode': inviteCode,
      'isMail': isMail,
    };
  }

  factory InviteFriendRequestModel.fromMap(Map<String, dynamic> map) {
    return InviteFriendRequestModel(
      memberNum: map['memberNum'],
      inviteUserNum: map['inviteUserNum'],
      email: map['email'],
      mobilePhone: map['mobilePhone'],
      inviteCode: map['inviteCode'],
      isMail: map['isMail'],
    );
  }

  InviteFriendRequestModel copyWith({
    String? memberNum,
    int? inviteUserNum,
    String? email,
    String? mobilePhone,
    String? inviteCode,
    bool isMail = true,
  }) {
    return InviteFriendRequestModel(
      memberNum: memberNum ?? this.memberNum,
      inviteUserNum: inviteUserNum ?? this.inviteUserNum,
      email: email ?? this.email,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      inviteCode: inviteCode ?? this.inviteCode,
      isMail: isMail ? "1" : "0",
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InviteFriendRequestModel &&
        other.memberNum == memberNum &&
        other.inviteUserNum == inviteUserNum &&
        other.email == email &&
        other.mobilePhone == mobilePhone &&
        other.inviteCode == inviteCode &&
        other.isMail == isMail;
  }

  @override
  int get hashCode {
    return memberNum.hashCode ^
        inviteUserNum.hashCode ^
        email.hashCode ^
        mobilePhone.hashCode ^
        inviteCode.hashCode ^
        isMail.hashCode;
  }

  bool isEmail() => this.isMail == "1";
}
