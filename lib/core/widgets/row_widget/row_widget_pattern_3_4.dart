import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';
import '../common/divider_no_text.dart';
import 'common/textfield_border.dart';

// Row input with required mark or not
class RowWidgetPattern3 extends StatefulWidget {
  final String initValue;
  final Function(String)? onTextChange;
  final String textStr;
  final bool requiredField;
  final GlobalKey keys;

  RowWidgetPattern3({
    required this.onTextChange,
    required this.textStr,
    required this.keys,
    this.initValue = '',
    this.requiredField = false,
  });
  @override
  _RowWidgetPattern3State createState() => _RowWidgetPattern3State();
}

class _RowWidgetPattern3State extends State<RowWidgetPattern3> {
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
          flex: 20,
          child: TextFieldBorder(
              keys: widget.keys,
              onSelectEvent: () {},
              initValue: widget.initValue,
              height: Dimens.getHeight(30.0),
              onTextChange: (String value) {
                widget.onTextChange?.call(value);
              }),
        ),
      ],
    );
  }
}
