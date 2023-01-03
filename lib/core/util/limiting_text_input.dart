import 'dart:math';

import 'package:flutter/services.dart';

class LimitingTextInputFormatter extends TextInputFormatter {
  LimitingTextInputFormatter(this.maxLength) : assert(maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // When input is composing then will not count on max length
    if (newValue.composing.isCollapsed) {
      if (maxLength > 0 && newValue.text.length > maxLength) {
        // If already at the maximum and tried to enter even more, keep the old value.
        if (oldValue.text.length == maxLength) {
          return oldValue;
        }
        return truncate(newValue, maxLength);
      }
    }

    return newValue;
  }

  TextEditingValue truncate(TextEditingValue value, int maxLength) {
    var newValue = '';
    if (value.text.length > maxLength) {
      newValue = value.text.substring(0, maxLength);
    }
    return TextEditingValue(
      text: newValue,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, newValue.length),
        extentOffset: min(value.selection.end, newValue.length),
      ),
      composing: TextRange.empty,
    );
  }
}
