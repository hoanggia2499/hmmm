import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/radio_widget.dart';
import 'package:mirukuru/core/widgets/common/slide_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class AnimatedRadioRowWidget extends StatefulWidget {
  AnimatedRadioRowWidget({
    required this.context,
    required this.currentRow,
    required this.currentChoice,
    required this.onRadioTappedCallback,
    required this.value,
    required this.onRowTappedCallback,
    Color? indicatorColor,
    double? spaceBetweenButtonAndLabel,
    double? thumbWidth,
    Color? thumbColor,
    this.style = RadioWidgetStyle.STYLE_1,
    this.isRadioShow = true,
  })  : this.indicatorColor =
            indicatorColor != null ? indicatorColor : ResourceColors.green_bg,
        this.spaceBetweenButtonAndLabel = spaceBetweenButtonAndLabel != null
            ? spaceBetweenButtonAndLabel
            : Dimens.getWidth(5.0),
        this.thumbColor = thumbColor != null ? thumbColor : Colors.grey,
        this.thumbWidth = thumbWidth != null ? thumbWidth : 2.0;

  final BuildContext context;
  final int currentChoice;
  final int currentRow;
  Color? indicatorColor;
  bool isRadioShow = true;
  final Function(int) onRadioTappedCallback;
  final Function(int) onRowTappedCallback;
  double? spaceBetweenButtonAndLabel;
  RadioWidgetStyle? style;
  Color? thumbColor;
  double? thumbWidth;
  final String value;

  @override
  State<AnimatedRadioRowWidget> createState() => _AnimatedRadioRowWidgetState();
}

class _AnimatedRadioRowWidgetState extends State<AnimatedRadioRowWidget> {
  Widget buildMainRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 9,
          fit: FlexFit.tight,
          child: HidableActionsWidget(
            isHiding: !widget.isRadioShow,
            slideOffset: Offset(-0.10, 0.0),
            child: InkWell(
              onTap: onRowTappedEventCallback,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimens.getHeight(10.0),
                    horizontal: Dimens.getWidth(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 10,
                      fit: FlexFit.tight,
                      child: _buildMainRadio(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(right: Dimens.getWidth(10.0)),
            child: _buildRightSideButton()),
      ],
    );
  }

  void onRowTappedEventCallback() {
    if (!widget.isRadioShow) {
      Logging.log.info("Row at position [${widget.currentRow}] tapped");
      widget.onRowTappedCallback(widget.currentRow);
    } else {
      Logging.log
          .info("Radio Button at position [${widget.currentRow}] tapped");
      widget.onRadioTappedCallback(widget.currentRow);
    }
  }

  Widget _buildMainRadio() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onRowTappedEventCallback,
            child: Container(
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
                  color: widget.currentChoice == widget.currentRow
                      ? widget.indicatorColor
                      : (widget.style == RadioWidgetStyle.STYLE_1
                          ? Colors.grey
                          : ResourceColors.color_white),
                  size: DimenFont.sp10,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.spaceBetweenButtonAndLabel!,
        ),
        Expanded(
          flex: 9,
          child: TextWidget(
            textStyle: MKStyle.t14R.copyWith(
                color: ResourceColors.color_333333,
                fontWeight: FontWeight.w500),
            label: widget.value,
            alignment: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildRightSideButton() {
    return HidableActionsWidget(
      isHiding: widget.isRadioShow,
      slideOffset: Offset(1.5, 0.0),
      animDuration: Duration(milliseconds: 280),
      child: Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/png/next.png",
          width: Dimens.getHeight(15.0),
          height: Dimens.getHeight(15.0),
          color: ResourceColors.color_757575,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildMainRow(),
        Divider(
          thickness: 2,
        )
      ],
    );
  }
}
