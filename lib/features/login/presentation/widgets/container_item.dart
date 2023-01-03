import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContainerItem extends StatefulWidget {
  final String label;
  final BoxDecoration boxDecoration;
  final String storeName;

  bool? checkPhoneNumber;
  ContainerItem({
    super.key,
    required this.label,
    required this.boxDecoration,
    this.storeName = '',
  });

  @override
  State<ContainerItem> createState() => _ContainerItemState();
}

class _ContainerItemState extends State<ContainerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
        child: InkWell(
            onTap: () {
              showToCallDialog(widget.label, widget.storeName);
            },
            child: _buildText()),
      ),
    );
  }

  Widget _buildText() {
    return TextWidget(
      label: widget.label,
      textStyle: MKStyle.t12R.copyWith(
          color: ResourceColors.color_FF0000FF,
          decoration: TextDecoration.underline),
    );
  }

  showToCallDialog(String phone, String storeName) async {
    await CommonDialog.displayConfirmDialog(
      context,
      TextWidget(
        label: "ASK_CALL_STORE_TEL".tr() + phone + " " + storeName,
        textStyle: MKStyle.t14R,
        alignment: TextAlign.start,
      ),
      "BTN_OK".tr(),
      "BTN_CANCEL".tr(),
      okEvent: () async {
        launchUrlString("tel://" + phone);
      },
      cancelEvent: () {},
    );
  }
}
