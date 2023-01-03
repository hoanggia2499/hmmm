import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class SubTitle2 extends StatefulWidget {
  final String label;

  String? icon;
  Widget? iconWidget;
  TextStyle? textStyle;

  SubTitle2({Key? key, required this.label, this.icon = "", this.textStyle})
      : super(key: key);

  SubTitle2.withIconWidget(
      {Key? key, required this.label, required this.iconWidget, this.textStyle})
      : super(key: key);

  @override
  _SubTitle2State createState() => _SubTitle2State();
}

class _SubTitle2State extends State<SubTitle2> {
  @override
  Widget build(BuildContext context) {
    return _buildTitle(widget.label);
  }

  Widget _buildTitle(String label) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Dimens.getHeight(5.0), top: Dimens.getHeight(5.0)),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: ResourceColors.color_E1E1E1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Dimens.getWidth(10.0),
            height: Dimens.getHeight(30.0),
            decoration: BoxDecoration(
              color: ResourceColors.color_2462e2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Dimens.getWidth(5.0)),
            child: TextWidget(
              label: label,
              textStyle: widget.textStyle ??
                  MKStyle.t12R.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ResourceColors.color_70),
            ),
          ),
          SizedBox(
            width: Dimens.getWidth(10.0),
          ),
          Visibility(
            visible: isIconVisible(),
            child: (widget.icon != null && widget.icon != "")
                ? Image.asset(widget.icon!,
                    width: Dimens.getWidth(12.0),
                    height: Dimens.getHeight(12.0))
                : (widget.iconWidget != null
                    ? widget.iconWidget!
                    : Container()),
          )
        ],
      ),
    );
  }

  bool isIconVisible() {
    if (widget.icon == null && widget.iconWidget == null) return false;

    if (widget.icon != null) {
      return widget.icon!.isNotEmpty;
    }

    return widget.iconWidget != null;
  }
}
