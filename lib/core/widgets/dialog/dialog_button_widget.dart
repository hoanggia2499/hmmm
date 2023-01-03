import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class ConfirmDialog extends StatefulWidget {
  final Widget content;
  final String okText;
  final String cancelText;
  final String? btnOK;
  final String? btnCancel;
  final VoidCallback? eventOk;
  final VoidCallback? eventCancel;
  final bool isAutoDismiss;

  ConfirmDialog(
      {Key? key,
      required this.content,
      required this.okText,
      required this.cancelText,
      this.btnOK,
      this.btnCancel,
      this.eventOk,
      this.eventCancel,
      this.isAutoDismiss = true})
      : super(key: key);

  @override
  _ConfirmDialog createState() => _ConfirmDialog();
}

class _ConfirmDialog extends State<ConfirmDialog> {
  TextStyle textStyle =
      MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
      child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Dimens.getWidth(15.0),
              ),
            ),
          ),
          backgroundColor: ResourceColors.color_FFFFFF,
          contentPadding: EdgeInsets.zero,
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  //                   <--- left side
                  color: ResourceColors.color_70,
                  width: 1.0,
                ),
              )),
              padding: EdgeInsets.symmetric(
                  vertical: Dimens.getHeight(20.0),
                  horizontal: Dimens.getWidth(20.0)),
              child: widget.content,
            ),
            Container(
                decoration: BoxDecoration(
                  color: ResourceColors.color_FFFFFF,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        Dimens.getWidth(15.0),
                      ),
                      bottomRight: Radius.circular(
                        Dimens.getWidth(15.0),
                      )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: handleCancelButton,
                          child: TextWidget(
                            textStyle: MKStyle.t16R
                                .copyWith(color: ResourceColors.color_3768CE),
                            label: widget.cancelText,
                            alignment: TextAlign.center,
                          ),
                        )),
                    Container(
                      width: Dimens.getWidth(1.0),
                      height: Dimens.getWidth(40.0),
                      color: ResourceColors.color_70,
                    ),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: handleOkButton,
                          child: TextWidget(
                            textStyle: MKStyle.t16R
                                .copyWith(color: ResourceColors.color_3768CE),
                            label: widget.okText,
                            //label: "DELETE".tr(),
                            alignment: TextAlign.center,
                          ),
                        )),
                  ],
                ))
          ])),
    );
  }

  void handleCancelButton() {
    Navigator.of(context).pop();
    widget.eventCancel?.call();
  }

  void handleOkButton() {
    if (widget.isAutoDismiss) {
      Navigator.of(context).pop();
    }
    widget.eventOk?.call();
  }
}
