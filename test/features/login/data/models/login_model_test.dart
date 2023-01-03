import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';

void main() {
  group('LoginModel Tests', () {
    test('Should not throw an exception .', () {
      String jsonTiles = '{'
          '"accessToken": "AccessToken",'
          '"refreshToken": "RefreshToken",'
          '"memberNum": "MemberNum",'
          '"userNum": 0,'
          '"tel": "Tel",'
          '"storeName": "StoreName",'
          '"storeName2": "StoreName2",'
          '"logoMark": "LogoMark"'
          '}';
      expect(
        () => {LoginModel.fromJson(jsonDecode(jsonTiles))},
        returnsNormally,
      );
    });

    test('Should be able to deserialize an login model.', () {
      String jsonTiles = '{'
          '"accessToken": "AccessToken",'
          '"refreshToken": "RefreshToken",'
          '"memberNum": "MemberNum",'
          '"userNum": 0,'
          '"tel": "Tel",'
          '"storeName": "StoreName",'
          '"storeName2": "StoreName2",'
          '"logoMark": "LogoMark"'
          '}';

      var loginInfo = LoginModel.fromJson(jsonDecode(jsonTiles));

      expect(loginInfo.accessToken, "AccessToken");
      expect(loginInfo.refreshToken, "RefreshToken");
      expect(loginInfo.memberNum, "MemberNum");
      expect(loginInfo.userNum, 0);
      expect(loginInfo.tel, "Tel");
      expect(loginInfo.storeName, "StoreName");
      expect(loginInfo.storeName2, "StoreName2");
      expect(loginInfo.logoMark, "LogoMark");
    });
  });
}
