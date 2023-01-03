import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class RowWidgetPattern24 extends StatefulWidget {
  final String txtLeft;
  final String txtRight;
  final Color colorLeft;

  RowWidgetPattern24({
    this.txtLeft = '',
    this.txtRight = '',
    this.colorLeft = ResourceColors.blue_bg,
  });
  @override
  _RowWidgetPattern24State createState() => _RowWidgetPattern24State();
}

class _RowWidgetPattern24State extends State<RowWidgetPattern24> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.colorLeft,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: Dimens.getWidth(10.0),
                          top: Dimens.getHeight(5.0),
                          bottom: Dimens.getHeight(5.0),
                          left: Dimens.getWidth(5.0)),
                      child: TextWidget(
                        label: widget.txtLeft,
                      ),
                    ),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  color: ResourceColors.grey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: Dimens.getWidth(10.0),
                        top: Dimens.getHeight(5.0),
                        bottom: Dimens.getHeight(5.0),
                        left: Dimens.getWidth(5.0)),
                    child: TextWidget(
                      label: widget.txtRight,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: Dimens.getHeight(1.0),
        )
      ],
    );
  }
}
