import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_text_view.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? packageInfo;
  LoginModel loginModel = LoginModel();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // get package info for version app
    packageInfo = await PackageInfo.fromPlatform();
    loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildAppBarLogo(loginModel),
      appBarTitle: "ABOUT".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      body: _buildBody(),
    );
  }

  String _buildAppBarLogo(LoginModel loginModel) => loginModel.logoMark.isEmpty
      ? ''
      : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';

  Widget _buildBody() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.getWidth(10.0),
            right: Dimens.getWidth(10.0),
            top: Dimens.getHeight(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildAppVersionInfo(), _buildAppTermOfUse()],
        ),
      ),
    );
  }

  _buildAppVersionInfo() => RowWidgetTextView(
        title: "VERSION".tr(),
        content: packageInfo != null ? "Ver " + packageInfo!.version : "",
        isShowNextIcon: false,
      );

  _buildAppTermOfUse() => RowWidgetTextView(
        title: "TERMS_POLICY".tr(),
        onTapped: () {
          Navigator.of(context).pushNamed(AppRoutes.agreementPage,
              arguments: {"isLoginAgreement": false});
        },
      );
}
