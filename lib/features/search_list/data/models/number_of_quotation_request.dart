class NumberOfQuotationRequestModel {
  String memberNum;
  int userNum;

  NumberOfQuotationRequestModel({
    required this.memberNum,
    required this.userNum,
  });

  @override
  String toString() =>
      'NumberOfQuotationRequestModel(memberNum: $memberNum, userNum: $userNum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NumberOfQuotationRequestModel &&
        other.memberNum == memberNum &&
        other.userNum == userNum;
  }

  @override
  int get hashCode => memberNum.hashCode ^ userNum.hashCode;
}
