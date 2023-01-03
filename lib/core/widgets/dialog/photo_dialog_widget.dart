import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class PhotoDialog extends StatefulWidget {
  final Widget content;
  final String okText;
  final String cancelText;
  final String? btnOK;
  final String? btnCancel;
  final VoidCallback? eventTakeAPhoTo;
  final VoidCallback? eventSelectPhoto;
  final VoidCallback? eventCancel;

  PhotoDialog(
      {Key? key,
      required this.content,
      required this.okText,
      required this.cancelText,
      this.btnOK,
      this.btnCancel,
      this.eventTakeAPhoTo,
      this.eventSelectPhoto,
      this.eventCancel})
      : super(key: key);

  @override
  _PhotoDialog createState() => _PhotoDialog();
}

class _PhotoDialog extends State<PhotoDialog> {
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
            _buildRowItem('TAKE_PHOTO'.tr(), handleTakeAPhotoButton),
            DividerNoText(),
            _buildRowItem('HANDLE_SELECT_PHOTO'.tr(), handleSelectPhotoButton),
            DividerNoText(),
            _buildRowItem('CANCEL'.tr(), handleCancelButton)
          ])),
    );
  }

  _buildRowItem(String title, GestureTapCallback gestureTapCallback) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: gestureTapCallback,
        child: Padding(
          padding: EdgeInsets.only(
              top: Dimens.getWidth(15.0), bottom: Dimens.getWidth(15.0)),
          child: TextWidget(
              label: title,
              textStyle:
                  MKStyle.t16R.copyWith(color: ResourceColors.color_3768CE),
              alignment: TextAlign.center),
        ),
      ),
    );
  }

  void handleSelectPhotoButton() {
    Navigator.of(context).pop();
    widget.eventSelectPhoto?.call();
  }

  void handleTakeAPhotoButton() {
    Navigator.of(context).pop();
    widget.eventTakeAPhoTo?.call();
  }

  void handleCancelButton() {
    Navigator.of(context).pop();
    widget.eventCancel?.call();
  }
}
