import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/table_data/common_table_data_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_bloc.dart';

import '../../../../core/secure_storage/user_secure_storage.dart';
import '../bloc/store_state.dart';
import '../bloc/store_event.dart';

class StoreInformationPage extends StatefulWidget {
  const StoreInformationPage({Key? key}) : super(key: key);

  @override
  _StoreInformationPageState createState() => _StoreInformationPageState();
}

class _StoreInformationPageState extends State<StoreInformationPage> {
  LoginModel loginModel = LoginModel();
  StoreInformationModel storeInformationModel = StoreInformationModel();

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

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildStoreLogoUrl(loginModel),
      appBarTitle: "STORE_INFO".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      resizeToAvoidBottomInset: false,
      body: BlocListener<StoreBloc, StoreState>(
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

  String _buildStoreLogoUrl(LoginModel loginModel) => loginModel
          .logoMark.isEmpty
      ? ''
      : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';

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
          storeInformationModel = state.storeInformation!;
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(Dimens.getSize(15.0)),
          padding: EdgeInsets.symmetric(horizontal: Dimens.getWidth(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStorePhotoWidget(),
              SizedBox(
                height: Dimens.getHeight(30.0),
              ),
              Expanded(child: _buildStoreInformation())
            ],
          ),
        );
      },
    );
  }

  _buildStorePhotoWidget() {
    return Container(
      //width: MediaQuery.of(context).size.width,
      height: ScreenUtil.getScreenH(context) / 3.5,
      color: storeInformationModel.photo.isEmpty
          ? ResourceColors.color_white
          : ResourceColors.color_BFE8FC,
      child: Image.network(storeInformationModel.getStorePhotoUrl(),
          fit: BoxFit.fill, errorBuilder: (context, object, stack) {
        return Center(
          child: TextWidget(
            label: "STORE_PHOTO".tr(),
            textStyle:
                MKStyle.t30B.copyWith(color: ResourceColors.color_929292),
          ),
        );
      }),
    );
  }

  Widget _buildStoreInformation() {
    var storeInformationItems = [
      RowItem("STORE_NAME".tr(),
          "${storeInformationModel.storeName} ${storeInformationModel.storeName2}"),
      RowItem("STORE_ADDRESS".tr(), storeInformationModel.displayFullAddress()),
      RowItem("STORE_TEL".tr(), storeInformationModel.getTel),
      RowItem("STORE_EMAIL".tr(), storeInformationModel.email),
      RowItem("STORE_HOLIDAY".tr(), storeInformationModel.holiday),
      RowItem("STORE_SALESTIME".tr(), storeInformationModel.salestime),
    ];
    return CommonTableDataWidget(items: storeInformationItems);
  }
}
