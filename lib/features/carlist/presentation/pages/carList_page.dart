import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/listview_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_button.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_title_pattern_2.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_bloc.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_event.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_state.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';

class CarListPage extends StatefulWidget {
  // "010"
  String makerCode;
  // "AAAA"
  String makerName;
  // "SearchTopActivity"
  String caller;
  // carRegist
  String from;

  CarListPage(
      {required this.makerCode,
      required this.makerName,
      required this.caller,
      required this.from});

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late List<dynamic> listData;
  late Map<String, List<CarModel>> groupData;
  late List<GlobalKey> keys;
  late ScrollController controller;
  List<CarModel> listDataFavoriteCar = [];
  List<CarModel> listDataA = [];
  List<CarModel> listDataKa = [];
  List<CarModel> listDataSa = [];
  List<CarModel> listDataTa = [];
  List<CarModel> listDataNa = [];
  List<CarModel> listDataHa = [];
  List<CarModel> listDataMa = [];
  List<CarModel> listDataYa = [];
  List<CarModel> listDataRa = [];
  List<CarModel> listDataWa = [];
  List<CarModel> listDataEng = [];

  bool isFromCarRegist = false;
  bool isShowMenu = true;
  bool isShowSearchButton = true;
  List<CarModel> listCarModel = [];
  int checkedCount = 0;
  List<String> itemCheked = [];
  int totalnumOfCarASOne = 0;
  late TabController tabController;
  LoginModel loginModel = LoginModel();

  @override
  void initState() {
    Logging.log.info('=====================');
    Logging.log.info('║ INIT: CarListPage ║');
    Logging.log.info('=====================');
    tabController = TabController(length: 4, vsync: this);

    if (widget.from != '') {
      isFromCarRegist = true;
      isShowMenu = false;
      isShowSearchButton = false;
      widget.makerName = "VEHICLE_SELECTION".tr();
    }

    context
        .read<CarListBloc>()
        .add(GetCarListEvent(widget.caller, context, widget.makerCode));
    keys = <GlobalKey>[];
    keys.add(GlobalKey());
    groupData = {};
    controller = ScrollController();
    setArea();
    getLoginModel();
    super.initState();
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    //  var localTelCompany = await UserSecureStorage.instance.getTelCompany();
    setState(() {
      loginModel = localLoginModel;
      // telCompany = localTelCompany;
    });
  }

