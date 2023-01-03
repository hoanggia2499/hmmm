import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

// Question topic list row
class RowWidgetPattern19 extends StatefulWidget {
  final String? contentTop;
  final String? contentBottom;
  final String iconUrl;

  RowWidgetPattern19(
      {this.contentTop, this.contentBottom, required this.iconUrl});

  @override
  _RowWidgetPattern19State createState() => _RowWidgetPattern19State();
}

class _RowWidgetPattern19State extends State<RowWidgetPattern19> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return Container(
      //height: Dimens.size70,
      child: Row(
        children: [
          Expanded(flex: 1, child: Container()),
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
                label: widget.contentTop!,
                textStyle: MKStyle.t15R,
              ),
              TextWidget(
                label: "2022年１2月3日",
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
          widget.iconUrl,
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
