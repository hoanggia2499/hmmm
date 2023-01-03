import 'package:flutter/services.dart';

class InputMonthFormatter extends TextInputFormatter {
  InputMonthFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var oldLength = oldValue.text.length;
    var newLength = newValue.text.length;
    if (newLength - oldLength < 0) {
      return newValue;
    }
    String findObject = monthInYear.firstWhere(
        (element) => element.startsWith(newValue.text),
        orElse: () => '');
    print('match value is $findObject');
    if (findObject.isEmpty) {
      return TextEditingValue(text: '');
    } else {
      return TextEditingValue(
          text: findObject,
          selection:
              TextSelection(baseOffset: newValue.text.length, extentOffset: 3));
    }
  }

  List<String> monthInYear = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}
