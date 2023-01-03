import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';

import 'common/textfield_border.dart';

class RowWidgetPattern25 extends StatefulWidget {
  @override
  _RowWidgetPattern25State createState() => _RowWidgetPattern25State();
}

class _RowWidgetPattern25State extends State<RowWidgetPattern25> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: ResourceColors.blue_bg,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.getHeight(5.0),
              horizontal: Dimens.getWidth(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: TextFieldBorder(
                    hintText: "INPUT_TEL".tr(),
                    onSelectEvent: () {},
                    height: ScreenUtil.getInstance().getHeight(40.0),
                    onTextChange: (String value) {
                      // widget.onTextChange?.call(value);
                    }),
              ),
              SizedBox(
                width: Dimens.getWidth(5.0),
              ),
              Expanded(
                flex: 2,
                child: ButtonWidget(
                  borderRadius: 6,
                  textStyle:
                      MKStyle.t17R.copyWith(color: ResourceColors.color_white),
                  bgdColor: ResourceColors.color_FF4BC9FD,
                  content: "CONTACT_BOOK".tr(),
                  clickButtonCallBack: () {},
                ),
              )
            ],
          ),
        ));
  }
}
