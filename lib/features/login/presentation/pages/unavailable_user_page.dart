import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/table_data/common_table_data_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/login/presentation/widgets/container_item.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_bloc.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_event.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_state.dart';

class UnavailableUserPage extends StatefulWidget {
  @override
  _UnavailableUserPageState createState() => _UnavailableUserPageState();
}

class _UnavailableUserPageState extends State<UnavailableUserPage> {
  LoginModel loginModel = LoginModel();
  StoreInformationModel storeModel = StoreInformationModel();

  @override
  void initState() {
    getData();
    loadStoreInformation();
    super.initState();
  }

  void getData() async {
    loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  void loadStoreInformation() async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';

    context
        .read<StoreBloc>()
        .add(LoadStoreInformationEvent(memberNum: memberNum));
  }

  String _buildAppBarLogo(LoginModel loginModel) => loginModel.logoMark.isEmpty
      ? ''
      : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResourceColors.color_FF3C83EC,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: BlocListener<StoreBloc, StoreState>(
          listener: (context, state) async {
            if (state is Error) {
              await CommonDialog.displayDialog(
                  context, state.errorModel.msgCode, eventCallBack: () {
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

              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage, (route) => false);
            }
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        if (state is Loaded) {
          storeModel = state.storeInformation!;
        }

        return Container(
          color: ResourceColors.color_white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderPage(),
              _buildSizedBox(50.0),
              _buildWarningText(),
              _buildSizedBox(30.0),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Container(
                    height: ScreenUtil.getScreenH(context) / 3.0,
                    child: _buildStoreInformation()),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSizedBox(double height) {
    return SizedBox(
      height: Dimens.getHeight(height),
    );
  }

  BoxDecoration _buildDecoration() {
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

  Widget _buildHeaderPage() {
    return Container(
        decoration: _buildDecoration(),
        child: Column(
          children: [
            _buildSizedBox(60.0),
            _buildLogoBackToHome(),
            _buildLogo()
          ],
        ));
  }

  Widget _buildWarningText() {
    return Center(
        child: TextWidget(
      label: "UNAVAILABLE_USER_WARNING_INFO".tr(),
      alignment: TextAlign.center,
      textStyle: MKStyle.t16R.copyWith(color: ResourceColors.color_EA3323),
    ));
  }

  Widget _buildLogoBackToHome() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            width: MediaQuery.of(context).size.width / 6,
            'assets/images/svg/mirulogo.svg',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          child: Column(
        children: [
          Image.network(_buildAppBarLogo(loginModel),
              fit: BoxFit.fill, height: Dimens.getHeight(38.0),
              errorBuilder: (context, object, stack) {
            return TextWidget(
              label: storeModel.storeName,
              textStyle: storeModel.storeName.contains(RegExp(r'\n'))
                  ? MKStyle.t12R.copyWith(color: ResourceColors.color_0058A6)
                  : MKStyle.t18R.copyWith(color: ResourceColors.color_0058A6),
              alignment: TextAlign.center,
            );
          }),
          SizedBox(
            height: Dimens.getHeight(5.0),
          ),
        ],
      )),
    );
  }

  BoxDecoration _buildDecorationInfo(Color color, Color colorBorder) {
    return BoxDecoration(
        color: color,
        border: Border(bottom: BorderSide(color: colorBorder, width: 1)));
  }

  Widget _buildStoreInformation() {
    var storeInformationItems = [
      RowItem("STORE_NAME".tr(),
          "${storeModel.storeName} ${storeModel.storeName2}"),
      RowItem("STORE_ADDRESS".tr(), storeModel.displayFullAddress()),
      RowItem(
          "STORE_TEL".tr(),
          ContainerItem(
            boxDecoration: _buildDecorationInfo(
                ResourceColors.color_white, ResourceColors.color_E1E1E1),
            label: storeModel.tel,
            storeName: storeModel.storeName,
          )),
      RowItem("STORE_EMAIL".tr(), storeModel.email),
      RowItem("STORE_HOLIDAY".tr(), storeModel.holiday),
      RowItem("STORE_SALESTIME".tr(), storeModel.salestime),
    ];
    return CommonTableDataWidget(items: storeInformationItems);
  }
}
