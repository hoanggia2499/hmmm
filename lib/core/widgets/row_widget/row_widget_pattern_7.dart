import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_6.dart';

// Text button with icon trailing row
class RowWidgetPattern7 extends StatefulWidget {
  final String firstTextStr;
  final String secondTextStr;
  final String firstTextBtn;
  final String secondTextBtn;
  final VoidCallback? fistCallBack;
  final VoidCallback? secondCallBack;

  RowWidgetPattern7({
    required this.firstTextBtn,
    required this.firstTextStr,
    required this.secondTextBtn,
    required this.secondTextStr,
    this.fistCallBack,
    this.secondCallBack,
  });

  @override
  _RowWidgetPattern7State createState() => _RowWidgetPattern7State();
}

class _RowWidgetPattern7State extends State<RowWidgetPattern7> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowWidgetPattern6(
          typePattern: 7,
          btnCallBack: () {
            widget.fistCallBack!.call();
          },
          isPattern7: true,
          textBtn: widget.firstTextBtn,
          requiredField: false,
          textStr: widget.firstTextStr,
        ),
        RowWidgetPattern6(
          typePattern: 7,
          btnCallBack: () {
            widget.secondCallBack!.call();
          },
          isPattern7: true,
          textBtn: widget.secondTextBtn,
          requiredField: false,
          textStr: widget.secondTextStr,
        ),
      ],
    );
  }
}
