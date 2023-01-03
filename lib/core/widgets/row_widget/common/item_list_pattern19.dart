import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class ItemListPattern19 extends StatefulWidget {
  final int index;
  final String icon;
  final String? contentTop;
  final String? contentBottom;
  final int? alignFlexLeft;

  ItemListPattern19(
      {required this.index,
      required this.icon,
      this.contentTop,
      this.alignFlexLeft = 1,
      this.contentBottom});

  @override
  _ItemListPattern19State createState() => _ItemListPattern19State();
}

class _ItemListPattern19State extends State<ItemListPattern19> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(widget.index), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow(int index) {
    return Container(
      //height: Dimens.size70,
      child: Row(
        children: [
          Expanded(flex: widget.alignFlexLeft!, child: Container()),
          _buildLeftSideWidget(index),
          SizedBox(
            width: Dimens.getWidth(10.0),
          ),
          _buildRightSideWidget()
        ],
      ),
    );
  }

  _buildRightSideWidget() {
    return Expanded(
        flex: 4,
        child: Padding(
          padding: EdgeInsets.only(right: Dimens.getWidth(90.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                label: widget.contentTop!,
                textStyle: MKStyle.t15R,
              ),
              TextWidget(
                label: widget.contentBottom!,
                textStyle: MKStyle.t12R,
              )
            ],
          ),
        ));
  }

  _buildLeftSideWidget(int index) {
    return Expanded(
        flex: 1,
        child: Image.asset(
          widget.icon,
          width: DimenFont.sp40,
          height: DimenFont.sp40,
        ));
  }

  BoxDecoration setBoxDecoration() {
    return BoxDecoration(
      color: Colors.black26,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(-1, 3), // changes position of shadow
        ),
      ], // set border width
      borderRadius:
          BorderRadius.all(Radius.circular(2.0)), // set rounded corner radius
    );
  }
}
