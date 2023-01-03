// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ListViewWidget extends StatefulWidget {
  Widget widgetList;
  Widget widgetListButton;
  int expandLeft;
  int expandRight;

  ListViewWidget(
      {required this.widgetList,
      required this.widgetListButton,
      this.expandLeft = 2,
      this.expandRight = 1});

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: widget.expandLeft,
              child: widget.widgetList,
            ),
            Expanded(
              flex: widget.expandRight,
              child: widget.widgetListButton,
            )
          ]),
    );
  }
}
