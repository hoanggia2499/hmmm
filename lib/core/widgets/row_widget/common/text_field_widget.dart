import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

class TextFieldWidget extends StatefulWidget {
  final String? hintText;
  final bool enabled;
  final Function(String)? onChangeValue;
  final int? maxLine;
  final int? maxBytes;
  final int? maxLength;
  final TextAlign align;
  final TextInputAction textInputAction;
  final String initValue;
  final Function()? onEdittingCompleted;
  final bool displayHint;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final bool? isDense;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? extraTextInputFormatters;

  const TextFieldWidget({
    this.hintText = '入力してください',
    this.enabled = true,
    this.onChangeValue,
    this.maxLine = 1,
    this.maxBytes,
    this.maxLength,
    this.align = TextAlign.end,
    this.textInputAction = TextInputAction.next,
    this.initValue = '',
    this.onEdittingCompleted,
    this.displayHint = true,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.paddingLeft = 0.0,
    this.contentPadding,
    this.isDense,
    this.keyboardType = TextInputType.text,
    this.extraTextInputFormatters,
  });

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController? controller;
  bool isFocus = false;
  late FocusNode textFieldFocusNode;
  String value = '';
  List<TextInputFormatter> inputFormatters = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initValue);
    textFieldFocusNode = FocusNode();

    inputFormatters.add(
        // Default the bytes is unlimit if null a
        // BytesLimitingTextInputFormatter(widget.maxBytes),
        // Deafault the length is unlimit if null
        LengthLimitingTextInputFormatter(
      widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
    ));

    if (widget.extraTextInputFormatters != null &&
        widget.extraTextInputFormatters!.isNotEmpty) {
      inputFormatters.addAll(widget.extraTextInputFormatters!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On unfocus
    if (!isFocus) {
      // Make sure the output not over max length
      if (widget.maxLength != null &&
          controller!.text.length > widget.maxLength!) {
        var newValue = controller!.text.substring(0, widget.maxLength);
        controller?.text = newValue;
        value = newValue;
        _onTextChanged(newValue);
      } else {
        controller?.text = widget.initValue;
        value = widget.initValue;
      }
    }
    return Focus(
        onFocusChange: _lostFocus,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (!isFocus) {
              setState(() {
                isFocus = true;
              });
              textFieldFocusNode.requestFocus();
            }
          },
          child: isFocus
              ? TextField(
                  focusNode: textFieldFocusNode,
                  inputFormatters: inputFormatters,
                  textAlign: widget.align,
                  enabled: widget.enabled,
                  controller: controller,
                  maxLines: widget.maxLine,
                  onChanged: _onTextChanged,
                  textInputAction: widget.textInputAction,
                  onEditingComplete: _onEditingComplete,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: MKStyle.t14R.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ResourceColors.minorTextColor,
                    ),
                    hintText: widget.displayHint ? widget.hintText : '',
                    border: InputBorder.none,
                  ),
                  style: MKStyle.t14R.copyWith(
                      color: ResourceColors.color_333333,
                      fontWeight: FontWeight.w500),
                  keyboardType: widget.keyboardType,
                  minLines: 1,
                )
              : Container(
                  padding: value.isNotEmpty
                      ? EdgeInsets.only(
                          left: widget.paddingLeft,
                          right: 4.0,
                          top: widget.paddingTop,
                          bottom: widget.paddingBottom)
                      : EdgeInsets.only(
                          left: widget.paddingLeft,
                          right: 1.0,
                          top: widget.paddingTop,
                          bottom: widget.paddingBottom),
                  alignment: widget.align == TextAlign.end
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    value.isNotEmpty
                        ? value
                        : widget.displayHint
                            ? widget.hintText!
                            : '',
                    maxLines: widget.maxLine,
                    textAlign: widget.align,
                    style: _buildTextStyle(),
                  ),
                ),
        ));
  }

  TextStyle _buildTextStyle() {
    if (value.isEmpty) {
      return MKStyle.t14R.copyWith(
          fontWeight: FontWeight.w500, color: ResourceColors.color_929292);
    } else {
      return MKStyle.t14R.copyWith(
          fontWeight: FontWeight.w500,
          color: ResourceColors.color_333333,
          overflow: widget.maxLine == 1 ? TextOverflow.ellipsis : null);
    }
  }

  void _onTextChanged(String value) {
    widget.onChangeValue?.call(value);
  }

  void _lostFocus(bool focus) {
    isFocus = focus;
    if (!focus) {
      widget.onEdittingCompleted?.call();
    } else {
      controller?.selection = TextSelection.fromPosition(
          TextPosition(offset: controller?.text.length ?? 0));
    }
  }

  void _onEditingComplete() {
    var currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    widget.onEdittingCompleted?.call();
  }
}
