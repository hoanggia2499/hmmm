import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/dropdown_button_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

// Text button row
class RowWidgetPattern6 extends StatefulWidget {
  final String initValue;
  final String textStr;
  final String? textBtn;
  final bool requiredField;
  final bool isPattern7;
  final int typePattern;
  final VoidCallback? btnCallBack;

  RowWidgetPattern6(
      {this.initValue = '',
      required this.textStr,
      this.textBtn,
      this.isPattern7 = false,
      this.btnCallBack,
      this.typePattern = 6,
      this.requiredField = false});

  @override
  _RowWidgetPattern6State createState() => _RowWidgetPattern6State();
}

class _RowWidgetPattern6State extends State<RowWidgetPattern6> {
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

  _buildRightSideWidget() {
    return Row(
      children: [
        Expanded(
          flex: widget.isPattern7 ? 1 : 6, // Pattern 7 is 100%, else 6/7
          child: DropDownButtonWidget(
            typePattern: widget.typePattern,
            content: widget.textBtn!,
            clickButtonCallBack: () {
              widget.btnCallBack!.call();
            },
          ),
        ),
        Visibility(
            visible: !widget.isPattern7,
            child: Expanded(
              flex: 2,
              child: Container(),
            ))
      ],
    );
  }
}
