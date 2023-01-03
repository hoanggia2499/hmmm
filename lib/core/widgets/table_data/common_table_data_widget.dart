import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';

import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class CommonTableDataWidget extends StatefulWidget {
  List<RowItem> items = [];

  CommonTableDataWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _CommonTableDataWidgetState createState() => _CommonTableDataWidgetState();
}

class _CommonTableDataWidgetState extends State<CommonTableDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getScreenW(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: widget.items
            .map((item) => _buildItemRow(
                widget.items.indexOf(item), item.label, item.value))
            .toList(),
      ),
    );
  }

  Widget _buildItemRow(int index, String label, dynamic value) {
    bool isFooter = index == widget.items.length - 1;

    return Expanded(
      flex: value is String ? value.split('\n').length : 1,
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          flex: 1,
          child: _buildTextItem(isFooter, label, ResourceColors.color_E1E1E1,
              ResourceColors.color_white,
              textColor: ResourceColors.color_333333),
        ),
        Expanded(
          flex: 3,
          child: (value is Widget)
              ? value
              : _buildTextItem(isFooter, value, ResourceColors.color_FFFFFF,
                  ResourceColors.color_E1E1E1,
                  textColor: ResourceColors.color_000000,
                  alignment: Alignment.centerLeft),
        ),
      ]),
    );
  }

  Widget _buildTextItem(
      bool isFooter, String label, Color bgColor, Color dividerColor,
      {Color textColor = Colors.black,
      AlignmentGeometry alignment = Alignment.center}) {
    return Container(
      padding: EdgeInsets.only(
        left: (alignment == null || alignment == Alignment.center)
            ? Dimens.getWidth(3.0)
            : Dimens.getWidth(15.0),
      ),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border(
              bottom: isFooter
                  ? BorderSide.none
                  : BorderSide(color: dividerColor, width: 1))),
      child: Align(
        alignment: alignment,
        child: TextWidget(
          label: label,
          textStyle: MKStyle.t12R.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class RowItem {
  final String label;
  final dynamic value;

  RowItem(this.label, this.value);
}
