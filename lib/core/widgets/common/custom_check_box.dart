import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/resources.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final Function(bool)? onChange;
  final double? size;
  final double? iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;

  CustomCheckbox({
    this.value = false,
    this.onChange,
    this.size = 18.0,
    this.iconSize = 14.0,
    this.selectedColor = ResourceColors.color_3768CE,
    this.selectedIconColor = Colors.white,
    this.borderColor = Colors.black,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool checkboxValue = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  setState(() {
    checkboxValue = widget.value;
    //  });
    return GestureDetector(
      onTap: () {
        print('before set state $checkboxValue');
        setState(() {
          checkboxValue = !checkboxValue;
        });
        print('after set state $checkboxValue');
        widget.onChange?.call(checkboxValue);
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(4.0), horizontal: Dimens.getWidth(4.0)),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: checkboxValue ? widget.selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(DimenFont.sp6),
            border: Border.all(
              color: widget.borderColor,
              width: DimenFont.sp1,
            )),
        width: widget.size ?? ScreenUtil.getInstance().getSp(18.0),
        height: widget.size ?? ScreenUtil.getInstance().getSp(18.0),
        child: checkboxValue
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  'assets/images/svg/check.svg',
                ),
              )
            : null,
      ),
    );
  }
}
