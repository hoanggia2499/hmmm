import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import '../../../menu_widget_test/pages/button_widget.dart';

class NewUserRegistrationNoticePage extends StatefulWidget {
  @override
  _NewUserRegistrationNoticePageState createState() =>
      _NewUserRegistrationNoticePageState();
}

class _NewUserRegistrationNoticePageState
    extends State<NewUserRegistrationNoticePage> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ResourceColors.color_FF3C83EC,
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _controller,
      child: Container(
        height: ScreenUtil.getInstance().screenHeight,
        decoration: _buildBoxDecoration(),
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(15.0),
            horizontal: Dimens.getWidth(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimens.getHeight(50.0)),
            _buildLogo(),
            SizedBox(height: Dimens.getHeight(40.0)),
            _buildBackButton(),
            SizedBox(height: Dimens.getHeight(45.0)),
            _buildRegistrationNotice(),
            SizedBox(height: Dimens.getHeight(40.0)),
            _buildNewUserRegistrationNotice()
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationNotice() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(30.0), right: Dimens.getWidth(30.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ResourceColors.color_white,
            border: Border.all(color: ResourceColors.color_0058A6, width: 3.0)),
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: TextWidget(
              alignment: TextAlign.center,
              label: "NEW_USER_REGISTRATION_NOTICE_INTRODUCE".tr(),
              textStyle: MKStyle.t16R,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewUserRegistrationNotice() {
    return Center(
      child: ButtonWidget(
        size: Dimens.getHeight(8),
        width: MediaQuery.of(context).size.width * 6 / 10,
        content: 'NEW_USER_REGISTRATION_NOTICE_CONTINUE_REGISTER'.tr(),
        borderRadius: 20.0,
        clickButtonCallBack: () async {
          Navigator.of(context).pushNamed(AppRoutes.newUserRegistrationPage);
        },
        bgdColor: ResourceColors.color_FF0FA4EA,
        borderColor: ResourceColors.color_FF4BC9FD,
        textStyle: MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF),
        heightText: 1.2,
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: SvgPicture.asset(
          'assets/images/svg/back.svg',
          fit: BoxFit.fill, //Dimens.size15,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      child: SvgPicture.asset(
        'assets/images/svg/mirulogo.svg',
        fit: BoxFit.fill, //Dimens.size15,
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFEEF9FF),
          const Color(0xFFFDFEFF),
          const Color(0xFFFFFFFF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

const int TEXT_MAX_LINE = 5;