  setArea() async {
    await UserSecureStorage.instance.setArea("");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TemplatePage(
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      controller: tabController,
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      appBarTitle: "CAR_LIST_PAGE".tr(),
      hasMenuBar: isShowMenu,
      appBarColor: ResourceColors.color_FF1979FF,
      bottomBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<CarListBloc, CarListState>(
        listener: (buildContext, carListState) async {
          if (carListState is Loaded) {
            Logging.log.warn('Loaded');
            listCarModel = carListState.listCarModel;
            print(listCarModel[0].numOfCarASOne);
            listCarModel.forEach((element) {
              totalnumOfCarASOne += element.numOfCarASOne;
            });
            initListData();
            initGroupListData();
          }
          if (carListState is Error) {
            Logging.log.warn('Error');
            CommonDialog.displayDialog(context, carListState.messageCode,
                carListState.messageContent, false);
          }
          if (carListState is TimeOut) {
            Logging.log.warn('TimeOut');
            await CommonDialog.displayDialog(context, carListState.messageCode,
                carListState.messageContent, false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Container(
      color: ResourceColors.color_FFFFFF,
      child: BlocBuilder<CarListBloc, CarListState>(
        builder: (context, state) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          if (state is Loading) {
            EasyLoading.show();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Dimens.getHeight(15.0),
                    top: Dimens.getHeight(5.0),
                    bottom: Dimens.getHeight(15.0)),
                child: TextWidget(
                  alignment: TextAlign.start,
                  label:
                      '${widget.makerName}${"ALL_USED_CARS_IN".tr()}($totalnumOfCarASOne)',
                  textStyle:
                      MKStyle.t14R.copyWith(color: ResourceColors.color_757575),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListViewWidget(
                        expandLeft: 5,
                        expandRight: 1,
                        widgetList: ListViewTitlePattern2(
                          isFromCarRegist: isFromCarRegist,
                          listItemData: groupData,
                          callBack: (value) {},
                          keys: keys,
                          controller: controller,
                          callBackItemChecked:
                              (int numOfItemChecked, List<String> itemChecked) {
                            if (isFromCarRegist) {
                              // Save ASNETCarCode and carGroup

                              // Finish CarList Page
                              Navigator.pop(context);
                            } else {
                              Logging.log.warn('Num of Item Checked');
                              Logging.log.info('From: carList Page');
                              Logging.log.warn(numOfItemChecked);
                              checkedCount = numOfItemChecked;
                              itemCheked = itemChecked;
                            }
                          },
                        ),
                        widgetListButton: ListViewButtonPage(
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
                            padding: EdgeInsets.all(Dimens.getHeight(8.0)),
                            child: Visibility(
                                visible: isShowSearchButton,
                                child: Center(
                                  child: ButtonWidget(
                                    size: Dimens.getHeight(8),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    content: "SEARCH".tr(),
                                    borderRadius: Dimens.getHeight(20),
                                    clickButtonCallBack: () async {
                                      handleSearchBtn();
                                    },
                                    bgdColor: ResourceColors.color_FF0FA4EA,
                                    borderColor: ResourceColors.color_FF4BC9FD,
                                    textStyle: MKStyle.t14R.copyWith(
                                        color: ResourceColors.color_FFFFFF),
                                    heightText: 1.2,
                                  ),
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
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

  Future<void> handleSearchBtn() async {
    if (checkedCount == 0) {
      CommonDialog.displayDialog(context, "5MA014CE", "5MA014CE".tr(), false);
    } else if (checkedCount > 5) {
      CommonDialog.displayDialog(context, "5MA015CE", "5MA015CE".tr(), false);
    } else {
      List<CarSearchHive> carListSearchList = [];

      itemCheked.forEach((element) {
        //element: makerCode|asnetCarCode|carGroup
        var items = element.split('|');
        setState(() {
          carListSearchList.add(CarSearchHive(
            makerName: widget.makerName,
            makerCode: items[0],
            asnetCarCode: items[1],
            carGroup: items[2],
          ));
        });
      });
      // Move to SearchInputActivity
      Navigator.of(context).pushNamed(AppRoutes.searchInputPage, arguments: {
        "nameScreen": "CarListPage",
        "listDataCarName": carListSearchList
      });
    }
  }

  // add Data from List(based on ア,カ...)   to Group
  initGroupListData() {
    addDataToGroup('POPULAR_CAR'.tr(), listDataFavoriteCar);
    addDataToGroup('ア', listDataA);
    addDataToGroup('カ', listDataKa);
    addDataToGroup('サ', listDataSa);
    addDataToGroup('タ', listDataTa);
    addDataToGroup('ナ', listDataNa);
    addDataToGroup('ハ', listDataHa);
    addDataToGroup('マ', listDataMa);
    addDataToGroup('ヤ', listDataYa);
    addDataToGroup('ラ', listDataRa);
    addDataToGroup('ワ', listDataWa);
    addDataToGroup('英数', listDataEng);
  }

  // Create List based on ア,カ...
  initListData() {
    for (var i = 0; i < listCarModel.length; i++) {
      //    var restRegExpFavoriteCar = RegExp(r'ア|イ|ウ|ヴ|エ|オ');
      var restRegExpA = RegExp(r'ア|イ|ウ|ヴ|エ|オ');
      var restRegExpKa = RegExp(r'カ|ガ|キ|ギ|ク|グ|ケ|ゲ|グ|コ|ゴ');
      var restRegExpSa = RegExp(r'サ|ザ|シ|ジ|ス|ズ|セ|ゼ|ソ|ゾ|そ');
      var restRegExpTa = RegExp(r'タ|ダ|チ|ツ|テ|デ|ト|ド');
      var restRegExpNa = RegExp(r'ナ|ニ|ヌ|ネ|ノ');
      var restRegExpHa = RegExp(r'ハ|バ|パ|ヒ|ビ|ピ|フ|ブ|プ|ヘ|ベ|ペ|ホ|ボ|ポ');
      var restRegExpMa = RegExp(r'マ|ミ|ム|メ|モ');
      var restRegExpYa = RegExp(r'ヤ|ユ|ヨ');
      var restRegExpRa = RegExp(r'ラ|リ|ル|レ|ロ');
      var restRegExpWa = RegExp(r'ワ|ヲ|ン');
      var restRegExpEng = RegExp(r"[0-9a-zA-Z].*");

      // addDataToList(
      //     listCarModel[i], restRegExpFavoriteCar, listDataFavoriteCar);
      addDataToList(listCarModel[i], restRegExpA, listDataA);
      addDataToList(listCarModel[i], restRegExpKa, listDataKa);
      addDataToList(listCarModel[i], restRegExpSa, listDataSa);
      addDataToList(listCarModel[i], restRegExpTa, listDataTa);
      addDataToList(listCarModel[i], restRegExpNa, listDataNa);
      addDataToList(listCarModel[i], restRegExpHa, listDataHa);
      addDataToList(listCarModel[i], restRegExpMa, listDataMa);
      addDataToList(listCarModel[i], restRegExpYa, listDataYa);
      addDataToList(listCarModel[i], restRegExpRa, listDataRa);
      addDataToList(listCarModel[i], restRegExpWa, listDataWa);
      addDataToList(listCarModel[i], restRegExpEng, listDataEng);
    }
  }

  addDataToList(CarModel apiReturn, RegExp regExp, List<CarModel> listData) {
    if (apiReturn.carGroup.startsWith(regExp)) {
      listData.add(apiReturn);
    }
  }

  addDataToGroup(String titleGroup, List<CarModel> list) {
    int length = list.length;
    if (length > 0) {
      groupData.addAll({titleGroup: list});
      keys.add(GlobalKey());
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

  @override
  bool get wantKeepAlive => true;
}
