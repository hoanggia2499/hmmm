import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

import 'common/textfield_border.dart';

// Post code input row pattern
class RowWidgetPattern5 extends StatefulWidget {
  final String initValue;
  final Function(String)? onTextChangeFirst;
  final Function(String)? onTextChangeSecond;
  final String textStr;
  final bool requiredField;
  final int? maxLines;

  RowWidgetPattern5(
      {this.initValue = '',
      this.maxLines,
      this.onTextChangeFirst,
      this.onTextChangeSecond,
      required this.textStr,
      this.requiredField = false});

  @override
  _RowWidgetPattern5State createState() => _RowWidgetPattern5State();
}

class _RowWidgetPattern5State extends State<RowWidgetPattern5> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: LeftSideWidget(
              textStr: widget.textStr,
              requiredField: widget.requiredField,
            )),
        Expanded(flex: 7, child: _buildRightSideWidget())
      ],
    );
  }

  Widget _buildRightSideWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFieldBorder(
            maxLength: 3,
            isKeyboardNumber: true,
            maxLines: widget.maxLines,
            width: Dimens.getWidth(60.0),
            height: Dimens.getHeight(30.0),
            onSelectEvent: () {},
            initValue: widget.initValue,
            onTextChange: (String value) {
              widget.onTextChangeFirst?.call(value);
            }),
        TextWidget(label: "  -  "),
        TextFieldBorder(
            maxLength: 4,
            isKeyboardNumber: true,
            maxLines: widget.maxLines,
            width: Dimens.getWidth(80.0),
            height: Dimens.getHeight(30.0),
            onSelectEvent: () {},
            initValue: widget.initValue,
            onTextChange: (String value) {
              widget.onTextChangeSecond?.call(value);
            }),
      ],
    );
  }
}
