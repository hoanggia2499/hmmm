import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/custom_check_box.dart';
import 'package:mirukuru/core/widgets/common/slide_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class RowWidgetPattern21 extends StatefulWidget {
  final bool isCheck;
  final String icon;
  final String? contentTop;
  final String? contentBottom;

  final Function(bool) onCheckChange;
  final VoidCallback onItemClick;

  bool isShowCheckbox;

  RowWidgetPattern21(
      {required this.isCheck,
      required this.icon,
      required this.onCheckChange,
      required this.onItemClick,
      this.contentTop,
      this.isShowCheckbox = false,
      this.contentBottom});

  @override
  _RowWidgetPattern21State createState() => _RowWidgetPattern21State();
}

class _RowWidgetPattern21State extends State<RowWidgetPattern21> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildMainRow(),
          Container(
            height: Dimens.getSize(1.0),
            color: ResourceColors.color_70,
          )
        ],
      ),
    );
  }

  Widget _buildMainRow() {
    return InkWell(
      onTap: () => widget.isShowCheckbox
          ? widget.onCheckChange.call(!widget.isCheck)
          : widget.onItemClick.call(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildLeftSideWidget(),
          Flexible(
            flex: 9,
            fit: FlexFit.tight,
            child: HidableActionsWidget(
              slideOffset: Offset(0.05, 0.0),
              isHiding: widget.isShowCheckbox,
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimens.getHeight(10.0),
                    right: Dimens.getWidth(10.0),
                    bottom: Dimens.getHeight(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_buildRightSideWidget(), _buildNextBtn()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildNextBtn() {
    return Visibility(
      visible: !widget.isShowCheckbox,
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      child: Image.asset(
        "assets/images/png/next.png",
        width: Dimens.getHeight(15.0),
        height: Dimens.getHeight(15.0),
      ),
    );
  }

  Widget _buildRightSideWidget() {
    return Expanded(
        flex: 10,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.asset(
                  widget.icon,
                  width: Dimens.getWidth(60.0),
                  height: Dimens.getWidth(60.0),
                )),
            SizedBox(
              width: Dimens.getWidth(10.0),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(right: Dimens.getWidth(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      label: widget.contentTop!,
                      textStyle: MKStyle.t14R
                          .copyWith(color: ResourceColors.color_757575),
                    ),
                    TextWidget(
                      label: widget.contentBottom!,
                      textStyle: MKStyle.t12R
                          .copyWith(color: ResourceColors.color_757575),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildLeftSideWidget() {
    return Visibility(
      visible: widget.isShowCheckbox,
      child: HidableActionsWidget(
        slideOffset: Offset(0.02, 0.0),
        isHiding: widget.isShowCheckbox,
        child: Padding(
          padding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
          child: CustomCheckbox(
            value: widget.isCheck,
            onChange: (value) => widget.onCheckChange.call(value),
            selectedIconColor: Colors.green,
            borderColor: Colors.grey,
            size: DimenFont.sp25,
            iconSize: DimenFont.sp20,
          ),
        ),
      ),
    );
  }
}
