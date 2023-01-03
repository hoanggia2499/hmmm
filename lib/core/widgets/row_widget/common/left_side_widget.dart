import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class LeftSideWidget extends StatefulWidget {
  final bool requiredField;
  final String textStr;

  LeftSideWidget({this.requiredField = false, required this.textStr});

  @override
  _LeftSideWidgetState createState() => _LeftSideWidgetState();
}

class _LeftSideWidgetState extends State<LeftSideWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextWidget(
          label: widget.textStr,
          textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
        ),
        SizedBox(
          width: Dimens.getWidth(10.0),
        ),
        Visibility(
          visible: widget.requiredField,
          child: TextWidget(
            label: "REQUIRED".tr(),
            textStyle: MKStyle.t12R.copyWith(color: ResourceColors.red_bg),
          ),
        )
      ],
    );
  }
}
