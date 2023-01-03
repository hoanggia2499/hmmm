import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/widgets/common/custom_check_box.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

// Check box row with 2 lines title
class RowWidgetPattern1 extends StatefulWidget {
  const RowWidgetPattern1(
      {required this.mainTitle,
      required this.subTitle,
      this.initValue = false,
      this.onCheckChanged,
      this.flexRightContent = 9,
      this.isFromCarRegist = false,
      this.displayDivider = true,
      this.backgroundColor = ResourceColors.color_FFFFFF});

  final String mainTitle;
  final String subTitle;
  final bool initValue;
  final Function(bool?)? onCheckChanged;
  final int flexRightContent;
  final bool displayDivider;
  final bool isFromCarRegist;
  final Color backgroundColor;

  @override
  RowWidgetPattern1State createState() => RowWidgetPattern1State();
}

class RowWidgetPattern1State extends State<RowWidgetPattern1> {
  bool checked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      checked = widget.initValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResourceColors.color_white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
              onTap: () => onCheckChanged(!checked),
              highlightColor: Colors.orange,
              splashColor: Colors.orange,
              child: Container(
                color: widget.backgroundColor,
                padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(10.0)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Dimens.getWidth(10.0),
                  ),
                  child: Row(
                    children: [
                      Visibility(
                        visible: widget.isFromCarRegist == true ? false : true,
                        child: Expanded(
                          child: _buildCheckBox(),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: widget.flexRightContent,
                        child: _buildTitle(),
                      )
                    ],
                  ),
                ),
              )),
          Visibility(
            visible: widget.displayDivider,
            child: Container(
              height: Dimens.getSize(0.5),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox() {
    return CustomCheckbox(
      value: checked,
      selectedIconColor: Colors.green,
      borderColor: Colors.grey,
      size: DimenFont.sp28,
      iconSize: DimenFont.sp25,
      onChange: onCheckChanged,
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          label: widget.mainTitle,
          textStyle: MKStyle.t12B.copyWith(color: ResourceColors.color_757575),
        ),
        Visibility(
          visible: widget.isFromCarRegist == true ? false : true,
          child: TextWidget(
            label: widget.subTitle,
            textStyle:
                MKStyle.t10R.copyWith(color: ResourceColors.color_757575),
          ),
        )
      ],
    );
  }

  void onCheckChanged(bool? value) {
    setState(() {
      checked = value ?? false;
    });
    widget.onCheckChanged?.call(value);
  }
}
