import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/common/button_icon_widget.dart';

// 2 leading icon buttons row
class RowWidgetPattern14 extends StatefulWidget {
  final String? iconButtonLeft;
  final String? iconButtonRight;
  final VoidCallback? callbackBtnLeft;
  final VoidCallback? callbackBtnRight;

  RowWidgetPattern14(
      {this.callbackBtnLeft,
      this.callbackBtnRight,
      this.iconButtonLeft,
      this.iconButtonRight});
  @override
  _RowWidgetPattern14State createState() => _RowWidgetPattern14State();
}

class _RowWidgetPattern14State extends State<RowWidgetPattern14> {
  @override
  Widget build(BuildContext context) {
    return _buildMainRow();
  }

  Widget _buildMainRow() {
    //Left/Right: 3/7
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ButtonIconWidget(
              borderRadius: 1,
              strImageLeft: widget.iconButtonLeft,
              textButton: "COLLECTIVELY_FAVORITE".tr(),
              clickButtonCallBack: (bool value) {
                widget.callbackBtnLeft!.call();
              },
              backgroundColor: ResourceColors.red_bg),
        ),
        SizedBox(
          width: Dimens.getWidth(3.0),
        ),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: ButtonIconWidget(
                  borderRadius: 1,
                  strImageLeft: widget.iconButtonRight,
                  textButton: "BULK_QUOTE_REQUEST".tr(),
                  clickButtonCallBack: (bool value) {
                    widget.callbackBtnRight!.call();
                  },
                  backgroundColor: ResourceColors.red_bg),
            )),
      ],
    );
  }
}
