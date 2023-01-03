class UserInfoRequestModel {
  String memberNum;
  int userNum;

  UserInfoRequestModel({
    required this.memberNum,
    required this.userNum,
  });

  @override
  String toString() =>
      'UserInfoRequestModel(memberNum: $memberNum, userNum: $userNum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfoRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum;
  }

  @override
  int get hashCode => memberNum.hashCode ^ userNum.hashCode;
}
