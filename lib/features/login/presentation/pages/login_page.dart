import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/process_util.dart';
import 'package:mirukuru/core/util/version_utils/version_utils.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/features/app_bloc/app_bloc.dart';
import 'package:mirukuru/features/login/presentation/bloc/login_bloc.dart';
import '../../../menu_widget_test/pages/button_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CancelableOperation? cancelableOperator;
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late AppBloc appBloc;

  @override
  void initState() {
    // DEBUG MODE only
    if (Common.isDebugMode) {
      idController.text = '196'; // 1397 has no Store Image
      passController.text = '0987654321';
    }
    super.initState();

    appBloc = BlocProvider.of<AppBloc>(context);

    if (!appBloc.hasVersionChecked) {
      context.read<LoginBloc>().add(CheckUpdateEvent(
          context: context,
          eventAction: CheckUpdateEventAction.firstLaunchApp));
    } else {
      context.read<LoginBloc>().add(LoginInit());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ResourceColors.color_FF3C83EC,
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: BlocListener<LoginBloc, LoginState>(
            listener: (buildContext, loginState) async {
              if (loginState is LoginSuccessful) {
                Navigator.of(context).pushNamed(AppRoutes.agreementPage,
                    arguments: {"isLoginAgreement": true});
              }
              if (loginState is LoginInitState) {
                Navigator.of(context).pushNamed(AppRoutes.searchTopPage);
              }
              if (loginState is Error) {
                Logging.log.info('error occur');
                CommonDialog.displayDialog(context, loginState.messageCode,
                    loginState.messageContent, false);
              }
              if (loginState is UnavailableUser) {
                Navigator.of(context).pushNamed(AppRoutes.unAvailableUserPage);
              }
              if (loginState is CheckedUpdateState) {
                appBloc.hasVersionChecked = true;
                if (loginState.checkUpdateType == CheckUpdateType.optional) {
                  if (loginState.eventAction ==
                      CheckUpdateEventAction.firstLaunchApp) {
                    context.read<LoginBloc>().add(LoginInit());
                  } else if (loginState.eventAction ==
                      CheckUpdateEventAction.beforeProcessingLogin) {
                    ProcessUtil.instance.addProcess(getData);
                  } else {
                    ProcessUtil.instance.addProcess(newUserRegistrationNotice);
                  }
                }
              }
            },
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      if (state is Loading) {
        EasyLoading.show();
      }
      return Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(15.0),
            horizontal: Dimens.getWidth(15.0)),
        decoration: _buildBoxDecoration(),
        child: Column(
          children: [
            SizedBox(height: Dimens.getHeight(50.0)),
            _buildLogo(),
            SizedBox(height: Dimens.getHeight(80.0)),
            _buildLoginGuide(),
            SizedBox(height: Dimens.getHeight(20.0)),
            _buildInput(idController,
                hintInput: 'HINT_USERNAME'.tr(), maxLength: 18),
            SizedBox(height: Dimens.getHeight(10.0)),
            _buildInput(passController,
                hintInput: 'HINT_PASSWORD'.tr(),
                isTypeNumber: false,
                obscureText: true),
            SizedBox(height: Dimens.getHeight(15.0)),
            _buildLogin(),
            SizedBox(height: Dimens.getHeight(30.0)),
            _buildLoginGuideFirst(),
            SizedBox(height: Dimens.getHeight(25.0)),
            _buildSignUp()
          ],
        ),
      );
    });
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

  Widget _buildLogo() {
    return Align(
      child: SvgPicture.asset(
        'assets/images/svg/mirulogo.svg',
        fit: BoxFit.fill, //Dimens.size15,
      ),
    );
  }

  Widget _buildLoginGuide() {
    return TextWidget(
      alignment: TextAlign.center,
      label: 'LOGIN_GUIDE'.tr(),
      textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
    );
  }

  Widget _buildLoginGuideFirst() {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 8,
          right: MediaQuery.of(context).size.width / 8),
      child: TextWidget(
        alignment: TextAlign.center,
        label: 'LOGIN_GUIDE_FIRST'.tr(),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
      ),
    );
  }

  Widget _buildSignUp() {
    return ButtonWidget(
      size: Dimens.getHeight(8),
      width: MediaQuery.of(context).size.width * 6 / 10,
      content: 'SIGN_UP'.tr(),
      borderRadius: 20.0,
      clickButtonCallBack: () {
        WidgetsFlutterBinding.ensureInitialized();
        if (!appBloc.hasVersionChecked) {
          context.read<LoginBloc>().add(CheckUpdateEvent(
              context: context,
              eventAction: CheckUpdateEventAction.beforeProcessingSignUp));
        } else {
          ProcessUtil.instance.addProcess(newUserRegistrationNotice);
        }
      },
      bgdColor: ResourceColors.color_6DC432,
      borderColor: ResourceColors.color_6DC432,
      textStyle: MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF),
      heightText: 1.2,
    );
  }

  Widget _buildLogin() {
    return ButtonWidget(
      size: Dimens.getHeight(8),
      width: MediaQuery.of(context).size.width * 6 / 10,
      content: 'LOGIN'.tr(),
      borderRadius: 20.0,
      clickButtonCallBack: () {
        WidgetsFlutterBinding.ensureInitialized();
        if (!appBloc.hasVersionChecked) {
          context.read<LoginBloc>().add(CheckUpdateEvent(
              context: context,
              eventAction: CheckUpdateEventAction.beforeProcessingLogin));
        } else {
          ProcessUtil.instance.addProcess(getData);
        }
      },
      bgdColor: ResourceColors.color_FF0FA4EA,
      borderColor: ResourceColors.color_FF0FA4EA,
      textStyle: MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF),
      heightText: 1.2,
    );
  }

  Widget _buildInput(TextEditingController inputValue,
      {String hintInput = '',
      int? maxLength,
      bool isTypeNumber = true,
      bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 8,
          right: MediaQuery.of(context).size.width / 8),
      child: TextField(
        textInputAction: TextInputAction.next,
        keyboardType: isTypeNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        obscureText: obscureText,
        style: MKStyle.t14R,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(width: 2, color: ResourceColors.color_929292),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
                  BorderSide(width: 2, color: ResourceColors.color_929292),
            ),
            hintText: hintInput,
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            hintStyle: _buildHintTextStyle(),
            counterText: ''),
        onChanged: (value) {
          Logging.log.info('Input: $value');
        },
        controller: inputValue,
      ),
    );
  }

  TextStyle _buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  Future getData() async {
    context
        .read<LoginBloc>()
        .add(LoginSubmitted(idController.text, passController.text));
  }

  Future newUserRegistrationNotice() async {
    Navigator.of(context).pushNamed(AppRoutes.newUserRegistrationNoticePage);
  }
}
