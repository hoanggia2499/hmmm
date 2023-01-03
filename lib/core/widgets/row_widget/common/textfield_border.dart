import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:flutter/services.dart';
import 'package:mirukuru/core/util/limiting_text_input.dart';

class TextFieldBorder extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onSelectEvent;
  final Function(String value) onTextChange;
  final String initValue;
  final int? maxLines;
  final int maxLength;
  final bool isKeyboardNumber;
  final bool hasColorFocus;
  final bool hasEnabledBorder;
  final String hintText;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final bool isAlphabetKeyBoard;
  final GlobalKey? keys;

  TextFieldBorder({
    required this.onSelectEvent,
    required this.onTextChange,
    this.keys,
    this.width,
    this.height,
    this.initValue = '',
    this.isKeyboardNumber = false,
    this.isAlphabetKeyBoard = false,
    this.hintText = '',
    this.maxLength = 1000,
    this.hasColorFocus = true,
    this.hasEnabledBorder = true,
    this.contentPadding,
    this.textAlign = TextAlign.left,
    this.maxLines,
  });

  @override
  _TextFieldBorderState createState() => _TextFieldBorderState();
}

class _TextFieldBorderState extends State<TextFieldBorder> {
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    controller?.text = widget.initValue;
    return InkWell(
      onTap: () => {widget.onSelectEvent?.call()},
      child: Container(
        decoration: setBoxDecoration(),
        child: TextField(
          key: widget.keys,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: createInputFormatter(),
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          keyboardType: widget.isKeyboardNumber == false
              ? TextInputType.multiline
              : TextInputType.number,
          controller: controller,
          textAlign: widget.textAlign,
          decoration: InputDecoration(
            hintText: widget.hintText,
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.all(Dimens.getHeight(5.0)),
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
        ),
      ),
    );
  }

  BoxDecoration setBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(-1, 3), // changes position of shadow
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initValue);
  }

  List<TextInputFormatter> createInputFormatter() {
    var rtnList = <TextInputFormatter>[];

    // Add input limit max length
    rtnList.add(LimitingTextInputFormatter(widget.maxLength));

    if (!widget.isKeyboardNumber) {
      if (widget.isAlphabetKeyBoard) {
        rtnList
            .add(FilteringTextInputFormatter.allow(RegExp(r'^[\x00-\x7F]+$')));
      } else {
        rtnList.add(FilteringTextInputFormatter.singleLineFormatter);
      }
    } else {
      rtnList.add(FilteringTextInputFormatter.digitsOnly);
    }

    return rtnList;
  }
}
