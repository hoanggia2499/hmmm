// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DividerNoText extends StatefulWidget {
  DividerNoText(
      {this.thickness = 0.5,
      this.indent = 5.0,
      this.endIndent = 5.0,
      this.colorLine = Colors.grey,
      this.heightLine,
      Key? key})
      : super(key: key);

  double thickness;
  double indent;
  double endIndent;
  Color colorLine;
  double? heightLine;

  @override
  State<DividerNoText> createState() => _DividerNoTextState();
}

class _DividerNoTextState extends State<DividerNoText> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: widget.thickness,
      color: widget.colorLine,
      indent: widget.indent,
      endIndent: widget.endIndent,
      height: widget.heightLine,
    );
  }
}
