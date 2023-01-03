import 'package:flutter/services.dart';

class InputDayFormatter extends TextInputFormatter {
  final int maxDateofMonth;
  InputDayFormatter(this.maxDateofMonth);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.trim().isNotEmpty) {
      var tryParseValue = int.tryParse(newValue.text);
      if (tryParseValue == null) {
        return oldValue;
      }
      int intNewValue = int.parse(newValue.text);
      if (intNewValue <= maxDateofMonth) {
        return newValue;
      } else {
        return oldValue;
      }
    } else {
      return newValue;
    }
  }
}
