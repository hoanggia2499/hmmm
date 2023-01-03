import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class ItemRadioWidget extends StatefulWidget {
  final int currentChoice;
  final int currentRow;
  final Function(int) callBack;
  final String value;
  final bool isCheckLastRow;

  ItemRadioWidget({
    required this.currentRow,
    required this.currentChoice,
    required this.callBack,
    required this.value,
    required this.isCheckLastRow,
  });

  @override
  _ItemRadioWidgetState createState() => _ItemRadioWidgetState();
}

class _ItemRadioWidgetState extends State<ItemRadioWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainRadio(),
          Visibility(
            visible: !widget.isCheckLastRow,
            child: DividerNoText(
              indent: 0.0,
              endIndent: 0.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainRadio() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        widget.callBack.call(widget.currentRow);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimens.getHeight(10.0),
                horizontal: Dimens.getWidth(10.0)),
            child: TextWidget(
              textStyle: MKStyle.t12R,
              label: widget.value,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: Dimens.getHeight(10.0),
                horizontal: Dimens.getWidth(10.0)),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
                color: ResourceColors.color_white),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimens.getHeight(4.0),
                  horizontal: Dimens.getWidth(4.0)),
              child: Icon(
                Icons.circle,
                color: isCheckRadio() ? ResourceColors.green_bg : Colors.grey,
                size: DimenFont.sp10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isCheckRadio() {
    if (widget.currentChoice == widget.currentRow) {
      return true;
    } else {
      return false;
    }
  }
}
