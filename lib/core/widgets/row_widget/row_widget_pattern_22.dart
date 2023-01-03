import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';

class RowWidgetPattern22 extends StatefulWidget {
  final String textBtnLeft;
  final String textBtnCenter;
  final String textBtnRight;
  final bool editFlag;
  final Function() onClickBtnLeft;
  final Function() onClickBtnCenter;
  final Function() onClickBtnRight;

  RowWidgetPattern22(
      {required this.textBtnLeft,
      required this.textBtnCenter,
      required this.textBtnRight,
      required this.onClickBtnLeft,
      required this.onClickBtnCenter,
      required this.onClickBtnRight,
      this.editFlag = true});

  @override
  _RowWidgetPattern22State createState() => _RowWidgetPattern22State();
}

class _RowWidgetPattern22State extends State<RowWidgetPattern22> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            content: widget.textBtnLeft,
            borderRadius: 5.0,
            textStyle:
                MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
            clickButtonCallBack: widget.onClickBtnLeft,
            bgdColor: ResourceColors.color_00E927,
            borderColor: ResourceColors.color_00E927,
            heightText: 1.2,
          ),
        ),
        SizedBox(width: Dimens.getWidth(10.0)),
        Expanded(
          child: ButtonWidget(
            content: widget.textBtnCenter,
            borderRadius: 5.0,
            textStyle:
                MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
            clickButtonCallBack: widget.onClickBtnCenter,
            bgdColor: widget.editFlag
                ? ResourceColors.iconGrayColor
                : ResourceColors.color_F20C0C,
            borderColor: widget.editFlag
                ? ResourceColors.iconGrayColor
                : ResourceColors.color_F20C0C,
            heightText: 1.2,
          ),
        ),
        SizedBox(width: Dimens.getWidth(10.0)),
        Expanded(
          flex: 2,
          child: ButtonWidget(
            content: widget.textBtnRight,
            borderRadius: 5.0,
            textStyle: MKStyle.t12R.copyWith(
              color: ResourceColors.color_FFFFFF,
              fontWeight: FontWeight.w500,
            ),
            clickButtonCallBack: widget.onClickBtnRight,
            bgdColor: ResourceColors.text_light_blue,
            borderColor: ResourceColors.text_light_blue,
            heightText: 1.2,
          ),
        ),
      ],
    );
  }
}
