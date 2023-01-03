import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

// 2 buttons row
class RowWidgetPattern11 extends StatefulWidget {
  const RowWidgetPattern11(
      {required this.cancelTitle,
      required this.okTitle,
      this.okPress,
      this.cancelPress});

  final String cancelTitle;
  final Function()? cancelPress;
  final String okTitle;
  final Function()? okPress;

  @override
  _RowWidgetPattern11 createState() => _RowWidgetPattern11();
}

class _RowWidgetPattern11 extends State<RowWidgetPattern11> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: TextButton(
            onPressed: widget.cancelPress,
            child: TextWidget(
              label: widget.cancelTitle,
              textStyle:
                  MKStyle.t12R.copyWith(color: ResourceColors.color_white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey.withOpacity(0.3);
              }
              return Colors.grey;
            })),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: TextButton(
            onPressed: widget.okPress,
            child: TextWidget(
              label: widget.okTitle,
              textStyle:
                  MKStyle.t12R.copyWith(color: ResourceColors.color_white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return ResourceColors.color_FF4BC9FD.withOpacity(0.3);
              }
              return ResourceColors.color_FF4BC9FD;
            })),
          ),
        ),
      ],
    );
  }
}
