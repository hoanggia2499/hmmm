import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import '../../../features/menu_widget_test/pages/button_widget.dart';
import '../../resources/resources.dart';
import '../../resources/text_styles.dart';

class ShowPhoto extends StatelessWidget {
  const ShowPhoto({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      // appBarLogo: loginModel.logoMark.isEmpty
      //     ? ''
      //     : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "PHOTO_CONFIRMATION".tr(),
      // storeName: loginModel.storeName2.isNotEmpty
      //     ? '${loginModel.storeName}\n${loginModel.storeName2}'
      //     : loginModel.storeName,
      hasMenuBar: false,
      hiddenBottomBar: true,
      appBarColor: ResourceColors.color_FF1979FF,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.getHeight(400),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: Dimens.getHeight(10.0)),
              child: ButtonWidget(
                content: 'CONFIRM_DELETE'.tr(),
                // bgdColor: ResourceColors.color_70,
                // borderColor: ResourceColors.color_70,
                borderRadius: Dimens.getSize(100.0),
                width: (MediaQuery.of(context).size.width / 2.0),
                textStyle: MKStyle.t14R.copyWith(
                  color: ResourceColors.color_white,
                  fontWeight: FontWeight.w400,
                ),
                heightText: 1.5,
                clickButtonCallBack: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
