import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ZipCodeInputFormatter extends TextInputFormatter {
  // 104-0053
  String _placeholder = "...-....";
  TextEditingValue? _lastNewValue;
  static const INDEX_NOT_FOUND = -1;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    if (offset > _placeholder.length) {
      return oldValue;
    }

    if (offset < _placeholder.length) {
      _lastNewValue = newValue;
      return newValue.copyWith(
          text: _fillInputAccordingPlaceHolder(newValue.text));
    }

    if (oldValue.text == newValue.text && oldValue.text.length > 0) {
      return newValue.copyWith(
          text: _fillInputAccordingPlaceHolder(newValue.text));
    }

    // handle user editting according zipcode format
    // Case-1: User add new digit: replace '.' at cursor's position by user's input
    // Case-2: User delete digit: replace digit at cursor's position by '-' base on our format
    var oldText = oldValue.text;
    final String newText = newValue.text;
    String? resultText;

    int index = _indexOfDifference(newText, oldText);

    if (oldText.length < newText.length) {
      // Case-1: User add new digit
      String newChar = newText[index];
      if (index == 3) {
        index++;
        offset++;
      }
      if (offset == 3) {
        offset++;
      }

      if (index == _placeholder.length - 1)
        oldText = oldText.padRight(_placeholder.length, " ");

      resultText = oldText.replaceRange(index, index + 1, newChar);
    } else if (oldText.length > newText.length) {
      // Case-2: User delete digit
      if (oldText[index] != '-') {
        resultText = oldText.replaceRange(index, index + 1, '-');

        if (offset == 4) {
          // digit after "-" symbol
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    final dashes = resultText!.replaceAll(RegExp(r'[^-]'), "");
    int count = dashes.length;
    if (resultText.length > _placeholder.length ||
        count != 1 ||
        resultText[3].toString() != '-') {
      return oldValue;
    }

    return oldValue.copyWith(
        text: resultText,
        selection: TextSelection.collapsed(offset: offset),
        composing: defaultTargetPlatform == TargetPlatform.iOS
            ? TextRange(start: 0, end: 0)
            : TextRange.empty);
  }

  String? _fillInputAccordingPlaceHolder(String input) {
    // 123
    // 1235
    if (input.length > 3) {
      var zip1 = input.substring(0, 3);
      var zip2 = input.substring(4);

      return "$zip1-$zip2";
    }
    return input;
  }

  int _indexOfDifference(String? newText, String? oldText) {
    if (newText == oldText) return INDEX_NOT_FOUND;

    if (newText == null || oldText == null) return 0;

    int index;

    for (index = 0; index < newText.length && index < oldText.length; ++index) {
      if (newText[index] != oldText[index]) break;
    }

    if (index < oldText.length || index < newText.length) return index;

    return INDEX_NOT_FOUND;
  }
}
