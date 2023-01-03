import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_6.dart';

// Required field with button icon trailing row
class RowWidgetPattern9 extends StatefulWidget {
  final String firstTextStr;
  final String firstTextBtn;
  final VoidCallback? fistCallBack;

  RowWidgetPattern9(
      {required this.fistCallBack,
      required this.firstTextStr,
      required this.firstTextBtn});

  @override
  _Pattern9RowWidgetState createState() => _Pattern9RowWidgetState();
}

class _Pattern9RowWidgetState extends State<RowWidgetPattern9> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowWidgetPattern6(
          typePattern: 9,
          btnCallBack: () {
            widget.fistCallBack!.call();
          },
          isPattern7: true,
          textBtn: widget.firstTextBtn,
          requiredField: true,
          textStr: widget.firstTextStr,
        ),
      ],
    );
  }
}
