import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/listview_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_button.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_title.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_bloc.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_event.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_state.dart';
import '../../../../core/util/app_route.dart';
import '../../data/models/item_maker_model.dart';

class MakerListPage extends StatefulWidget {
  @override
  _MakerListPageState createState() => _MakerListPageState();
}

class _MakerListPageState extends State<MakerListPage>
    with SingleTickerProviderStateMixin {
  late Map<String, List<ItemMakerModel>> groupData;
  late List<GlobalKey> keys;
  late ScrollController controller;

  List<ItemMakerModel> listMaker = [];

  String groupName = 'JAPAN'.tr();
  late TabController tabController;
  LoginModel loginModel = LoginModel();

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);

    context.read<MakerListBloc>().add(MakerListInit());
    controller = ScrollController();
    groupData = {};
    keys = [];

    getLoginModel();

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
        storeName: loginModel.storeName2.isNotEmpty
            ? '${loginModel.storeName}\n${loginModel.storeName2}'
            : loginModel.storeName,
        controller: tabController,
        appBarTitle: "MAKER_LIST_PAGE".tr(),
        appBarColor: ResourceColors.color_FF1979FF,
        body: MultiBlocListener(
          listeners: [
            BlocListener<MakerListBloc, MakerListState>(
              listener: (buildContext, makerState) async {
                if (makerState is Loaded) {
                  setState(() {
                    listMaker = makerState.makerEntity;
                  });

                  List<ItemMakerModel> listData = [];
                  keys = <GlobalKey>[];
                  keys.add(GlobalKey());
                  groupData = {};
                  // Convert Api Data to List Button can use data
                  for (var i = 0; i < listMaker.length; i++) {
                    if (listMaker[i].numOfCarASOne == 99999 ||
                        listMaker[i].makerName == '----------') {
                      groupData.addAll({groupName: listData});
                      var replaceName =
                          listMaker[i].makerName.replaceAll('-', '');
                      replaceName = replaceName.replaceAll('(', '');
                      replaceName = replaceName.replaceAll(')', '');
                      groupName = replaceName;
                      if (groupName.isEmpty) {
                        groupName = 'OTHERS'.tr();
                      }
                      listData = [];
                      keys.add(GlobalKey());
                    } else {
                      listData.add(listMaker[i]);
                    }
                  }
                  if (listMaker[listMaker.length - 1].numOfCarASOne != 99999) {
                    groupData.addAll({groupName: listData});
                    keys.add(GlobalKey());
                  }
                }
                if (makerState is Error) {
                  await CommonDialog.displayDialog(context,
                      makerState.messageCode, makerState.messageContent, false);
                }
                if (makerState is TimeOut) {
                  await CommonDialog.displayDialog(context,
                      makerState.messageCode, makerState.messageContent, false);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.loginPage, (route) => false);
                }
              },
            )
          ],
          child: _buildBody(),
        ));
  }

  Widget _buildBody() {
    return Container(
      color: ResourceColors.color_FFFFFF,
      child:
          BlocBuilder<MakerListBloc, MakerListState>(builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (state is Loading) {
          EasyLoading.show();
        }
        return ListViewWidget(
            expandLeft: 7,
            expandRight: 2,
            widgetList: ListViewTitlePage(
              listItemData: groupData,
              callBack: (item) async {
                await Navigator.of(context).pushNamed(AppRoutes.carListPage,
                    arguments: {
                      'makerCode': item.makerCode,
                      'makerName': item.makerName
                    });
              },
              keys: keys,
              controller: controller,
            ),
            widgetListButton: ListViewButtonPage(
              screenType: Constants.MAKER_LIST_TYPE,
              listItemButton: groupData,
              callBack: (value) {
                changePosition(value);
              },
            ));
      }),
    );
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
