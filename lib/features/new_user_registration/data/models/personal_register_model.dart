class PersonalRegisterModel {
  PersonalRegisterModel({
    this.memberNum = '',
    this.userNum = 0,
  });

  final String memberNum;
  final int userNum;

  factory PersonalRegisterModel.fromJson(Map<String, dynamic> json) {
    return PersonalRegisterModel(
      memberNum: json['memberNum'] ?? '',
      userNum: json['userNum'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
    };
  }
}
