// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

class TextWidget extends StatefulWidget {
  final String label;
  TextStyle? textStyle;
  TextAlign alignment;

  TextOverflow textOverflow;

  bool? softWrap;

  int? maxLines;

  TextWidget(
      {Key? key,
      required this.label,
      this.textStyle,
      this.alignment = TextAlign.start,
      this.textOverflow = TextOverflow.visible,
      this.softWrap = true,
      this.maxLines})
      : super(key: key);

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.label,
      style: widget.textStyle ?? MKStyle.t12R,
      textAlign: widget.alignment,
      overflow: widget.textOverflow,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,
    );
  }
}
