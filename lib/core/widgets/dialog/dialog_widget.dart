import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import '../../../features/menu_widget_test/pages/button_widget.dart';

class DialogWidget extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback? eventCallBack;
  final bool hasCallBack;
  final bool popNavigator;
  final String buttonContent;
  final TextAlign textAlignContent;

  DialogWidget({
    required this.title,
    required this.content,
    required this.hasCallBack,
    this.eventCallBack,
    this.buttonContent = 'OK',
    this.popNavigator = true,
    this.textAlignContent = TextAlign.center,
  });

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  TextStyle textStyle = MKStyle.t18R.copyWith(
    fontFamily: 'NotoSansJPBold',
  );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: EdgeInsets.only(
            top: Dimens.getHeight(10.0),
            bottom: Dimens.getHeight(5.0),
            left: Dimens.getWidth(15.0),
            right: Dimens.getWidth(15.0)),
        title: widget.title.isNotEmpty
            ? Text(
                widget.title,
                textAlign: TextAlign.center,
                style: MKStyle.t18B.copyWith(
                  fontFamily: 'NotoSansJPBold',
                ),
              )
            : null,
        content: Text(
          widget.content,
          textAlign: widget.textAlignContent,
          style: MKStyle.t18R,
        ),
        actionsAlignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.only(
            top: widget.title.isNotEmpty ? 0.0 : 10.0,
            left: 15.0,
            right: 10.0,
            bottom: 10.0),
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: ResourceColors.color_ababab),
              ),
            ),
            child: ButtonWidget(
              clickButtonCallBack: handleCallBack,
              content: widget.buttonContent,
              bgdColor: ResourceColors.color_FFFFFF,
              borderColor: ResourceColors.color_FFFFFF,
              borderRadius: 15.0,
              size: DimenFont.normal,
              textStyle:
                  MKStyle.t18R.copyWith(color: ResourceColors.color_FF46A3FF),
            ),
          ),
        ],
      ),
    );
  }

  void handleCallBack() {
    if (widget.popNavigator) {
      Navigator.of(context).pop();
    }
    widget.eventCallBack?.call();
  }
}
