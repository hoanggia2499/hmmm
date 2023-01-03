class MyPageRequestModel {
  String memberNum;
  int userNum;

  MyPageRequestModel({
    required this.memberNum,
    required this.userNum,
  });

  @override
  String toString() =>
      'MyPageRequestModel(memberNum: $memberNum, userNum: $userNum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyPageRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum;
  }

  @override
  int get hashCode => memberNum.hashCode ^ userNum.hashCode;
}
