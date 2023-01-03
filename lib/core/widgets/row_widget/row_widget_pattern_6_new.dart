import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';

class RowWidgetPattern6New extends StatefulWidget {
  final String textStr;
  final String? textBtn;
  final bool requiredField;
  final bool isPattern7;
  final int typePattern;
  final VoidCallback? btnCallBack;
  final String value;
  int typeScreen;
  bool isHidden;

  RowWidgetPattern6New({
    required this.textStr,
    this.textBtn,
    this.isPattern7 = false,
    this.btnCallBack,
    this.typePattern = 6,
    this.value = "指定なし",
    this.typeScreen = Constants.SEARCH_INPUT_SCREEN,
    this.requiredField = false,
    this.isHidden = false,
  });

  @override
  State<RowWidgetPattern6New> createState() => _RowWidgetPattern6NewState();
}

class _RowWidgetPattern6NewState extends State<RowWidgetPattern6New> {
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
          left: Dimens.getHeight(10.0),
          bottom: Dimens.getHeight(10.0),
          right: Dimens.getHeight(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LeftSideWidget(
            textStr: widget.textStr,
            requiredField: widget.requiredField,
          ),
          Flexible(
              fit: FlexFit.tight,
              child: _buildButton(() => widget.btnCallBack!.call()))
        ],
      ),
    );
  }

  Widget _buildButton(Function()? onPress) {
    return InkWell(
      onTap: widget.isHidden ? () {} : onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: widget.typeScreen == Constants.SEARCH_INPUT_SCREEN
                ? TextWidget(
                    label: widget.value,
                    textStyle: MKStyle.t16R
                        .copyWith(color: ResourceColors.color_000000),
                  )
                : TextWidget(
                    label: widget.value,
                    textStyle: MKStyle.t14R.copyWith(
                        color: widget.value == Constants.SELECTION_STATUS ||
                                widget.isHidden
                            ? ResourceColors.color_929292
                            : ResourceColors.color_000000),
                    textOverflow: TextOverflow.visible,
                    alignment: TextAlign.end,
                  ),
          ),
          SizedBox(
            width: Dimens.getWidth(25.0),
          ),
          SvgPicture.asset(
            'assets/images/svg/next.svg',
            fit: BoxFit.fill, //Dimens.size15,
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
