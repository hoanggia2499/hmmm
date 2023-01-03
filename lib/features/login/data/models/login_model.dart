class LoginModel {
  const LoginModel(
      {this.accessToken = '',
      this.refreshToken = '',
      this.memberNum = '',
      this.userNum = 0,
      this.tel = '',
      this.storeName = '',
      this.storeName2 = '',
      this.logoMark = ''});

  final String accessToken;
  final String refreshToken;
  final String memberNum;
  final int userNum;
  final String tel;
  final String storeName;
  final String storeName2;
  final String logoMark;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      memberNum: json['memberNum'] ?? '',
      userNum: (json['userNum'] ?? 0),
      tel: (json['tel'] ?? ''),
      storeName: (json['storeName'] ?? ''),
      storeName2: (json['storeName2'] ?? ''),
      logoMark: (json['logoMark'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'memberNum': memberNum,
      'userNum': userNum,
      'tel': tel,
      'storeName': storeName,
      'storeName2': storeName2,
      'logoMark': logoMark,
    };
  }
}
