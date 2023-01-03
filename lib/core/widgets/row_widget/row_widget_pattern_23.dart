import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class RowWidgetPattern23 extends StatefulWidget {
  final bool isReaded;
  final String contentTop;
  final String contentBottom;

  RowWidgetPattern23(
      {required this.contentTop,
      required this.contentBottom,
      this.isReaded = false});
  @override
  _RowWidgetPattern23State createState() => _RowWidgetPattern23State();
}

class _RowWidgetPattern23State extends State<RowWidgetPattern23> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainRow(),
        DividerNoText(
          indent: 0.0,
          endIndent: 0.0,
        )
      ],
    );
  }

  Widget _buildMainRow() {
    return Container(
      //height: Dimens.size70,
      child: Row(
        children: [
          _buildLeftSideWidget(),
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
                label: widget.contentTop,
                textStyle: MKStyle.t15R,
              ),
              TextWidget(
                label: widget.contentBottom,
                textStyle: MKStyle.t12R,
              )
            ],
          ),
        ));
  }

  _buildLeftSideWidget() {
    return Expanded(
        flex: 1,
        child: Image.asset(
          widget.isReaded
              ? 'assets/images/png/icon_new_no.png'
              : 'assets/images/png/icon_new.png',
          width: Dimens.getWidth(40.0),
          height: Dimens.getHeight(40.0),
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
