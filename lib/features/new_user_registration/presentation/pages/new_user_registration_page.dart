import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import '../../../menu_widget_test/pages/button_widget.dart';
import '../bloc/user_registration_bloc.dart';

class NewUserRegistrationPage extends StatefulWidget {
  @override
  _NewUserRegistrationPageState createState() =>
      _NewUserRegistrationPageState();
}

class _NewUserRegistrationPageState extends State<NewUserRegistrationPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nameKanaController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final String privacyPolicyURL = "https://www.mlkl.jp/info/privacy.html";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ResourceColors.color_FF3C83EC,
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: BlocListener<UserRegistrationBloc, UserRegistrationState>(
            listener: (buildContext, responseState) async {
              if (responseState is Error) {
                await CommonDialog.displayDialog(
                    context,
                    responseState.messageCode,
                    responseState.messageContent,
                    false);
              }
              if (responseState is DialogState) {
                await CommonDialog.displayConfirmDialog(
                  context,
                  Text(
                    responseState.contentDialog,
                    textAlign: TextAlign.start,
                    style: MKStyle.t16R
                        .copyWith(color: ResourceColors.color_FFFFFF),
                  ),
                  'BTN_OK'.tr(),
                  'BTN_CANCEL'.tr(),
                  okEvent: () async {
                    if (responseState.isExists) {
                      // process API Login
                      context.read<UserRegistrationBloc>().add(LoginSubmitted(
                          idController.text, telController.text, false));
                    } else {
                      if (responseState.personalAuthFlag == '1') {
                        // call API47 RequestRegister
                        context.read<UserRegistrationBloc>().add(
                            RequestRegisterSubmitted(
                                idController.text,
                                telController.text,
                                nameController.text,
                                nameKanaController.text));
                        // await callAPIRequestRegister(event, emit);
                      } else if (responseState.personalAuthFlag == '0') {
                        // call API45 PersonalRegister
                        context.read<UserRegistrationBloc>().add(
                            PersonalRegisterSubmitted(
                                idController.text,
                                telController.text,
                                nameController.text,
                                nameKanaController.text));
                        // await callAPIPersonalRegister(event, emit);
                      }
                    }
                  },
                  cancelEvent: () {
                    return;
                  },
                );
              }
              if (responseState is LoginState) {
                await Navigator.of(context)
                    .pushNamed(AppRoutes.agreementPage, arguments: {
                  'isNewUser': responseState.isNewUser,
                  'memberNum': responseState.memberNum,
                  'userNum': responseState.userNum
                });
              }
              if (responseState is RequestRegisterState) {
                await Navigator.of(context)
                    .pushNamed(AppRoutes.newUserAuthenticationPage, arguments: {
                  'id': int.parse(idController.text),
                  'tel': telController.text,
                  'name': nameController.text,
                  'nameKana': nameKanaController.text,
                });
              }
              if (responseState is PersonalRegisterState) {
                // process API Login
                context.read<UserRegistrationBloc>().add(LoginSubmitted(
                    idController.text, telController.text, true));
              }
            },
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<UserRegistrationBloc, UserRegistrationState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      if (state is Loading) {
        EasyLoading.show();
      }
      return SingleChildScrollView(
        controller: _controller,
        child: Container(
          height: ScreenUtil.getInstance().screenHeight,
          // color: ResourceColors.color_FF1979FF,
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
              SizedBox(height: Dimens.getHeight(30.0)),
              _buildRegisTrationGuide(),
              SizedBox(height: Dimens.getHeight(15.0)),
              _buildInput(idController,
                  hintInput: 'INPUT_ID'.tr(), maxLength: 18),
              SizedBox(height: Dimens.getHeight(10.0)),
              _buildInput(telController, hintInput: 'INPUT_TEL'.tr()),
              SizedBox(height: Dimens.getHeight(10.0)),
              _buildInput(nameController,
                  hintInput: 'INPUT_NAME'.tr(), isTypeNumber: false),
              SizedBox(height: Dimens.getHeight(10.0)),
              _buildInput(nameKanaController,
                  hintInput: 'INPUT_NAME_KANA'.tr(),
                  isTypeNumber: false,
                  isInputNameKana: true),
              SizedBox(height: Dimens.getHeight(40.0)),
              _buildNewUserRegistration()
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNewUserRegistration() {
    return Center(
      child: ButtonWidget(
        size: Dimens.getHeight(8),
        width: MediaQuery.of(context).size.width * 6 / 10,
        content: 'NEW_USER_REGISTRATION_NEXT'.tr(),
        borderRadius: 20.0,
        clickButtonCallBack: () async {
          await processNewUserRegistration();
        },
        bgdColor: ResourceColors.color_FF0FA4EA,
        borderColor: ResourceColors.color_FF4BC9FD,
        textStyle: MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF),
        heightText: 1.2,
      ),
    );
  }

  Widget _buildInput(TextEditingController inputValue,
      {String hintInput = '',
      int? maxLength,
      bool isInputNameKana = false,
      bool isTypeNumber = true}) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 8,
          right: MediaQuery.of(context).size.width / 8),
      child: TextField(
        textInputAction:
            isInputNameKana ? TextInputAction.done : TextInputAction.next,
        keyboardType: isTypeNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
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
          isDense: true, // Added this
          contentPadding: EdgeInsets.all(8),
          hintStyle: _buildHintTextStyle(),
          counterText: '',
        ),
        onChanged: (value) {
          Logging.log.info('Username: $value');
        },
        controller: inputValue,
      ),
    );
  }

  Widget _buildRegisTrationGuide() {
    return Center(
      child: TextWidget(
        alignment: TextAlign.center,
        label: 'NEW_USER_REGISTRATION_GUIDE'.tr(),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
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

  TextStyle _buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  // process new user registration
  Future processNewUserRegistration() async {
    // check validation
    StringBuffer errorText = new StringBuffer();
    if (idController.text.length == 0) {
      await createErrorMessage(errorText, ErrorCode.MA002CE.tr());
    } else if (idController.text.length > 2147483647) {
      // Int型の最大より大きい数字を入力された場合
      await createErrorMessage(errorText, ErrorCode.MA003CE.tr());
    }
    if (telController.text.length == 0) {
      createErrorMessage(errorText, ErrorCode.MA004CE.tr());
    } else if (telController.text.length > 20) {
      createErrorMessage(errorText, ErrorCode.MA005CE.tr());
    }
    if (nameController.text.length == 0) {
      createErrorMessage(errorText, ErrorCode.MA006CE.tr());
    } else if (nameController.text.length > 50) {
      createErrorMessage(errorText, ErrorCode.MA007CE.tr());
    }
    if (nameKanaController.text.length == 0) {
      createErrorMessage(errorText, ErrorCode.MA008CE.tr());
    } else if (nameKanaController.text.length > 50) {
      createErrorMessage(errorText, ErrorCode.MA009CE.tr());
    }

    // エラーであれば、ダイアログで表示する
    if (errorText.length > 0) {
      await CommonDialog.displayDialog(context, '', errorText.toString(), false,
          buttonContent: 'CONFIRM'.tr(), textAlignContent: TextAlign.start);
    } else {
      context.read<UserRegistrationBloc>().add(UserRegistrationSubmitted(
          idController.text,
          telController.text,
          nameController.text,
          nameKanaController.text));
    }
  }

  Future createErrorMessage(
      StringBuffer errorMessage, String appendMessage) async {
    if (errorMessage.length > 0) {
      errorMessage.write("\n");
    }
    errorMessage.write(appendMessage);
  }

  @override
  void dispose() {
    idController.dispose();
    telController.dispose();
    nameController.dispose();
    nameKanaController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
