import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_bloc.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_event.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_state.dart';
import 'package:mirukuru/features/my_page/presentation/pages/widgets/animated_radio_row_list_widget.dart';
import 'package:mirukuru/features/my_page/presentation/pages/widgets/sub_title_with_button_widget.dart';

import '../../../menu_widget_test/pages/button_widget.dart';
import '../../data/models/my_page_request_model.dart';

enum UserCarAction { NEW, DELETE, EDIT, NONE }

typedef OnUpdateUserCarCallback = Function(
    ReturnedUserCarModel returnedUserCarModel);

class ReturnedUserCarModel {
  final UserCarModel? userCarModel;
  final UserCarAction action;

  ReturnedUserCarModel({this.userCarModel, required this.action});
}

class CarOwnerShipSettingsScreen extends StatefulWidget {
  final List<UserCarModel> userCarList;
  final int selectedIndex;

  CarOwnerShipSettingsScreen({
    Key? key,
    required this.userCarList,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<CarOwnerShipSettingsScreen> createState() =>
      _CarOwnerShipSettingsScreenState();
}

class _CarOwnerShipSettingsScreenState
    extends State<CarOwnerShipSettingsScreen> {
  LoginModel _loginModel = LoginModel();
  ScrollController scrollController = ScrollController();
  bool isRadioShow = true;
  var action = UserCarAction.NONE;

  List<UserCarModel> userCarList = List.empty(growable: true);
  int selectedIndex = 0;
  late var mediaQuerySize;

  @override
  void initState() {
    super.initState();
    getData();
    populateCarOwnershipValues();
  }

  populateCarOwnershipValues() {
    selectedIndex = widget.selectedIndex;
    userCarList = widget.userCarList;
  }

  getData() async {
    _loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerySize = MediaQuery.of(context).size;

    return TemplatePage(
      appBarLogo: _buildAppBarLogo(_loginModel),
      appBarTitle: "OWNED_CAR_SETTING".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      storeName: _loginModel.storeName2.isNotEmpty
          ? '${_loginModel.storeName}\n${_loginModel.storeName2}'
          : _loginModel.storeName,
      buttonBottom: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _buildUpdateButton(),
      ),
      body: BlocListener<MyPageBloc, MyPageState>(
          listener: (ctx, state) async {
            if (state is Error) {
              await CommonDialog.displayDialog(
                  context, state.errorModel.msgCode, eventCallBack: () {
                if (state.errorModel.msgCode == '5MA015SE') {
                  Navigator.pop(context);
                }
              }, state.errorModel.msgContent, false);
            }

            if (state is MyPageInfoLoaded) {
              userCarList = state.myPageModel?.userCarList ?? [];
            }

            if (state is TimeOut) {
              await CommonDialog.displayDialog(context,
                  state.errorModel.msgCode, state.errorModel.msgContent, false);
            }
          },
          child: _buildBody()),
      onBackAction: () {
        var arguments = Map<String, dynamic>();
        arguments.putIfAbsent("userCarList",
            () => action != UserCarAction.NONE ? userCarList : null);
        arguments.putIfAbsent("selectedIndex", () => selectedIndex);

        Navigator.of(context).pop<Map<String, dynamic>>(arguments);
      },
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MyPageBloc, MyPageState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        return Container(
          color: ResourceColors.color_FFFFFF,
          child: _buildMain(),
        );
      },
    );
  }

  String _buildAppBarLogo(LoginModel loginModel) => loginModel.logoMark.isEmpty
      ? ''
      : '${Common.imageUrl + _loginModel.memberNum + '/' + _loginModel.logoMark}';

  _buildUpdateButton() => ButtonWidget(
      content: "CHANGE_PRIMARY_CAR".tr(),
      bgdColor: ResourceColors.color_0FA4EA,
      borderRadius: Dimens.getWidth(20.0),
      width: mediaQuerySize.width / 1.5,
      textStyle: MKStyle.t14R.copyWith(
        color: ResourceColors.color_white,
        fontWeight: FontWeight.w400,
      ),
      heightText: 1.5,
      clickButtonCallBack: () async {
        setState(() => isRadioShow = !isRadioShow);
      });

  Widget _buildMain() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SubTitleWithButton(
          label: "LIST_QUESTION".tr(),
          actionButton: SubtitleButton(
              image: "assets/images/svg/plus.svg",
              label: "ADDITION".tr(),
              onTapCallback: _handleNewOrUpdateUserCar),
        ),
        Expanded(child: _buildCarOwnershipChoices()),
      ],
    );
  }

  Widget _buildCarOwnershipChoices() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        AnimatedRadioListRowWidget(
          inputValues: userCarList
              .map((e) => e.userCarNameModel?.displayUserCarName() ?? "")
              .toList(),
          defaultCheckedIndex: selectedIndex,
          onValueChanged: (position) {
            setState(() {
              selectedIndex = position;
            });
            Logging.log.info("userCarList[selectedIndex]");
            Logging.log.info(selectedIndex);
          },
          onRowTappedCallback: (position) async {
            Logging.log.info(userCarList[position].toMap());
            _handleNewOrUpdateUserCar(position: position);
          },
          isHideRadioButton: isRadioShow,
        ),
      ],
    );
  }

  void _handleNewOrUpdateUserCar({int position = -1}) async {
    var result;
    if (position >= 0) {
      result = await Navigator.of(context)
          .pushNamed(AppRoutes.carRegistPage, arguments: userCarList[position]);
    } else {
      if (userCarList.length >= 0 && userCarList.length < 9) {
        result = await Navigator.of(context).pushNamed(AppRoutes.carRegistPage,
            arguments: UserCarModel(
                memberNum: _loginModel.memberNum,
                userNum: (_loginModel.userNum).toString(),
                userCarNum: '0'));
      } else {
        await CommonDialog.displayDialog(
          context,
          '',
          "車両追加は9台までです",
          false,
        );
      }
    }

    if (!mounted) return;

    if (result != null) {
      result as ReturnedUserCarModel;
      isRadioShow = true;
      action = result.action;
      if (result.action == UserCarAction.NEW && result.userCarModel != null) {
        userCarList.add(result.userCarModel!);
        selectedIndex = userCarList.length - 1;
      } else if (result.action == UserCarAction.EDIT) {
        context
            .read<MyPageBloc>()
            .add(LoadMyPageInformationEvent(MyPageRequestModel(
              memberNum: _loginModel.memberNum,
              userNum: _loginModel.userNum,
            )));
      } else {
        userCarList.remove(result.userCarModel);
        selectedIndex = 0;
      }
      setState(() {});
    }
  }
}
