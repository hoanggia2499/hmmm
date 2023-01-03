import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import '../common/custom_check_box.dart';

// List simple check box
class RowWidgetPattern12 extends StatefulWidget {
  RowWidgetPattern12(
      {required this.listData,
      this.callBackNumbersOfChecked,
      this.initDataChecked = false,
      required this.initListSelectedValue});

  final List<String> listData;
  final Function(int, List<bool>)? callBackNumbersOfChecked;
  bool initDataChecked;
  final List<bool> initListSelectedValue;

  @override
  _RowWidgetPattern12 createState() => _RowWidgetPattern12();
}

class _RowWidgetPattern12 extends State<RowWidgetPattern12> {
  var scaleValue = 2.0;
  List<bool> listSelectedValue = [];
  int countChecked = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initDataChecked == false) {
      setState(() {
        listSelectedValue = widget.initListSelectedValue;
      });
      widget.initDataChecked = true;
    }
    return Column(children: _buildListCheckBox());
  }

  List<Widget> _buildListCheckBox() {
    var list = <Widget>[];
    for (var i = 0; i < widget.listData.length; i++) {
      list.add(_buildRow(widget.listData[i], i));
    }

    return list;
  }

  Widget _buildRow(String title, int index) {
    return InkWell(
        onTap: () => onCheckChange(!listSelectedValue[index], index),
        child: Row(
          children: [
            _buildCheckBox(index),
            SizedBox(width: 10.0),
            TextWidget(
                label: title,
                textStyle:
                    MKStyle.t14R.copyWith(color: ResourceColors.text_black))
          ],
        ));
  }

  Widget _buildCheckBox(int index) {
    return CustomCheckbox(
      value: listSelectedValue[index],
      selectedIconColor: Colors.green,
      borderColor: ResourceColors.grey,
      size: DimenFont.sp24,
      iconSize: DimenFont.sp20,
      onChange: (value) => onCheckChange(value, index),
    );
  }

  void onCheckChange(bool value, int index) {
    setState(() {
      listSelectedValue[index] = value;
      countChecked = 0;
      listSelectedValue.forEach((element) {
        if (element == true) {
          countChecked += 1;
        }
      });
      widget.callBackNumbersOfChecked?.call(countChecked, listSelectedValue);
    });
  }
}
