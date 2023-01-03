import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class SubTitle extends StatefulWidget {
  final String label;
  final TextStyle? textStyle;
  final double paddingLeft;
  SubTitle(
      {Key? key, required this.label, this.textStyle, this.paddingLeft = 5.0})
      : super(key: key);

  @override
  _SubTitleState createState() => _SubTitleState();
}

class _SubTitleState extends State<SubTitle> {
  @override
  Widget build(BuildContext context) {
    return _buildTitle(widget.label);
  }

  Widget _buildTitle(String label) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.getHeight(5.0)),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: ResourceColors.color_FFFFFF,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: Dimens.getWidth(widget.paddingLeft),
              // top: Dimens.getWidth(5.0),
              // bottom: Dimens.getWidth(5.0),
            ),
            child: Container(
              width: Dimens.getWidth(5.0),
              height: Dimens.getHeight(20.0),
              decoration: BoxDecoration(
                color: ResourceColors.color_2462e2,
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: Dimens.getWidth(5.0)),
              child: TextWidget(
                  label: label,
                  textStyle: widget.textStyle ??
                      MKStyle.t12R.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ResourceColors.color_70)),
            ),
          )
        ],
      ),
    );
  }
}
