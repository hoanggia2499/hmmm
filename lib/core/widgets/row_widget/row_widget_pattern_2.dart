import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

// Display information row
class RowWidgetPattern2 extends StatefulWidget {
  const RowWidgetPattern2(
      {required this.title,
      required this.value,
      this.textAlign = TextAlign.start});

  final String title;
  final String value;
  final TextAlign textAlign;

  @override
  RowWidgetPattern2State createState() => RowWidgetPattern2State();
}

class RowWidgetPattern2State extends State<RowWidgetPattern2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.getWidth(7.0)),
                child: TextWidget(
                  label: widget.title,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(right: Dimens.getWidth(7.0)),
                child: TextWidget(
                  label: widget.value,
                  alignment: widget.textAlign,
                ),
              ),
            )
          ],
        ),
        Divider(
          indent: 0.0,
          endIndent: 0.0,
          thickness: 1.0,
          color: Colors.black,
        )
      ],
    );
  }
}
