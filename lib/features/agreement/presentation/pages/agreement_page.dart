import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/process_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/agreement/presentation/bloc/agreement_bloc.dart';
import 'package:mirukuru/features/agreement/presentation/bloc/agreement_state.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';

import '../../../../core/widgets/common/custom_check_box.dart';
import '../../../login/data/models/login_model.dart';
import '../bloc/agreement_event.dart';

class AgreementPage extends StatefulWidget {
  final bool isNewUser;
  final String memberNum;
  final int userNum;

  /// isLoginAgreement use to difference between button back, logo, title,...  features before  first login or temp of service
  final bool isLoginAgreement;

  const AgreementPage(
      {Key? key,
      this.isNewUser = false,
      this.memberNum = '',
      this.userNum = 0,
      this.isLoginAgreement = true})
      : super(key: key);

  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  LoginModel loginModel = LoginModel();
  String agreement = "";
  bool checked = false;

  @override
  void initState() {
    context.read<AgreementBloc>().add(AgreeInit());
    super.initState();
    getLoginModel();
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarLogo: loginModel.logoMark.isEmpty
            ? ''
            : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
        appBarTitle: widget.isLoginAgreement ? "" : "TERMS_POLICY".tr(),
        storeName: loginModel.storeName2.isNotEmpty
            ? '${loginModel.storeName}\n${loginModel.storeName2}'
            : loginModel.storeName,
        hasMenuBar: !widget.isLoginAgreement,
        hasOnlyLogo: widget.isLoginAgreement,
        isHiddenLeadingPop: widget.isLoginAgreement,
        hiddenBottomBar: widget.isLoginAgreement,
        appBarColor: ResourceColors.color_FF1979FF,
        body: BlocListener<AgreementBloc, AgreementState>(
          listener: (context, agreementState) async {
            if (agreementState is Error) {
              await CommonDialog.displayDialog(
                  context,
                  agreementState.messageCode,
                  agreementState.messageContent,
                  false);
            }
            if (agreementState is TimeOut) {
              await CommonDialog.displayDialog(
                  context,
                  agreementState.messageCode,
                  agreementState.messageContent,
                  false);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage, (route) => false);
            }
            if (agreementState is SendMailState) {
              Navigator.of(context).pushNamed(AppRoutes.searchTopPage);
            }
          },
          child: _buildBody(),
        ));
  }

  Widget _buildBody() {
    return BlocBuilder<AgreementBloc, AgreementState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (state is Loading) {
          EasyLoading.show();
        }

        if (state is Loaded) {
          agreement = state.agreement;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 9, child: _buildTermOfUseWidget()),
            SizedBox(
              height: Dimens.getHeight(26.0),
            ),
            _buildCheckBox(),
            SizedBox(
              height: Dimens.getHeight(26.0),
            ),
            _buildAgreeButton(),
            _buildPads(),
          ],
        );
      },
    );
  }

  Widget _buildPads() => widget.isLoginAgreement
      ? SizedBox(
          height: Dimens.getHeight(10),
        )
      : SizedBox();

  Widget _buildCheckBox() {
    return Visibility(
      visible: widget.isLoginAgreement,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCheckbox(
              value: checked,
              selectedIconColor: Colors.green,
              borderColor: Colors.grey,
              size: DimenFont.sp28,
              iconSize: DimenFont.sp25,
              onChange: onCheckChanged,
            ),
            SizedBox(
              width: Dimens.getWidth(8),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  checked = !checked;
                });
              },
              child: TextWidget(
                label: "AGREEMENT_TERMS_POLICY".tr(),
                textStyle:
                    MKStyle.t14R.copyWith(color: ResourceColors.color_757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCheckChanged(bool? value) {
    setState(() {
      checked = value ?? false;
    });
  }

  _buildTermOfUseWidget() => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            top: Dimens.getHeight(15.0),
            left: Dimens.getWidth(10.0),
            right: Dimens.getWidth(10.0)),
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(10.0),
            horizontal: Dimens.getWidth(10.0)),
        decoration: _buildBoxDecoration(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: TextWidget(
            label: agreement,
            textStyle: MKStyle.t9R.copyWith(
                color: ResourceColors.text_black, fontWeight: FontWeight.w600),
            maxLines: null,
          ),
        ),
      );

  _buildAgreeButton() => Visibility(
        visible: widget.isLoginAgreement,
        child: checked
            ? ButtonWidget(
                content: 'BUTTON_TERMS_POLICY'.tr(),
                bgdColor: ResourceColors.color_0FA4EA,
                borderRadius: Dimens.getSize(100.0),
                width: (MediaQuery.of(context).size.width / 2.0),
                textStyle: MKStyle.t14R.copyWith(
                  color: ResourceColors.color_white,
                  fontWeight: FontWeight.w400,
                ),
                heightText: 1.5,
                clickButtonCallBack: () async {
                  ProcessUtil.instance.addProcess(processData);
                })
            : ButtonWidget(
                content: 'BUTTON_TERMS_POLICY'.tr(),
                bgdColor: ResourceColors.color_70,
                borderColor: ResourceColors.color_70,
                borderRadius: Dimens.getSize(100.0),
                width: (MediaQuery.of(context).size.width / 2.0),
                textStyle: MKStyle.t14R.copyWith(
                  color: ResourceColors.color_white,
                  fontWeight: FontWeight.w400,
                ),
                heightText: 1.5,
                clickButtonCallBack: () async {}),
      );

  _buildBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.getSize(8.0)),
        border: Border.all(color: ResourceColors.color_70, width: 1));
  }

  // process API38 SendMailNewUser
  Future processData() async {
    // set value login model
    await HelperFunction.instance.saveIsTermsAccepted();
    // In case of New User, send email. Otherwise just back the previous screen.
    if (widget.isNewUser) {
      context.read<AgreementBloc>().add(
          SendMailNewUserSubmitted(widget.memberNum, widget.userNum, context));
    } else {
      Navigator.of(context).pushNamed(AppRoutes.searchTopPage);
    }
  }
}
