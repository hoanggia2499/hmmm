import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import '../../resources/resources.dart';
import '../common/divider_no_text.dart';
import '../common/text_widget.dart';

class DialogMenuWidget extends StatefulWidget {
  @override
  _DialogMenuWidgetState createState() => _DialogMenuWidgetState();
}

class _DialogMenuWidgetState extends State<DialogMenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Dimens.getWidth(Constants.HEIGHT_BOTTOM_TABBAR)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ResourceColors.color_white,
          child: Padding(
            padding: EdgeInsets.only(
                left: Dimens.getHeight(8.0),
                right: Dimens.getHeight(8.0),
                top: Dimens.getHeight(10.0)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      width: MediaQuery.of(context).size.width / 14,
                      'assets/images/svg/delete.svg',
                      fit: BoxFit.fill, //Dimens.size15,
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.getHeight(15.0),
                ),
                Container(
                    alignment: Alignment.center,
                    child: TextWidget(
                      label: "MENU".tr(),
                      textStyle: MKStyle.t16R
                          .copyWith(color: ResourceColors.color_3768CE),
                    )),
                SizedBox(
                  height: Dimens.getHeight(30.0),
                ),
                _buildItemMenu('QUOTATION_REQUEST_LIST'.tr(),
                    () => moveToPage(AppRoutes.requestQuotationPage)),
                _buildItemMenu(
                    'SELL_A_CAR'.tr(), () => moveToPage(AppRoutes.myPagePage)),
                // _buildItemMenu('お問い合わせ', () => moveToQuestionPage()),
                _buildItemMenu(
                    'MY_PAGE'.tr(), () => moveToPage(AppRoutes.myPagePage)),
                _buildItemMenu(
                    'INVITE'.tr(), () => moveToPage(AppRoutes.invitePage)),
                _buildItemMenu('STORE_INFO'.tr(),
                    () => moveToPage(AppRoutes.storeInformationPage)),
                _buildItemMenu(
                    'ABOUT'.tr(), () => moveToPage(AppRoutes.aboutPage)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemMenu(String itemMenu, VoidCallback eventCallBack) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(10.0), right: Dimens.getWidth(10.0)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Dimens.getWidth(10.0),
              top: Dimens.getHeight(15.0),
            ),
            child: InkWell(
              onTap: () => eventCallBack.call(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  label: itemMenu,
                  textStyle: MKStyle.t16R.copyWith(
                    color: ResourceColors.color_757575,
                  ),
                ),
              ),
            ),
          ),
          DividerNoText(
            indent: 0.0,
            endIndent: 0.0,
          ),
        ],
      ),
    );
  }

  void moveToPage(String routeName) {
    Logging.log.info("Navigated to $routeName");
    Navigator.of(context).popAndPushNamed(routeName);
  }

  void moveToQuestionPage() {
    Navigator.of(context).pushNamed(AppRoutes.questionPage);
  }

  void moveToCarInformation() {
    Navigator.of(context).pushNamed(AppRoutes.carRegistPage);
  }
}
