import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class DropDownButtonWidget extends StatefulWidget {
  final Function() clickButtonCallBack;
  final String content;
  final int typePattern;

  DropDownButtonWidget({
    required this.clickButtonCallBack,
    required this.content,
    this.typePattern = 6,
  });
  @override
  _DropDownButtonWidgetState createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  List<DropdownMenuItem<String>> dropDownItems = [];

  @override
  void initState() {
    super.initState();
    List<String> items = [widget.content];
    for (String item in items) {
      dropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: MKStyle.t16R,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: setLinearGradient(),
      child: _buildDropDown(),
    );
  }

  _buildDropDown() {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: InkWell(
          onTap: () {
            widget.clickButtonCallBack();
          },
          child: IgnorePointer(
            child: DropdownButton(
              iconSize: (widget.typePattern == 6 || widget.typePattern == 9)
                  ? 0.0
                  : DimenFont.sp16,
              //isDense: true,
              value: widget.content,
              style: MKStyle.t14R.copyWith(color: ResourceColors.text_black),
              isExpanded: true,
              items: dropDownItems.map<DropdownMenuItem<String>>((var value) {
                return alignTextDropDown();
              }).toList(),
              onChanged: (selectedItem) => setState(() {}),
            ),
          ),
        ),
      ),
    );
  }

  setLinearGradient() {
    return BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Colors.transparent,
        Colors.black26,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ));
  }

  alignTextDropDown() {
    return DropdownMenuItem<String>(
      value: widget.content,
      child: (widget.typePattern == 6)
          ? Center(
              child: TextWidget(
                label: widget.content,
                alignment: TextAlign.center,
              ),
            )
          : TextWidget(
              label: widget.content,
              alignment: TextAlign.center,
            ),
    );
  }
}
