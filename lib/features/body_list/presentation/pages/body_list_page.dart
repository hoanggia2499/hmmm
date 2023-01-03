import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_button.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_title_pattern_3.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_bloc.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_state.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/core/widgets/common/listview_widget.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class BodyListPage extends StatefulWidget {
  String bodyType;
  int id;

  BodyListPage({required this.bodyType, required this.id});
  @override
  State<BodyListPage> createState() => _BodyListPageState();
}

class _BodyListPageState extends State<BodyListPage>
    with SingleTickerProviderStateMixin {
  LoginModel loginModel = LoginModel();
  List<BodyModel> listBodyModel = [];
  late Map<String, List<BodyModel>> groupData;
  late List<GlobalKey> keys;
  late ScrollController controller;
  int checkedCount = 0;
  List<String> itemCheked = [];
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    context.read<BodyListBloc>().add(GetBodyListEvent(widget.id, context));
    getLoginModel();
    keys = <GlobalKey>[];
    keys.add(GlobalKey());
    groupData = {};
    controller = ScrollController();
    super.initState();
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
      controller: tabController,
      appBarTitle: "BODY_LIST_PAGE".tr(),
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      hasMenuBar: true,
      appBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<BodyListBloc, BodyListState>(
        listener: (context, agreementState) async {
          if (agreementState is Loaded) {
            Logging.log.warn('Loaded');
            listBodyModel = agreementState.listBodyModel;

            initData();
          }
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

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  initData() {
    List<BodyModel> listData = [];
    for (int i = 0; i < listBodyModel.length - 1; i++) {
      if (listBodyModel[i].makerName != listBodyModel[i + 1].makerName) {
        listData.add(listBodyModel[i]);
        groupData.addAll({listBodyModel[i].makerName: listData});
        listData = [];
        keys.add(GlobalKey());

        // Handle for Last Item Case lastItem ! BeforeItem
        if (listBodyModel.length == i + 2) {
          listData.add(listBodyModel[i + 1]);
          groupData.addAll({listBodyModel[i + 1].makerName: listData});
        }
      } else {
        listData.add(listBodyModel[i]);
        // Handle for Last Item Case lastItem = BeforeItem
        if (listBodyModel.length == i + 2) {
          listData.add(listBodyModel[i + 1]);
          groupData.addAll({listBodyModel[i + 1].makerName: listData});
        }
      }
    }
  }

  _buildBody() {
    return Container(
      color: ResourceColors.color_FFFFFF,
      child: BlocBuilder<BodyListBloc, BodyListState>(
        builder: (context, state) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          if (state is Loading) {
            EasyLoading.show();
          }
          return Stack(
            children: [
              ListViewWidget(
                  expandLeft: 9,
                  expandRight: 2,
                  widgetList: ListViewTitlePattern3(
                    listItemData: groupData,
                    callBack: (value) {},
                    keys: keys,
                    controller: controller,
                    callBackItemChecked:
                        (int numOfItemChecked, List<String> itemChecked) {
                      Logging.log.warn('Num of Item Checked');
                      Logging.log.info('From: bodyList Page');
                      Logging.log.warn(numOfItemChecked);
                      checkedCount = numOfItemChecked;
                      itemCheked = itemChecked;
                    },
                  ),
                  widgetListButton: ListViewButtonPage(
                    screenType: Constants.BODY_LIST_TYPE,
                    textAlign: TextAlign.center,
                    listItemButton: groupData,
                    callBack: (value) {
                      changePosition(value);
                    },
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: _buildBoxDecoration(),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible: true,
                          child: Center(
                            child: ButtonWidget(
                              size: Dimens.getHeight(8),
                              width: MediaQuery.of(context).size.width / 3,
                              content: 'SEARCH'.tr(),
                              borderRadius: 20.0,
                              clickButtonCallBack: () async {
                                handleSearchBtn();
                              },
                              bgdColor: ResourceColors.color_FF0FA4EA,
                              borderColor: ResourceColors.color_FF4BC9FD,
                              textStyle: MKStyle.t14R
                                  .copyWith(color: ResourceColors.color_FFFFFF),
                              heightText: 1.2,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFDFEFF),
          const Color(0xFFEEF9FF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  handleSearchBtn() async {
    if (checkedCount == 0) {
      CommonDialog.displayDialog(context, "5MA014CE", "5MA014CE".tr(), false);
    } else if (checkedCount > 5) {
      CommonDialog.displayDialog(context, "5MA015CE", "5MA015CE".tr(), false);
    } else {
      List<CarSearchHive> carListSearchList = [];

      itemCheked.forEach((element) {
        //element: makerCode|asnetCarCode|carGroup
        var items = element.split('|');
        carListSearchList.add(CarSearchHive(
          makerName: items[3],
          makerCode: items[0],
          asnetCarCode: items[1],
          carGroup: items[2],
        ));
      });
      // Move to SearchInputActivity
      Navigator.of(context).pushNamed(AppRoutes.searchInputPage, arguments: {
        "nameScreen": Constants.BODY_LIST_PAGE,
        "listDataCarName": carListSearchList
      });
    }
  }

  // Change position group item
  void changePosition(String key) {
    var index = groupData.keys.toList().indexOf(key);
    var renderObject = keys[index].currentContext?.findRenderObject();
    if (renderObject != null) {
      controller.position
          .ensureVisible(renderObject, duration: Duration(milliseconds: 300));
    }
  }
}
