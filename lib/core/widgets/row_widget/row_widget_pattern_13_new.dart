import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

class RowWidgetPattern13New extends StatefulWidget {
  final String initValue;
  final String textStr;
  final String? textBtn;
  final bool requiredField;
  final bool isPattern7;
  final int typePattern;
  final VoidCallback? btnCallBack;
  final String firstValue;
  final String secondValue;

  RowWidgetPattern13New(
      {this.initValue = '',
      required this.textStr,
      this.textBtn,
      this.isPattern7 = false,
      this.btnCallBack,
      this.typePattern = 6,
      this.firstValue = "指定なし",
      this.secondValue = "指定なし",
      this.requiredField = false});

  @override
  State<RowWidgetPattern13New> createState() => _RowWidgetPattern13NewState();
}

class _RowWidgetPattern13NewState extends State<RowWidgetPattern13New> {
  var scaleValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.getHeight(10.0),
        bottom: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
        left: Dimens.getHeight(10.0),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: LeftSideWidget(
                textStr: widget.textStr,
                requiredField: widget.requiredField,
              )),
          Expanded(
              flex: 8,
              child: _buildButton(
                  widget.initValue, () => widget.btnCallBack!.call()))
        ],
      ),
    );
  }

  Widget _buildButton(String selectedValue, Function()? onPress) {
    String firstValue = widget.firstValue;
    String secondValue = widget.secondValue;

    return InkWell(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextWidget(
            label: '$firstValue～$secondValue',
            textStyle:
                MKStyle.t16R.copyWith(color: ResourceColors.color_000000),
          ),
          SizedBox(
            width: Dimens.getHeight(25.0),
          ),
          SvgPicture.asset(
            'assets/images/svg/next.svg',
            fit: BoxFit.fill, //Dimens.size15,
            width: Dimens.getWidth(8.0),
            height: Dimens.getHeight(15.0),
          )
        ],
      ),
    );
  }

  List<Color> createLinearColor() {
    return [
      Color(0xFFE2E2E2),
      Color(0xFFEBEBEB),
      Color(0xFFEAEAEA),
      Color(0xFFE9E9E9),
      Color(0xFFE5E5E5),
      Color(0xFFE4E4E4),
      Color(0xFFE3E3E3),
      Color(0xFFE2E2E2),
      Color(0xFFE1E1E1),
      Color(0xFFD9D9D9),
      Color(0xFFD8D8D8),
      Color(0xFFD7D7D7),
      Color(0xFFD6D6D6),
      Color(0xFFD5D5D5),
      Color(0xFFD4D4D4),
      Color(0xFFD3D3D3),
      Color(0xFFD2D2D2),
      Color(0xFFD1D1D1),
    ];
  }
}
