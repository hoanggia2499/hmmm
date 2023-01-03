import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import '../../../../core/widgets/common/template_page.dart';
import '../../../menu_widget_test/pages/button_widget.dart';
import '../bloc/new_user_authentication_bloc.dart';

class NewUserAuthenticationPage extends StatefulWidget {
  int id;
  String tel;
  String name;
  String nameKana;

  NewUserAuthenticationPage(
      {required this.id,
      required this.tel,
      required this.name,
      required this.nameKana});

  @override
  _NewUserAuthenticationPageState createState() =>
      _NewUserAuthenticationPageState();
}

class _NewUserAuthenticationPageState extends State<NewUserAuthenticationPage> {
  TextEditingController codeController = TextEditingController();
  LoginModel loginModel = LoginModel();

  @override
  void initState() {
    getLoginModel();
    super.initState();
  }

  getLoginModel() async {
    loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarTitle: '',
      hasMenuBar: false,
      appBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<NewUserAuthenticationBloc, NewUserAuthenticationState>(
        listener: (buildContext, authState) {
          if (authState is LoginState) {
            Navigator.of(context)
                .pushNamed(AppRoutes.agreementPage, arguments: {
              'isNewUser': true,
              'memberNum': authState.memberNum,
              'userNum': authState.userNum
            });
          }
          // After API47 completed will call API45 to save data
          if (authState is Authenticated) {
            context.read<NewUserAuthenticationBloc>().add(PersonalRegisterEvent(
                widget.id, widget.tel, widget.name, widget.nameKana));
          }
          // If user already exists then call login api
          if (authState is AlreadyExists) {
            context
                .read<NewUserAuthenticationBloc>()
                .add(LoginSubmitted(widget.id, widget.tel, false));
          }
          // After API45 completed then call login api
          if (authState is RegistrationCompleted) {
            context
                .read<NewUserAuthenticationBloc>()
                .add(LoginSubmitted(widget.id, widget.tel, true));
          }
          if (authState is Error) {
            Logging.log.warn('Error');
            CommonDialog.displayDialog(context, authState.messageCode,
                authState.messageContent, false);
          }
          if (authState is TimeOut) {
            Logging.log.warn('TimeOut');
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NewUserAuthenticationBloc, NewUserAuthenticationState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      if (state is Loading) {
        EasyLoading.show();
      }
      return Container(
        color: ResourceColors.color_FF1979FF,
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(15.0),
            horizontal: Dimens.getWidth(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              child: Image.asset(
                'assets/images/png/mirulogo.png',
                fit: BoxFit.fill,
                height: Dimens.getHeight(80.0),
              ),
            ),
            SizedBox(height: Dimens.getHeight(40.0)),
            TextWidget(
              label: 'NEW_USER_AUTHENTICATION_GUIDE'.tr(),
              textStyle:
                  MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
            ),
            SizedBox(height: Dimens.getHeight(10.0)),
            _buildInputNumber(codeController, hintInput: 'INPUT_CODE'.tr()),
            SizedBox(height: Dimens.getHeight(20.0)),
            ButtonWidget(
              content: 'NEW_USER_AUTHENTICATION'.tr(),
              borderRadius: 3.0,
              clickButtonCallBack: getData,
              bgdColor: ResourceColors.green_bg,
              borderColor: ResourceColors.green_bg,
              textStyle:
                  MKStyle.t18R.copyWith(color: ResourceColors.color_FFFFFF),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputNumber(TextEditingController inputValue,
      {String hintInput = ''}) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: _buildBoxStyle(),
      child: TextField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: MKStyle.t18R,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
          hintText: hintInput,
          hintStyle: _buildHintTextStyle(),
        ),
        onChanged: (value) {
          Logging.log.info('Username: $value');
          //accountController.text = value;
        },
        controller: inputValue,
      ),
    );
  }

  BoxDecoration _buildBoxStyle() {
    return BoxDecoration(
        color: ResourceColors.color_FFFFFF,
        borderRadius: BorderRadius.circular(2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0, 2.0),
          ),
        ]);
  }

  TextStyle _buildHintTextStyle() {
    return MKStyle.t18R.copyWith(color: ResourceColors.text_grey);
  }

  Future getData() async {
    // 認証コード未入力
    if (codeController.text.length == 0) {
      CommonDialog.displayDialog(context, '5MA011CE', '5MA011CE'.tr(), false,
          buttonContent: 'C0NFIRM'.tr());
    } else if (codeController.text.length != 4) {
      CommonDialog.displayDialog(context, '5MA012CE', '5MA012CE'.tr(), false,
          buttonContent: 'C0NFIRM'.tr());
    } else {
      context.read<NewUserAuthenticationBloc>().add(UserAuthenticationSubmitted(
          widget.id,
          widget.tel,
          widget.name,
          widget.nameKana,
          codeController.text));
    }
  }
}
