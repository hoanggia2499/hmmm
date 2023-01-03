import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/features/favorite_list/data/models/price_model.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';

class HelperFunction {
  static final HelperFunction instance = HelperFunction._internal();

  factory HelperFunction() {
    return instance;
  }

  HelperFunction._internal() {
    // Implement code
  }

  Future saveJwt(String accessToken, String refreshToken) async {
    await UserSecureStorage.instance.setAccessToken(accessToken);
    await UserSecureStorage.instance.setRefreshToken(refreshToken);
  }

  Future removeJwt() async {
    await UserSecureStorage.instance.deleteAccessToken();
    await UserSecureStorage.instance.deleteRefreshToken();
  }

  // Save Token
  Future saveToken(String accessToken, String refreshToken) async {
    await UserSecureStorage.instance.setAccessToken(accessToken);
    await UserSecureStorage.instance.setRefreshToken(refreshToken);
  }

  // Save login model
  Future saveLoginModel(LoginModel loginModel) async {
    await UserSecureStorage.instance.setMemberNum(loginModel.memberNum);
    await UserSecureStorage.instance.setUserNum(loginModel.userNum.toString());
    await UserSecureStorage.instance.setTel(loginModel.tel);
    await UserSecureStorage.instance.setStoreName(loginModel.storeName);
    await UserSecureStorage.instance.setStoreName2(loginModel.storeName2);
    await UserSecureStorage.instance.setLogoMark(loginModel.logoMark);
  }

  // Remove login model
  Future removeLoginModel() async {
    await UserSecureStorage.instance.removeMemberNum();
    await UserSecureStorage.instance.removeUserNum();
    await UserSecureStorage.instance.removeTel();
    await UserSecureStorage.instance.removeStoreName();
    await UserSecureStorage.instance.removeStoreName2();
    await UserSecureStorage.instance.removeLogoMark();
  }

  // get login model
  Future getLoginModel() async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '0';
    var tel = await UserSecureStorage.instance.getTel() ?? '';
    var storeName = await UserSecureStorage.instance.getStoreName() ?? '';
    var storeName2 = await UserSecureStorage.instance.getStoreName2() ?? '';
    var logoMark = await UserSecureStorage.instance.getLogoMark() ?? '';
    var accessToken = await UserSecureStorage.instance.getAccessToken() ?? '';
    var refreshToken = await UserSecureStorage.instance.getRefreshToken() ?? '';

    var loginModel = LoginModel(
      memberNum: memberNum,
      userNum: int.parse(userNum),
      tel: tel,
      storeName: storeName,
      storeName2: storeName2,
      logoMark: logoMark,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return loginModel;
  }

  // Set tel company
  Future saveTelCompany(String tel) async {
    await UserSecureStorage.instance.setTelCompany(tel);
  }

  // Set Is terms accepted
  Future saveIsTermsAccepted() async {
    await UserSecureStorage.instance.setIsTermsAccepted();
  }

  getImageUrl(String fullExhNum, String corner, Map<String, String> pic1Map) {
    String getFullExhNum = fullExhNum;
    String middleStr = getFullExhNum.substring(0, 4);
    String getCorner = corner;
    return "https://imgml.asnet2.com/ASDATA/" +
        getCorner +
        "/M/0000" +
        middleStr +
        "/" +
        getCorner +
        getFullExhNum +
        pic1Map[getCorner].toString() +
        ".jpg";
  }

  String getFrontImageUrl(String fullExhNum, String corner) {
    String middleStr = fullExhNum.substring(0, 4);
    return "https://imgml.asnet2.com/ASDATA/" +
        corner +
        "/M/0000" +
        middleStr +
        "/" +
        corner +
        fullExhNum +
        "f" +
        ".jpg";
  }

  PriceModel getPrice(int price) {
    int allPrice = price;
    String priceValue;
    String priceValue2;
    String yen;

    double priceDouble = double.parse(allPrice.toString());
    double dividedPriceDouble = priceDouble / 10000;

    Decimal bd = Decimal.parse(dividedPriceDouble.toString());
    var bd2 = bd.round(scale: 1);

    double doubleAllPrice = double.parse(bd2.toString());

    String doubleAllPriceStr = doubleAllPrice.toString();
    var st = doubleAllPriceStr.split(".");

    //分割した文字を取得
    String firstStr = st[0];
    String secondStr = st[1];

    if (firstStr != "0") {
      priceValue = "" + firstStr;
      priceValue2 = "." + secondStr;
    } else {
      priceValue = "ーー";
      priceValue2 = "";
    }

    if (firstStr == "0" && secondStr == "0") {
      yen = "  ";
    } else {
      yen = "万円";
    }

    return PriceModel(price: priceValue, price2: priceValue2, yen: yen);
  }

