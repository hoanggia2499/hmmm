import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_bloc.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_event.dart';
import 'package:mirukuru/features/invite/presentation/bloc/invite_state.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class InvitePage extends StatefulWidget {
  InvitePage({this.isNewUser = false, this.memberNum = '', this.userNum = 0});
  final bool isNewUser;
  final String memberNum;
  final int userNum;

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  LoginModel loginModel = LoginModel();

  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  InviteFriendRequestModel? requestModel;

  Function doInviteFriend(BuildContext context) => () {
        context
            .read<InviteBloc>()
            .add(InviteFriendEvent(requestModel!, loginModel.storeName));
      };

  @override
  void initState() {
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
      appBarTitle: "INVITE_FRIEND".tr(),
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      appBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<InviteBloc, InviteState>(
        listener: (context, state) async {
          if (state is Error) {
            await CommonDialog.displayDialog(context, state.errorModel.msgCode,
                eventCallBack: () {
              if (state.errorModel.msgCode == '5MA015SE') {
                Navigator.pop(context);
              }
            }, state.errorModel.msgContent, false);
          }

          if (state is TimeOut) {
            await CommonDialog.displayDialog(
              context,
              state.errorModel.msgCode,
              state.errorModel.msgContent,
              false,
            );

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        if (state is InvitedFriend) {
          Logging.log.info("Invited Friend");
        }

        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: ScreenUtil.getScreenW(context),
            margin: EdgeInsets.only(
                left: Dimens.getWidth(10.0),
                right: Dimens.getWidth(10.0),
                top: Dimens.getHeight(15.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSubtitle("INVITE_SMS_OR_EMAIL".tr()),
                _buildInviteBySms(),
                SizedBox(
                  height: Dimens.getHeight(30.0),
                ),
                _buildInviteByEmail()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle(String subTitle) {
    return SubTitle(
      label: subTitle,
      textStyle: MKStyle.t14R.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _buildInviteBySms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: _buildInput(telController,
                  hintInput: "TEL", textInputType: TextInputType.phone),
            ),
            SizedBox(
              width: Dimens.getWidth(30.0),
            ),
            _buildSyncContactsButton(false)
          ],
        ),
        SizedBox(
          height: Dimens.getHeight(20.0),
        ),
        _buildSendSmsButton(),
        _buildInviteBySmsNotice()
      ],
    );
  }

  _buildInviteByEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: _buildInput(emailController,
                  hintInput: "EMAIL_ADDRESS".tr(),
                  textInputType: TextInputType.emailAddress),
            ),
            SizedBox(
              width: Dimens.getWidth(30.0),
            ),
            _buildSyncContactsButton(true)
          ],
        ),
        SizedBox(
          height: Dimens.getHeight(20.0),
        ),
        _buildSendEmailButton(),
      ],
    );
  }

  Widget _buildSyncContactsButton(bool isMail) => ButtonWidget(
        width: ScreenUtil.getScreenH(context) / 6.0,
        content: "INVITE_SYNC_CONTACTS".tr(),
        clickButtonCallBack: () async {
          syncContact(isMail);
        },
        bgdColor: ResourceColors.color_E1E1E1,
        borderColor: ResourceColors.color_929292,
        hasBorderRadius: true,
        borderRadius: Dimens.getSize(5.0),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
      );

  Widget _buildInput(
    TextEditingController inputValue, {
    String hintInput = '',
    int? maxLength,
    TextInputType textInputType = TextInputType.number,
  }) {
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: textInputType,
      maxLength: maxLength,
      style: MKStyle.t14R,
      onChanged: (value) {
        Logging.log.info('Input: $value');
      },
      controller: inputValue,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.getSize(5.0))),
            borderSide:
                BorderSide(width: 1, color: ResourceColors.color_929292),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.getSize(5.0))),
            borderSide:
                BorderSide(width: 1, color: ResourceColors.color_929292),
          ),
          hintText: hintInput,
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          hintStyle: _buildHintTextStyle(),
          counterText: ''),
    );
  }

  TextStyle _buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  Widget _buildButton(String content, Function() clickButtonCallBack) =>
      ButtonWidget(
          content: content,
          bgdColor: ResourceColors.color_0FA4EA,
          borderRadius: Dimens.getWidth(100.0),
          width: ScreenUtil.getScreenW(context) / 2.0,
          textStyle: MKStyle.t14R.copyWith(
            color: ResourceColors.color_white,
            fontWeight: FontWeight.w400,
          ),
          heightText: 1.5,
          clickButtonCallBack: clickButtonCallBack);

  Widget _buildInviteBySmsNotice() => Padding(
        padding: EdgeInsets.all(Dimens.getSize(5.0)),
        child: TextWidget(
          label: "INVITE_BY_SMS_NOTICE".tr(),
          textStyle: MKStyle.t10R.copyWith(color: ResourceColors.color_333333),
        ),
      );

  Widget _buildSendSmsButton() => _buildButton("INVITE_BY_SMS".tr(), () async {
        createOrUpdateInviteFriendRequestModel(false, doInviteFriend(context));
      });

  Widget _buildSendEmailButton() =>
      _buildButton("INVITE_BY_EMAIL".tr(), () async {
        createOrUpdateInviteFriendRequestModel(true, doInviteFriend(context));
      });

  void createOrUpdateInviteFriendRequestModel(
      bool isMail, Function doInviteFriend) async {
    if (requestModel == null) {
      var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
      var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

      requestModel = InviteFriendRequestModel.createFrom(
          memberNum: memberNum,
          inviteUserNum:
              int.tryParse(userNum) != null ? int.parse(userNum) : -1,
          email: emailController.text,
          mobilePhone: telController.text,
          isMail: isMail);
      doInviteFriend.call();
    } else {
      requestModel = requestModel!.copyWith(
          email: emailController.text,
          mobilePhone: telController.text,
          isMail: isMail);
      doInviteFriend.call();
    }
    setState(() {});
  }

  syncContact(bool isMail) async {
    if (await FlutterContacts.requestPermission()) {
      final pickedContact = await FlutterContacts.openExternalPick();

      if (pickedContact != null) {
        if (isMail) {
          if (pickedContact.emails.isNotEmpty) {
            String? pickedContactEmail = pickedContact.emails
                .firstWhere((element) => element.address.isNotEmpty)
                .address;

            if (pickedContactEmail.isNotEmpty) {
              emailController.text = pickedContactEmail;
            }
          }
        } else {
          if (pickedContact.phones.isNotEmpty) {
            String? pickedContactNumber = pickedContact.phones
                .firstWhere((element) => element.number.isNotEmpty)
                .number;
            if (HelperFunction.instance.checkIfJpnPhoneNumber(
                pickedContactNumber.replaceAll(' ', ''))) {
              telController.text = pickedContactNumber;
            }
          }
        }
      }
    }
  }
}
