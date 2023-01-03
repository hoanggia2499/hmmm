import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

import 'common/textfield_border.dart';

// Comment or note input row
class RowWidgetPattern16 extends StatefulWidget {
  final String initValue;
  final Function(String)? onTextChange;

  RowWidgetPattern16({required this.initValue, this.onTextChange});
  @override
  _RowWidgetPattern16State createState() => _RowWidgetPattern16State();
}

class _RowWidgetPattern16State extends State<RowWidgetPattern16> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFieldBorder(
            hasColorFocus: false,
            hasEnabledBorder: false,
            height: Dimens.getHeight(5.0),
            width: MediaQuery.of(context).size.width,
            onSelectEvent: () {},
            initValue: widget.initValue,
            onTextChange: (String value) {
              widget.onTextChange?.call(value);
            }),
        SizedBox(
          height: Dimens.getHeight(10.0),
        ),
        TextWidget(
          label: "PLEASE_ENTER_YOUR_QUESTION_IN_500_CHARACTERS_OR_LESS".tr(),
          alignment: TextAlign.left,
        )
      ],
    );
  }
}
