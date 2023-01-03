import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String memberNum;
  final int userNum;
  final String tel;
  final String storeName; //店舗名上段
  final String storeName2; //店舗名下段
  final String logoMark;

  const LoginEntity({
    this.accessToken = '',
    this.refreshToken = '',
    this.memberNum = '',
    this.userNum = 0,
    this.tel = '',
    this.storeName = '',
    this.storeName2 = '',
    this.logoMark = '',
  });

  @override
  List<Object> get props => [
        accessToken,
        refreshToken,
        memberNum,
        userNum,
        tel,
        storeName,
        storeName2,
        logoMark
      ];
}
