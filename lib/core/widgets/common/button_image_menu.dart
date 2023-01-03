// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButtonImageMenu extends StatefulWidget {
  final String imageOn;
  final String imageOff;
  final VoidCallback onPress;
  final int flex;

  ButtonImageMenu(
      {required this.imageOn,
      required this.imageOff,
      required this.onPress,
      this.flex = 1,
      Key? key})
      : super(key: key);

  @override
  _ButtonImageMenu createState() => _ButtonImageMenu();
}

class _ButtonImageMenu extends State<ButtonImageMenu> {
  bool clickedFlag = false;
  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: widget.flex,
        child: GestureDetector(
          onTapDown: (tdDetail) => changeClickFlag(true),
          onTapUp: (tapUpDetail) => changeClickFlag(false),
          onTapCancel: () => changeClickFlag(false),
          onTap: widget.onPress,
          child: Image.asset(
            'assets/images/png/${clickedFlag ? widget.imageOn : widget.imageOff}',
          ),
        ));
  }

  void changeClickFlag(bool value) {
    setState(() {
      clickedFlag = value;
    });
  }
}
