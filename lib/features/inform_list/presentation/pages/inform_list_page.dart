import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_request.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_response.dart';
import 'package:mirukuru/features/inform_list/presentation/bloc/inform_list_bloc.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import '../../../../core/config/common.dart';
import '../../../../core/secure_storage/user_secure_storage.dart';
import '../../../../core/util/app_route.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/helper_function.dart';
import '../../../../core/widgets/common/template_page.dart';
import '../../../../core/widgets/dialog/common_dialog.dart';
import '../../../login/data/models/login_model.dart';

class InformListPage extends StatefulWidget {
  const InformListPage({Key? key}) : super(key: key);

  @override
  State<InformListPage> createState() => _InformListPageState();
}

class _InformListPageState extends State<InformListPage> {
  /// To load logo and scroll bar
  LoginModel _loginModel = LoginModel();
  String _buildAppBarLogo(LoginModel loginModel) {
    return loginModel.logoMark.isEmpty
        ? ''
        : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}';
  }

  /// Load user info from data local
  late String memberNum;
  late String userNum;

  /// Handle inform list
  List<InformListResponseModel> listInform = [];

  @override
  void initState() {
    initData();
    getData();
    super.initState();
  }

  void initData() async {
    memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    var requestModel = InformListRequestModel(
      memberNum: memberNum,
      userNum: int.tryParse(userNum) != null ? int.parse(userNum) : 0,
    );
    context.read<InformListBloc>().add(GetInformListEvent(requestModel));
  }

  void getData() async {
    _loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildAppBarLogo(_loginModel),
      appBarTitle: "NEWS_TITLE".tr(),
      storeName: _loginModel.storeName2.isNotEmpty
          ? '${_loginModel.storeName}\n${_loginModel.storeName2}'
          : _loginModel.storeName,
      hasMenuBar: true,
      isHiddenLeadingPop: true,
      appBarColor: ResourceColors.color_FF1979FF,
      resizeToAvoidBottomInset: true,
      currentIndex: Constants.NOTIFICATION_INDEX,
      body: BlocListener<InformListBloc, InformListState>(
        listener: (context, state) async {
          if (state is LoadedInformListState) {
            listInform = state.listInform;
          }

          if (state is Error) {
            await CommonDialog.displayDialog(context, state.messageCode,
                eventCallBack: () {
              if (state.messageCode == '5MA015SE') {
                Navigator.pop(context);
              }
            }, state.messageContent, false);
          }

          if (state is TimeOut) {
            await CommonDialog.displayDialog(
              context,
              state.messageCode,
              state.messageContent,
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
    return BlocBuilder<InformListBloc, InformListState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }

      if (state is Loading) {
        EasyLoading.show();
      }

      return Column(
        children: [
          _buildTitleBar(context),
          _buildListInform(state),
        ],
      );
    });
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: ResourceColors.color_E1E1E1,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(12), horizontal: Dimens.getWidth(20)),
        child: TextWidget(
          label: "LIST_QUESTION".tr(),
        ),
      ),
    );
  }

  Widget _buildListInform(InformListState state) {
    return Expanded(
      child: Visibility(
          visible: state is LoadedInformListState,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: listInform.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  final inform = listInform[index];
                  var reload = await Navigator.pushNamed(
                      context, AppRoutes.informDetailPage,
                      arguments: {
                        "informListResponseModel": inform,
                      });
                  if (reload != null) {
                    reload as bool;

                    if (reload) {
                      setState(() {
                        inform.confirmDate = DateTime.now().toString();
                        listInform.setRange(index, index, [inform]);
                      });
                    }
                  }
                },
                child: _buildItemListInform(index),
              );
            },
          )),
    );
  }

  Widget _buildItemListInform(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: ResourceColors.color_70,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildLabelLeading(index),
          ),
          Expanded(
            flex: 7,
            child: _buildInformItem(index),
          ),
          Expanded(
            flex: 1,
            child: _buildNextBtn(),
          ),
        ],
      ),
    );
  }

  Widget _buildInformItem(int index) {
    return ListTile(
      title: TextWidget(
        label: listInform[index].title ?? "",
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_757575),
      ),
      subtitle: TextWidget(
        label: DateUtil.formatDateStr(listInform[index].sendDate ?? "",
            format: "yyyy/MM/dd HH:mm"),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
      ),
      minVerticalPadding: Dimens.getHeight(12),
      // horizontalTitleGap: 15,
      contentPadding: EdgeInsets.only(
          top: Dimens.getHeight(8), bottom: Dimens.getHeight(13)),
    );
  }

  Widget _buildLabelLeading(int index) {
    return Visibility(
      visible: listInform[index].confirmDate == null,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.getWidth(12),
        ),
        width: Dimens.getWidth(42),
        height: Dimens.getHeight(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ResourceColors.color_FF8011,
        ),
        child: Align(
          alignment: Alignment.center,
          child: TextWidget(
            label: "UNREAD".tr(),
            textStyle:
                MKStyle.t12B.copyWith(color: ResourceColors.color_FFFFFF),
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
    return Visibility(
      visible: true,
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      child: Image.asset(
        "assets/images/png/next.png",
        width: Dimens.getHeight(15.0),
        height: Dimens.getHeight(15.0),
      ),
    );
  }
}
