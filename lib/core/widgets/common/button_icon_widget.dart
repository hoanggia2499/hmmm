import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';

class ButtonIconWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final String? textButton;
  final double? spaceBetweenCharacter;
  final Function(bool) clickButtonCallBack;
  final IconData? strImageRight;
  final String? fontFamily;
  final TextStyle? textStyle;
  // default color Border is Black Color
  final double? borderWidth;
  final double? borderRadius;

  // Using When need Add a Image
  final String? strImageLeft;

  int buttonType;

  bool clickIcon;

  Color? colorIconRight;
  double? sizeIconRight;

  ButtonIconWidget(
      {required this.textButton,
      required this.clickButtonCallBack,
      required this.backgroundColor,
      this.spaceBetweenCharacter,
      this.width,
      this.height,
      this.buttonType = Constants.MAIN_BUTTON,
      this.colorIconRight = Colors.white,
      this.sizeIconRight,
      this.textStyle,
      this.borderWidth,
      this.borderRadius,
      this.strImageLeft,
      this.strImageRight,
      this.fontFamily,
      this.clickIcon = false});

  @override
  _ButtonIconWidgetState createState() => _ButtonIconWidgetState();
}

class _ButtonIconWidgetState extends State<ButtonIconWidget> {
  bool clickIcon = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor!,
      shape: _buildCustomShape(),
      child: InkWell(
        customBorder: _buildCustomShape(),
        onTap: () {
          setState(() {
            widget.clickIcon = !widget.clickIcon;
          });
          widget.clickButtonCallBack(widget.clickIcon);
        },
        child: Container(
            width: widget.width,
            height:
                widget.height == null ? Dimens.getHeight(30.0) : widget.height,
            margin: EdgeInsets.only(top: Dimens.getHeight(5.0)),
            decoration: setBoxDecoration(),
            child: _buildButton()),
      ),
    );
  }

  _buildButton() {
    if (widget.buttonType == Constants.MAIN_BUTTON) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildIconLeft(),
          ),
          Align(
            alignment: Alignment.center,
            child: _buildText(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildIconRight(),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          _buildIconLeft(),
          SizedBox(width: Dimens.getWidth(5.0)),
          _buildText()
        ],
      );
    }
  }

  _buildText() {
    return Container(
      //alignment: Alignment.center,
      child: Text(
        widget.textButton!,
        textAlign: TextAlign.center,
        style: widget.textStyle ??
            MKStyle.t12R.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: ResourceColors.color_white),
      ),
    );
  }

  _buildIconLeft() {
    return Padding(
        padding: EdgeInsets.only(left: Dimens.getWidth(5.0)),
        child: Visibility(
          visible: widget.strImageLeft == null ? false : true,
          child: Image.asset(
              widget.strImageLeft == null ? "" : widget.strImageLeft!,
              width: Dimens.getWidth(18.0),
              height: Dimens.getHeight(18.0),
              color: (widget.strImageLeft ==
                          "assets/images/png/okiniiri_icon.png" &&
                      widget.clickIcon == true)
                  ? Colors.yellow
                  : Colors.white),
        ));
  }

  _buildIconRight() {
    return Padding(
      padding: EdgeInsets.only(right: Dimens.getWidth(5.0)),
      child: Visibility(
          visible: widget.strImageRight == null ? false : true,
          child: Icon(
            widget.strImageRight,
            color: widget.colorIconRight,
            size: widget.sizeIconRight == null
                ? DimenFont.sp18
                : widget.sizeIconRight,
          )),
    );
  }

  BoxDecoration setBoxDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
    );
  }

  _buildCustomShape() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0));
}