  /// 数値の西暦から和暦を取得する
  /// @return
  String getJapanYearFromAd(int adYear) {
    if (adYear > 2018) {
      //令和の場合
      return "R" + (adYear - 2018).toString() + "YEAR".tr();
    } else if (adYear > 1988) {
      //平成の場合
      return "H" + (adYear - 1988).toString() + "YEAR".tr();
    } else if (adYear > 1925) {
      //昭和の場合
      return "S" + (adYear - 1925).toString() + "YEAR".tr();
    } else {
      return "";
    }
  }

  String getJapanYearFromAdWithResultString(String result) {
    int yearNHokenEndDay = int.parse(result.substring(0, 4));
    int monthNHokenEndDay = int.parse(result.substring(4, 6));
    int dayNHokenEndDay = int.parse(result.substring(6, 8));
    String strYear = getJapanYearFromAd(yearNHokenEndDay);
    if (strYear == '') {
      return "";
    }
    return strYear +
        monthNHokenEndDay.toString() +
        "MONTH".tr() +
        dayNHokenEndDay.toString() +
        "DAY".tr();
  }

  String getJapanYearFormat(String year) {
    //C&G&H = J
    int inspectionMiddleYear = int.parse(year.substring(0, 4));
    int inspectionMonth = int.parse(year.substring(4, 6));

    String strYear = getJapanYearFromAd(inspectionMiddleYear);
    if (strYear == '') {
      return "";
    }
    return strYear + inspectionMonth.toString() + "MONTH".tr();
  }

  String formatJapanDate(DateTime date) {
    var jpnYear = getJapanYearFromAd(date.year);
    var jpnMonth =
        date.month.toString().padLeft(2 - (date.month < 10 ? 1 : 2), "0");
    var jpnDay = date.day.toString().padLeft(2 - (date.day < 10 ? 1 : 2), "0");

    return "$jpnYear$jpnMonth${'MONTH'.tr()}$jpnDay${'DAY'.tr()}";
  }

  String formatJapanDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "";
    }

    try {
      var date = DateFormat("yyyy/MM/dd HH:mm:ss").parseStrict(dateString);
      if (date != null) {
        var jpnYear = getJapanYearFromAd(date.year);
        var jpnMonth =
            date.month.toString().padLeft(2 - (date.month < 10 ? 1 : 2), "0");
        var jpnDay =
            date.day.toString().padLeft(2 - (date.day < 10 ? 1 : 2), "0");

        return "$jpnYear$jpnMonth${'MONTH'.tr()}$jpnDay${'DAY'.tr()}";
      }
    } on FormatException {
      return "";
    } catch (e) {
      return "";
    }
    return "";
  }

  static DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  /// Parse date format "yyyMMdd" to DateTime
  DateTime parseDateString(String dateString) {
    String newInput =
        "${dateString.substring(0, 4)}/${dateString.substring(4, 6)}/${dateString.substring(6, 8)}";
    return Intl.withLocale('en', () => dateFormat.parse(newInput));
  }

  bool isSoftKeyBoardVisible(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom > 0;

  String generateRandomString(
      {String letters =
          "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"}) {
    Random rnd = new Random();
    String letter = "";
    String result = "";
    for (int i = 0; i < 5; i++) {
      int ran = rnd.nextInt(61);
      letter = letters.substring(ran, ran + 1);
      result += "" + letter;
    }
    return result;
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  String formatZipCode(String zipCodeInput) {
    // Example: 4880839 -> 488-0839
    if (zipCodeInput.length == 7) {
      var zip1 = zipCodeInput.substring(0, 3);
      var zip2 = zipCodeInput.substring(3, 7);
      return "$zip1-$zip2";
    }
    return "";
  }

  String formatRealUrl(String url, dynamic data) {
    String realUrl = url;
    if (data != null) {
      if (data is Map<String, List<String>>) {
        var mapData = data;
        for (var item in mapData.entries) {
          item.value.forEach((element) {
            if (realUrl == url) {
              realUrl += '?${item.key}=${element.toString()}';
            } else {
              realUrl += '&${item.key}=${element.toString()}';
            }
          });
        }
      } else if (data is Map<String, dynamic>) {
        var mapData = data;
        for (var item in mapData.entries) {
          if (realUrl == url) {
            realUrl += '?${item.key}=${item.value}';
          } else {
            realUrl += '&${item.key}=${item.value}';
          }
        }
      }
    }

    return realUrl;
  }

  String formatPhoneNumber(String phoneNumInput) {
    // Example: 8888008203 => 888-800-8203
    if (phoneNumInput.length == 10) {
      return "${phoneNumInput.substring(0, 3)}-${phoneNumInput.substring(3, 6)}-${phoneNumInput.substring(6)}";
    }
    return phoneNumInput;
  }

  bool checkIfJpnPhoneNumber(String phoneNumInput) {
    if (phoneNumInput.length > 0) {
      return phoneNumInput.startsWith("070") ||
          phoneNumInput.startsWith("080") ||
          phoneNumInput.startsWith("090");
    }
    return false;
  }
}
