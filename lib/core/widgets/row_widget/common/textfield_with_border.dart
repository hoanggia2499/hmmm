import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/row_widget/common/input_day_formatter.dart';
import 'package:mirukuru/core/widgets/row_widget/common/input_month_formatter.dart';

class TextFieldWithBorder extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onSelectEvent;
  final Function(String value) onTextChange;
  final String initValue;
  final int? maxLines;
  final int? maxlength;
  final bool? isKeyboardNumber;
  final bool hasColorFocus;
  final bool hasEnabledBorder;
  final String hintText;
  final EdgeInsets? contentPadding;
  final bool hasGradient;
  final TextAlign textAlign;
  final int maxDateOfMonth;
  final int typeDateTime;

  TextFieldWithBorder(
      {required this.onSelectEvent,
      required this.onTextChange,
      this.width,
      this.height,
      this.initValue = '',
      this.isKeyboardNumber = false,
      this.hintText = '',
      this.typeDateTime = 1,
      this.maxlength = 1000,
      this.hasColorFocus = true,
      this.hasEnabledBorder = true,
      this.contentPadding,
      this.hasGradient = false,
      this.textAlign = TextAlign.left,
      this.maxDateOfMonth = 0,
      this.maxLines});

  @override
  _TextFieldWithBorderState createState() => _TextFieldWithBorderState();
}

class _TextFieldWithBorderState extends State<TextFieldWithBorder> {
  late TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    controller.text = widget.initValue;
    return InkWell(
      onTap: () => {widget.onSelectEvent?.call()},
      child: Container(
        width: widget.width ?? Dimens.getWidth(50.0),
        height: widget.height ?? Dimens.getHeight(45.0),
        decoration: setBoxDecoration(),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: createListInputFormatter(),
          maxLength: widget.maxlength,
          maxLines: widget.maxLines,
          keyboardType: widget.isKeyboardNumber == false
              ? TextInputType.text
              : TextInputType.number,
          controller: controller,
          textAlign: widget.textAlign,
          decoration: InputDecoration(
            hintText: widget.hintText,
            counterText: '',
            // isDense: true,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                    vertical: Dimens.getHeight(8.0),
                    horizontal: Dimens.getWidth(8.0)),
            border: InputBorder.none,
            enabledBorder: widget.hasEnabledBorder == true
                ? const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black26, width: 2.0),
                  )
                : OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 2.0),
                  ),
            focusedBorder: widget.hasColorFocus == true
                ? OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0),
                    borderRadius: BorderRadius.circular(2.0),
                  )
                : OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 2.0),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
          ),
          style: MKStyle.t20R,
          onChanged: widget.onTextChange,
          onEditingComplete: onEditingCompleted,
        ),
      ),
    );
  }

  BoxDecoration setBoxDecoration() {
    return widget.hasGradient == false
        ? BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(-1, 3), // changes position of shadow
              ),
            ],
            // border: Border.all(
            //     color: Colors.black26, // set border color
            //     width: 2.0), // set border width
            // borderRadius:
            //     BorderRadius.all(Radius.circular(2.0)), // set rounded corner radius
          )
        : BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(-1, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
            // border: Border.all(
            //     color: Colors.black26, // set border color
            //     width: 2.0), // set border width
            // borderRadius:
            //     BorderRadius.all(Radius.circular(2.0)), // set rounded corner radius
            );
  }

  List<TextInputFormatter>? createListInputFormatter() {
    if (widget.typeDateTime == 3) {
      // Format input year
      return [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
    } else if (widget.typeDateTime == 2) {
      // Format input month
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
        InputMonthFormatter()
      ];
    } else {
      // Format input day
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        InputDayFormatter(widget.maxDateOfMonth)
      ];
    }
  }

  void onEditingCompleted() {
    if (widget.typeDateTime == 1) {
      // Formatter input day
      if (controller.text.length < 2 && controller.text.length > 0) {
        var currentValue = int.parse(controller.text);
        controller.text = currentValue.toString().padLeft(2, '0');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initValue);
  }
}
