import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

// Left side has button, right side has list view row
class RowWidgetPattern8 extends StatefulWidget {
  final String initValue;
  final String textStr;
  final String? textBtn;
  final bool requiredField;
  final VoidCallback? rowCallBack;
  final List<String>? listData;

  RowWidgetPattern8(
      {required this.textStr,
      required this.textBtn,
      required this.rowCallBack,
      this.initValue = '',
      this.listData,
      this.requiredField = false});

  @override
  _RowWidgetPattern8State createState() => _RowWidgetPattern8State();
}

class _RowWidgetPattern8State extends State<RowWidgetPattern8> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildLeftSideWidget()),
            Expanded(
              flex: 7,
              child: ListViewWidget(
                rowEventCallBack: (int index) => _buildRowList(index),
                countTotalListData: widget.listData!.length,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRowList(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getHeight(8.0)),
      child: InkWell(
        onTap: () {
          widget.rowCallBack!.call();
        },
        child: Row(
          children: [
            Container(
                width: Dimens.getWidth(50.0),
                height: Dimens.getHeight(50.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(color: ResourceColors.grey),
                    color: ResourceColors.color_black_4),
                child: TextWidget(
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  label: (index + 1).toString(),
                  alignment: TextAlign.center,
                )),
            SizedBox(width: Dimens.getWidth(10.0)),
            TextWidget(
              label: widget.listData![index],
              textStyle:
                  MKStyle.t12B.copyWith(color: ResourceColors.color_FF4BC9FD),
            )
          ],
        ),
      ),
    );
  }

  _buildLeftSideWidget() {
    return Column(
      children: [
        LeftSideWidget(
          textStr: widget.textStr,
          requiredField: widget.requiredField,
        ),
        SizedBox(
          height: Dimens.getHeight(10.0),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: Dimens.getWidth(20.0), left: Dimens.getWidth(15.0)),
          child: ButtonWidget(
            content: widget.textBtn!,
            borderRadius: 2,
            textStyle:
                MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
            clickButtonCallBack: () {},
          ),
        )
      ],
    );
  }
}
