import 'package:flustars_flutter3/flustars_flutter3.dart';

class DimenFont {
  static double tiny = getFontSize(8);
  static double small = getFontSize(10);
  static double normal = getFontSize(12);
  static double middle = getFontSize(14);
  static double large = getFontSize(16);
  static double huge = getFontSize(18);
  static double sp1 = getFontSize(1);
  static double sp2 = getFontSize(2);
  static double sp3 = getFontSize(3);
  static double sp6 = getFontSize(6);
  static double sp7 = getFontSize(7);
  static double sp8 = getFontSize(7);
  static double sp9 = getFontSize(9);
  static double sp10 = getFontSize(10);
  static double sp11 = getFontSize(11);
  static double sp12 = getFontSize(12);
  static double sp13 = getFontSize(13);
  static double sp14 = getFontSize(14);
  static double sp15 = getFontSize(15);
  static double sp16 = getFontSize(16);
  static double sp17 = getFontSize(17);
  static double sp18 = getFontSize(18);
  static double sp20 = getFontSize(20);
  static double sp22 = getFontSize(22);
  static double sp24 = getFontSize(24);
  static double sp25 = getFontSize(25);
  static double sp28 = getFontSize(28);
  static double sp30 = getFontSize(30);
  static double sp32 = getFontSize(32);
  static double sp36 = getFontSize(36);
  static double sp38 = getFontSize(38);
  static double sp40 = getFontSize(40);

  static double getFontSize(double inSize) {
    return ScreenUtil.getInstance().getSp(inSize);
  }
}

class Dimens {
  static double getSize(double size, {bool isFit = true}) {
    return (isFit ? ScreenUtil.getInstance().getAdapterSize(size) : size);
  }

  static double getHeight(double size, {bool isFit = true}) {
    return (isFit ? ScreenUtil.getInstance().getHeight(size) : size);
  }

  static double getWidth(double size) {
    return ScreenUtil.getInstance().getWidth(size);
  }
}
