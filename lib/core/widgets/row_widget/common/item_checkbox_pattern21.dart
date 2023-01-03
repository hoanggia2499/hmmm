import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

import '../../common/custom_check_box.dart';

class ItemCheckBoxPattern21 extends StatefulWidget {
  final bool isCheck;
  final String icon;
  final String? contentTop;
  final String? contentBottom;
  final int? index;

  final Function(bool, int?) onCheckChange;

  ItemCheckBoxPattern21(
      {required this.isCheck,
      required this.icon,
      required this.onCheckChange,
      this.index,
      this.contentTop,
      this.contentBottom});

  @override
  _ItemCheckBoxPattern21State createState() => _ItemCheckBoxPattern21State();
}

class _ItemCheckBoxPattern21State extends State<ItemCheckBoxPattern21> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return InkWell(
        onTap: () => onCheckChange(!widget.isCheck),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.getHeight(8.0),
              horizontal: Dimens.getWidth(8.0)),
          child: Row(
            children: [
              _buildLeftSideWidget(),
              SizedBox(
                width: Dimens.getWidth(10.0),
              ),
              _buildRightSideWidget()
            ],
          ),
        ));
  }

  Widget _buildRightSideWidget() {
    return Expanded(
        flex: 10,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 1,
                child: Image.asset(
                  widget.icon,
                )),
            SizedBox(
              width: Dimens.getWidth(10.0),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    label: widget.contentTop!,
                    textStyle: MKStyle.t15R,
                  ),
                  TextWidget(
                    label: widget.contentBottom!,
                    textStyle: MKStyle.t15R,
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildLeftSideWidget() {
    return Expanded(
      flex: 1,
      child: CustomCheckbox(
        onChange: (value) => onCheckChange(value),
        selectedIconColor: Colors.green,
        borderColor: Colors.grey,
        size: DimenFont.sp28,
        iconSize: DimenFont.sp25,
      ),
    );
  }

  void onCheckChange(bool value) {
    widget.onCheckChange.call(value, widget.index);
  }
}
