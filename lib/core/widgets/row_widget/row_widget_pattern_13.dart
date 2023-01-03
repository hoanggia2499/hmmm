import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/dimens.dart';

import '../common/text_widget.dart';

// Range button with icon trailing
class RowWidgetPattern13 extends StatefulWidget {
  const RowWidgetPattern13(
      {required this.title,
      this.sttValue = '指定なし',
      this.endValue = '指定なし',
      this.onStartPress,
      this.onEndPress});

  final String title;
  final String sttValue;
  final String endValue;
  final Function()? onStartPress;
  final Function()? onEndPress;

  @override
  _RowWidgetPattern13 createState() => _RowWidgetPattern13();
}

class _RowWidgetPattern13 extends State<RowWidgetPattern13> {
  var scaleValue = 1.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFirstRow(),
        SizedBox(
          height: Dimens.getHeight(10.0),
        ),
        _buildSecondRow(),
        Divider(
          endIndent: 0.0,
          indent: 0.0,
          thickness: 1.0,
          color: Colors.black,
        )
      ],
    );
  }

  Widget _buildFirstRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextWidget(
            label: widget.title,
          ),
        ),
        Expanded(
            flex: 6,
            child:
                _buildRightSide(widget.sttValue, onPress: widget.onStartPress))
      ],
    );
  }

  Widget _buildSecondRow() {
    return Row(
      children: [
        Expanded(flex: 4, child: Container()),
        Expanded(
            flex: 6,
            child: _buildRightSide(widget.endValue,
                onPress: widget.onEndPress, hasRangeChar: true))
      ],
    );
  }

  Widget _buildRightSide(String selectedValue,
      {Function()? onPress, bool hasRangeChar = false}) {
    if (hasRangeChar) {
      return Row(
        children: [
          TextWidget(
            label: '～',
          ),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(child: _buildButton(selectedValue, onPress))
        ],
      );
    }
    return _buildButton(selectedValue, onPress);
  }

  Widget _buildButton(String selectedValue, Function()? onPress) {
    return Container(
      height: Dimens.getHeight(25.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              tileMode: TileMode.mirror,
              colors: createLinearColor()),
          boxShadow: [
            BoxShadow(color: Color(0xFFA2A2A2), offset: Offset(0, 1)),
            BoxShadow(color: Color(0xFFCDCDCD), offset: Offset(1, 0))
          ],
          borderRadius: BorderRadius.circular(1.0)),
      child: InkWell(
          onTap: onPress,
          splashColor: Colors.orange,
          highlightColor: Colors.orange,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(label: selectedValue),
                Transform.scale(
                  scale: scaleValue,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: DimenFont.sp20,
                  ),
                )
              ],
            ),
          )),
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

  MaterialStateProperty<Color>? createSettingColor(
      Color onPressColor, Color colorForAll) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return onPressColor;
      }
      return colorForAll;
    });
  }

  MaterialStateProperty<EdgeInsetsGeometry> createPadding() {
    return MaterialStateProperty.resolveWith(
      (states) => EdgeInsets.symmetric(
          vertical: Dimens.getHeight(8.0), horizontal: Dimens.getWidth(8.0)),
    );
  }

  MaterialStateProperty<OutlinedBorder> createShape() {
    return MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0))));
  }
}
