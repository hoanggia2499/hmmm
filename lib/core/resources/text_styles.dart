import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';

//=========Use===========
//Ex: MKStyle.t14R
//use copyWith()
//return a new object with the same properties as the original, but with the values you specify
class MKStyle {
  static TextStyle t6R = getStyleNormal(DimenFont.sp6);
  static TextStyle t6B = getStyleBold(DimenFont.sp6);
  static TextStyle t8R = getStyleNormal(DimenFont.sp8);
  static TextStyle t8B = getStyleBold(DimenFont.sp8);
  static TextStyle t9R = getStyleNormal(DimenFont.sp9);
  static TextStyle t9B = getStyleBold(DimenFont.sp9);
  static TextStyle t10R = getStyleNormal(DimenFont.sp10);
  static TextStyle t10B = getStyleBold(DimenFont.sp10);
  static TextStyle t11R = getStyleNormal(DimenFont.sp11);
  static TextStyle t11B = getStyleBold(DimenFont.sp11);
  static TextStyle t12R = getStyleNormal(DimenFont.sp12);
  static TextStyle t12B = getStyleBold(DimenFont.sp12);
  static TextStyle t14R = getStyleNormal(DimenFont.sp14);
  static TextStyle t14B = getStyleBold(DimenFont.sp14);
  static TextStyle t16R = getStyleNormal(DimenFont.sp16);
  static TextStyle t16B = getStyleBold(DimenFont.sp16);
  static TextStyle t15R = getStyleNormal(DimenFont.sp15);
  static TextStyle t15B = getStyleBold(DimenFont.sp15);
  static TextStyle t17R = getStyleNormal(DimenFont.sp17);
  static TextStyle t17B = getStyleBold(DimenFont.sp17);
  static TextStyle t18R = getStyleNormal(DimenFont.sp18);
  static TextStyle t18B = getStyleBold(DimenFont.sp18);
  static TextStyle t20R = getStyleNormal(DimenFont.sp20);
  static TextStyle t20B = getStyleBold(DimenFont.sp20);
  static TextStyle t25R = getStyleNormal(DimenFont.sp25);
  static TextStyle t25B = getStyleBold(DimenFont.sp25);
  static TextStyle t30R = getStyleNormal(DimenFont.sp30);
  static TextStyle t30B = getStyleBold(DimenFont.sp30);
  static TextStyle t32R = getStyleNormal(DimenFont.sp32);
  static TextStyle t32B = getStyleBold(DimenFont.sp32);

  static TextStyle getStyleNormal(double inSize) {
    return TextStyle(
        fontSize: inSize,
        fontWeight: FontWeight.normal,
        color: ResourceColors.color_000000,
        fontFamily: 'NotoSansJPRegular',
        overflow: TextOverflow.visible);
  }

  static TextStyle getStyleBold(double inSize) {
    return TextStyle(
        fontSize: inSize,
        fontWeight: FontWeight.bold,
        color: ResourceColors.color_000000,
        fontFamily: 'NotoSansJPRegular',
        overflow: TextOverflow.visible);
  }
}
