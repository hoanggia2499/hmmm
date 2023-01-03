import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/row_widget/common/left_side_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/common/text_field_widget.dart';
import 'package:mirukuru/features/new_user_registration_notice/presentation/pages/new_user_registration_notice_page.dart';

class RowWidgetTextField extends StatefulWidget {
  final String initValue;
  final String textStr;
  final String? textBtn;
  final bool requiredField;
  final int typePattern;
  final int? maxLength;
  final VoidCallback? btnCallBack;
  Function(String)? onTextChange;
  final List<TextInputFormatter>? extraTextInputFormatters;
  final TextInputType? keyboardType;

  RowWidgetTextField(
      {this.initValue = '',
      required this.textStr,
      required this.onTextChange,
      this.textBtn,
      this.btnCallBack,
      this.maxLength,
      this.typePattern = 6,
      this.requiredField = false,
      this.extraTextInputFormatters,
      this.keyboardType});

  @override
  State<RowWidgetTextField> createState() => _RowWidgetTextFieldState();
}

class _RowWidgetTextFieldState extends State<RowWidgetTextField> {
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
          Expanded(
            flex: 3,
            child: LeftSideWidget(
              textStr: widget.textStr,
              requiredField: widget.requiredField,
            ),
          ),
          Expanded(
              flex: 7,
              child: _buildButton(
                  widget.initValue, () => widget.btnCallBack!.call()))
        ],
      ),
    );
  }

  Widget _buildButton(String selectedValue, Function()? onPress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: TextFieldWidget(
          initValue: widget.initValue,
          onChangeValue: (String value) {
            widget.onTextChange?.call(value);
          },
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType ?? TextInputType.multiline,
          maxLine: TEXT_MAX_LINE,
          extraTextInputFormatters: widget.extraTextInputFormatters,
        )),
        SizedBox(
          width: Dimens.getWidth(25.0),
        ),
        SvgPicture.asset(
          'assets/images/svg/next.svg',
          fit: BoxFit.fill, //Dimens.size15,
        )
      ],
    );
  }
}
