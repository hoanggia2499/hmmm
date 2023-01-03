import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/item_radio_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';

class DialogRadioButtonWidget extends StatefulWidget {
  final List<String> listData;
  final Function(int) radioCallBack;
  int initValue;
  DialogRadioButtonWidget(
      {required this.listData,
      required this.radioCallBack,
      this.initValue = 0});
  @override
  _DialogRadioButtonWidgetState createState() =>
      _DialogRadioButtonWidgetState();
}

class _DialogRadioButtonWidgetState extends State<DialogRadioButtonWidget> {
  //int value = 0;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListViewWidget(
            countTotalListData: widget.listData.length,
            scrollDirection: Axis.vertical,
            rowEventCallBack: (int index) => ItemRadioWidget(
              isCheckLastRow:
                  widget.listData.length - 1 == index ? true : false,
              value: widget.listData[index],
              currentChoice: widget.initValue,
              currentRow: index,
              callBack: (int index) =>
                  {updateRadio(index), widget.radioCallBack.call(index)},
            ),
          ),
        ),
      ),
    );
  }

  updateRadio(int index) {
    setState(() {
      widget.initValue = index;
    });
  }
}
