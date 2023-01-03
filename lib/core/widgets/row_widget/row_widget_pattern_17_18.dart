import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/widgets/common/button_icon_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher_string.dart';

// 2 leading icon buttons row can change color
class RowWidgetPattern17 extends StatefulWidget {
  final String? iconButtonLeft;
  final String? iconButtonCenter;
  final String? iconButtonRight;
  final String? textButtonLeft;
  final String? textButtonCenter;
  final String? textButtonRight;
  final Function(bool)? callbackBtnLeft;
  final VoidCallback? callbackBtnCenter;
  final VoidCallback? callbackToCall;
  bool? clickIcon;
  bool hasDivider;
  double? widthLeft;
  double? widthRight;
  double? height;
  Color? backgroundColorCenter;
  Color? backgroundColorRight;

  RowWidgetPattern17(
      {this.iconButtonRight,
      this.iconButtonCenter,
      this.iconButtonLeft,
      this.textButtonLeft,
      this.textButtonCenter,
      this.textButtonRight,
      this.callbackToCall,
      this.callbackBtnCenter,
      this.clickIcon,
      this.widthLeft,
      this.widthRight,
      this.height,
      this.backgroundColorCenter,
      this.backgroundColorRight,
      this.hasDivider = true,
      this.callbackBtnLeft});

  @override
  _RowWidgetPattern17State createState() => _RowWidgetPattern17State();
}

class _RowWidgetPattern17State extends State<RowWidgetPattern17> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildMainRow(),
        ],
      ),
    );
  }

  Widget _buildMainRow() {
    //Left/Right: 3/7
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonIconWidget(
            width: widget.widthLeft == null
                ? MediaQuery.of(context).size.width / 1.9
                : widget.widthLeft,
            height: Dimens.getHeight(35),
            buttonType: Constants.MAIN_BUTTON,
            borderRadius: Dimens.getHeight(30),
            textButton: widget.textButtonCenter,
            clickButtonCallBack: (bool value) {
              widget.callbackBtnCenter!.call();
            },
            backgroundColor: widget.backgroundColorCenter == null
                ? ResourceColors.color_FF0FA4EA
                : widget.backgroundColorCenter),
        SizedBox(
          width: Dimens.getWidth(30.0),
        ),
        ButtonIconWidget(
            width: widget.widthRight == null
                ? MediaQuery.of(context).size.width / 3.8
                : widget.widthRight,
            height: Dimens.getHeight(35),
            borderRadius: Dimens.getHeight(30),
            textButton: widget.textButtonRight,
            buttonType: Constants.MAIN_BUTTON,
            clickButtonCallBack: (bool value) {
              // showToCallDialog();
              widget.callbackToCall!.call();
            },
            backgroundColor: widget.backgroundColorRight == null
                ? ResourceColors.color_6DC432
                : widget.backgroundColorRight),
      ],
    );
  }

  showToCallDialog() async {
    // HardCode Phone Number
    String phoneNumber = "0909564564";

    await CommonDialog.displayConfirmDialog(
      context,
      TextWidget(
        label: "[$phoneNumber]に発信します",
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_000000),
        alignment: TextAlign.start,
      ),
      "CALL".tr(),
      "CANCEL".tr(),
      okEvent: () async {
        launchUrlString("tel://" + phoneNumber);
      },
      cancelEvent: () {},
    );
  }
}
