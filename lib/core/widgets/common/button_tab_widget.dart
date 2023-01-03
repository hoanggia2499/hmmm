// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

class ButtonTabWidget extends StatefulWidget {
  String content;
  TextStyle? textStyle;
  Color bgdColor;
  Color borderColor;
  double size;
  double borderRadius;
  String subContent;
  bool isEnable;
  Function() clickButtonCallBack;
  int typePattern;
  double? heightText;
  bool hasBorderRadius;
  double width;
  double height;
  bool actionFlag;

  ButtonTabWidget(
      {required this.content,
      required this.clickButtonCallBack,
      this.subContent = '',
      this.bgdColor = ResourceColors.blue_bg,
      this.size = 12.0,
      this.borderRadius = 18.0,
      this.borderColor = ResourceColors.blue_bg,
      this.typePattern = 6,
      this.isEnable = true,
      this.heightText,
      this.hasBorderRadius = true,
      this.width = double.infinity,
      this.actionFlag = false,
      this.height = 50.0,
      this.textStyle});

  @override
  _ButtonTabWidgetState createState() => _ButtonTabWidgetState();
}

class _ButtonTabWidgetState extends State<ButtonTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.getWidth(40.0),
      decoration: _buildBoxDecoration(),
      width: widget.width,
      child: Padding(
        padding: widget.actionFlag
            ? EdgeInsets.only(top: 10.0)
            : EdgeInsets.only(top: 0.0),
        child: IgnorePointer(
          ignoring: !widget.isEnable,
          child: ElevatedButton(
            onPressed: () async {
              widget.clickButtonCallBack();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderRadius: widget.hasBorderRadius
                      ? BorderRadius.circular(widget.borderRadius)
                      : BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                  side: BorderSide(
                    color: ResourceColors.color_FFEEEEEE,
                  ),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(widget.bgdColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (widget.typePattern == 7 || widget.typePattern == 9)
                    ? _buildDropDown(widget.typePattern)
                    : Text(
                        widget.content,
                        style: widget.textStyle ??
                            MKStyle.t12R.copyWith(
                                color: ResourceColors.color_b80707,
                                fontWeight: FontWeight.w600,
                                fontFamily: "NotoSansJPMedium",
                                height: 1.0),
                      ),
                if (widget.subContent != '')
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.getHeight(15.0)),
                    child: Text(
                      widget.subContent,
                      style: widget.textStyle ??
                          MKStyle.t12R.copyWith(
                              color: ResourceColors.color_b80707,
                              fontWeight: FontWeight.w600,
                              fontFamily: "NotoSansJPMedium",
                              height: 0.0),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: ResourceColors.color_FFFFFF,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)));
  }

  _buildDropDown(int typePattern) {
    List<String> items = [widget.content];
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String item in items) {
      dropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: MKStyle.t16R,
        ),
      ));
    }
    return Row(
      children: [
        Expanded(
          flex: 20,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: InkWell(
                onTap: () {
                  widget.clickButtonCallBack();
                },
                child: IgnorePointer(
                  child: DropdownButton(
                    iconSize: 30.0,
                    isDense: true,
                    value: widget.content,
                    isExpanded: true,
                    items: dropDownItems,
                    onChanged: (selectedItem) => setState(() {}),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
