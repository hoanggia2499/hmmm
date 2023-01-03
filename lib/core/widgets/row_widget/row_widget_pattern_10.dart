import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

import 'common/textfield_border.dart';

// Row has title on left side and trailing right side
class RowWidgetPattern10 extends StatefulWidget {
  final String initValue;
  final Function(String)? onTextChange;
  final String textStr;
  final bool requiredField;

  RowWidgetPattern10(
      {required this.onTextChange,
      required this.textStr,
      this.initValue = '',
      this.requiredField = false});

  @override
  _RowWidgetPattern10State createState() => _RowWidgetPattern10State();
}

class _RowWidgetPattern10State extends State<RowWidgetPattern10> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    //Left/Right: 3/7
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

  _buildRightSideWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: TextFieldBorder(
              isKeyboardNumber: true,
              onSelectEvent: () {},
              initValue: widget.initValue,
              height: Dimens.getHeight(30.0),
              onTextChange: (String value) {
                widget.onTextChange?.call(value);
              }),
        ),
        SizedBox(
          width: Dimens.getWidth(20.0),
        ),
        Expanded(
          flex: 3,
          child: TextWidget(label: "km"),
        )
      ],
    );
  }
}
