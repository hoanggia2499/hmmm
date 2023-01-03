import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

enum RadioWidgetStyle {
  STYLE_1, // Radio have circle shape inside when checked
  STYLE_2 // Radio don't have circle shape inside when checked
}

class RadioWidget extends StatefulWidget {
  final int currentChoice;
  final int currentRow;
  final Function(int) callBack;
  final String value;
  Color? indicatorColor;
  double? spaceBetweenButtonAndLabel;
  double? thumbWidth;
  Color? thumbColor;
  RadioWidgetStyle? style;

  RadioWidget(
      {required this.currentRow,
      required this.currentChoice,
      required this.callBack,
      required this.value,
      Color? indicatorColor,
      double? spaceBetweenButtonAndLabel,
      double? thumbWidth,
      Color? thumbColor,
      this.style = RadioWidgetStyle.STYLE_1})
      : this.indicatorColor =
            indicatorColor != null ? indicatorColor : ResourceColors.green_bg,
        this.spaceBetweenButtonAndLabel = spaceBetweenButtonAndLabel != null
            ? spaceBetweenButtonAndLabel
            : Dimens.getWidth(5.0),
        this.thumbColor = thumbColor != null ? thumbColor : Colors.grey,
        this.thumbWidth = thumbWidth != null ? thumbWidth : 2.0;

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainRadio(),
        // DividerNoText()
      ],
    );
  }

  Widget _buildMainRadio() {
    return InkWell(
      onTap: () => widget.callBack.call(widget.currentRow),
      customBorder: const StadiumBorder(),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimens.getWidth(8.0), vertical: Dimens.getHeight(5.0)),
        child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: widget.thumbColor!, width: widget.thumbWidth!),
                  color: ResourceColors.color_white),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimens.getHeight(4.0),
                    horizontal: Dimens.getWidth(4.0)),
                child: Icon(
                  Icons.circle,
                  color: isCheckRadio()
                      ? widget.indicatorColor
                      : (widget.style == RadioWidgetStyle.STYLE_1
                          ? Colors.grey
                          : ResourceColors.color_white),
                  size: DimenFont.sp10,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: widget.spaceBetweenButtonAndLabel!),
              child: TextWidget(
                textStyle:
                    MKStyle.t12R.copyWith(color: ResourceColors.color_000000),
                label: widget.value,
              ),
            ),
          ],
        ),
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
