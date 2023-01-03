import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/radio_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';

// Group radio button row
class RowWidgetPattern15 extends StatefulWidget {
  final List<String> listData;
  final Function(int) radioCallBack;
  RowWidgetPattern15({required this.listData, required this.radioCallBack});
  @override
  _RowWidgetPattern15State createState() => _RowWidgetPattern15State();
}

class _RowWidgetPattern15State extends State<RowWidgetPattern15> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.getHeight(40.0),
      child: ListViewWidget(
          padding: EdgeInsets.only(left: Dimens.getWidth(8.0)),
          countTotalListData: widget.listData.length,
          scrollDirection: Axis.horizontal,
          rowEventCallBack: (int index) => RadioWidget(
                indicatorColor: ResourceColors.color_3768CE,
                value: widget.listData[index],
                currentChoice: value,
                currentRow: index,
                callBack: (int index) =>
                    {updateRadio(index), widget.radioCallBack.call(index)},
              )),
    );
  }

  updateRadio(int index) {
    setState(() {
      value = index;
    });
  }
}
