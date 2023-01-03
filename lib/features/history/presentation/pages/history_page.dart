import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/history/domain/usecases/get_item_search_history_list.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_bloc.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_event.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_state.dart';
import 'package:mirukuru/features/history/presentation/widget/listview_search_history_widget.dart';
import 'package:mirukuru/features/history/presentation/widget/segment_tab.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/search_input/data/models/search_input_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/presentation/pages/widget/listview_search.dart';
import '../../../../core/db/favorite_hive.dart';
import '../../../../core/util/app_route.dart';
import '../../../search_list/data/models/favorite_access_model.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage();

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  LoginModel loginModel = LoginModel();
  bool tabButtonFlag = true;
  ScrollController scrollController = ScrollController();
  List<ItemSearchModel> listItemBrowserHistory = [];
  List<SearchListModel> listItemSearchHistory = [];
  List<FavoriteHive> favoriteList = [];

  @override
  void initState() {
    initFavoriteList();
    context.read<HistoryBloc>().add(GetHistoryDataEvent());
    context.read<HistoryBloc>().add(InitFavoriteListEvent());
    super.initState();
    getLoginModel();
    // Get Favorite List and based on Favorite List for Check お気に入り ( Show Favorite Icon UI)
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: TemplatePage(
        isHiddenLeadingPop: true,
        storeName: loginModel.storeName2.isNotEmpty
            ? '${loginModel.storeName}\n${loginModel.storeName2}'
            : loginModel.storeName,
        appBarTitle: "HISTORY".tr(),
        appBarLogo: loginModel.logoMark.isEmpty
            ? ''
            : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
        currentIndex: Constants.HISTORY_INDEX,
        hasMenuBar: true,
        appBarColor: ResourceColors.color_FF1979FF,
        backCallBack: () {
          Navigator.popAndPushNamed(context, AppRoutes.searchTopPage);
        },
        body: BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) async {
            if (state is Error) {
              await CommonDialog.displayDialog(
                  context, state.messageCode, state.messageContent, false);
            }

            if (state is TimeOut) {
              await CommonDialog.displayDialog(
                  context, state.messageCode, state.messageContent, false);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage, (route) => false);
            }
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;
    });
  }

  Widget _buildBody() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      buildWhen: (previous, current) {
        if (previous is GetItemSearchHistoryList &&
            current is GetItemSearchHistoryList) {
          return true;
        }
        return previous != current;
      },
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        if (state is Loaded) {
          listItemSearchHistory = state.searchListModelList ?? [];
          listItemBrowserHistory = state.itemHistoryList ?? [];
        }

        if (state is LoadedInitFavorite) {
          // Get Favorite List and based on Favorite List for Check お気に入り ( Show Favorite Icon UI)
          favoriteList = state.listFavoriteHive;
        }

        return _buildMain();
      },
    );
  }

  Widget _buildMain() {
    return Stack(
      children: [
        SegmentedTabControl(
          // Customization of widget
          radius: const Radius.circular(4.0),
          backgroundColor: ResourceColors.color_E1E1E1,
          indicatorColor: ResourceColors.color_FFFFFF,
          tabTextColor: ResourceColors.color_929292,
          selectedTabTextColor: ResourceColors.color_3768CE,
          squeezeIntensity: 2,
          tabPadding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: MKStyle.t16R,
          tabs: [
            SegmentTab(
              label: 'BROWSE_HISTORY_TITLE'.tr(),
            ),
            SegmentTab(
              label: 'SEARCH_HISTORY_TITLE'.tr(),
            ),
          ],
        ),
        // Sample pages
        Padding(
          padding: EdgeInsets.only(top: Dimens.getHeight(40)),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildListBrowseHistory(),
              _buildListSearchHistory(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListBrowseHistory() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      child: ListviewSearch(
          initListFavorite: favoriteList,
          initListNumberOfChecked: [],
          completedLoadMore: () {},
          scrollController: scrollController,
          listItemSearchModel: listItemBrowserHistory.reversed.toList(),
          callBackItemChecked: (int currentNumberOfCheckedValue,
              List<int> listNumberOfCheckedValue) {},
          deleteCallBack: () {},
          topCallBack: (int index) {
            var listReversed = listItemBrowserHistory.reversed.toList();

            Logging.log.info("topCallBack");

            context.read<HistoryBloc>().add(SaveCarToDBEvent(
                listReversed[index],
                listReversed.indexOf(listItemBrowserHistory[index])));
            setState(() {});
            Navigator.of(context).pushNamed(AppRoutes.searchDetailPage,
                arguments: {
                  Constants.ITEM_SEARCH_MODEL: listReversed[index]
                }).then((value) => {
                  Logging.log.info('Back from car detail screen'),
                  // Update favorite status on each car
                  initFavoriteList(),
                  // context.read<HistoryBloc>().add(GetHistoryDataEvent())
                });
            Logging.log.info("save car to db");
            Logging.log.warn(listReversed[index].priceValue);
          },
          favoriteCallBack: (bool isFavorite, int index) {
            Logging.log.info(isFavorite);
            var listReversed = listItemBrowserHistory.reversed.toList();

            var indBeforeSort =
                listReversed.indexOf(listItemBrowserHistory[index]);
            if (isFavorite) {
              context
                  .read<HistoryBloc>()
                  .add(SaveFavoriteToDBEvent(listReversed[index]));
              callApiFavoriteAccess(indBeforeSort);
            } else {
              // When UnFavorite a Favorite Icon

              context.read<HistoryBloc>().add(DeleteFavoriteFromDBEvent(
                  listItemBrowserHistory[indBeforeSort], () {}));
            }
            Logging.log.warn(listReversed[index].priceValue);
          },
          quoteCallBack: (int index) {
            var listReversed = listItemBrowserHistory.reversed.toList();
            Navigator.of(context).pushNamed(AppRoutes.quotationPage,
                arguments: {Constants.ITEM_SEARCH_MODEL: listReversed[index]});
          },
          phoneCallBack: () {
            Logging.log.info("phoneCallBack");
          }),
    );
  }

  callApiFavoriteAccess(int index) {
    var exhNumValue = listItemBrowserHistory[index].corner +
        listItemBrowserHistory[index].fullExhNum;
    FavoriteAccessModel favoriteAccessModel = FavoriteAccessModel(
        memberNum: loginModel.memberNum,
        carName: listItemBrowserHistory[index].carName,
        exhNum: exhNumValue,
        makerCode: int.parse(listItemBrowserHistory[index].makerCode),
        userNum: loginModel.userNum);

    context
        .read<HistoryBloc>()
        .add(GetFavoriteAccessEvent(context, favoriteAccessModel));
  }

  _buildListSearchHistory() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      child: ListviewSearchHistoryWidget(
        listData: listItemSearchHistory.reversed.toList(),
        onCallBackItemSearchHistory: (int index) async {
          var listReversed = listItemSearchHistory.reversed.toList();
          SearchInputModel searchListModel = SearchInputModel(
              nenshiki1: listReversed[index].nenshiki1,
              nenshiki2: listReversed[index].nenshiki2,
              distance1: listReversed[index].distance1,
              distance2: listReversed[index].distance2,
              haikiryou1: listReversed[index].haikiryou1,
              haikiryou2: listReversed[index].haikiryou2,
              price1: listReversed[index].price1,
              price2: listReversed[index].price2,
              inspection: listReversed[index].inspection,
              mission: listReversed[index].mission,
              freeword: listReversed[index].freeword,
              color: listReversed[index].color,
              repair: listReversed[index].repair,
              area: listReversed[index].area,
              callCount: listReversed[index].callCount,
              makerCode1: listReversed[index].makerCode1,
              makerCode2: listReversed[index].makerCode2,
              makerCode3: listReversed[index].makerCode3,
              makerCode4: listReversed[index].makerCode4,
              makerCode5: listReversed[index].makerCode5,
              carName1: listReversed[index].carName1,
              carName2: listReversed[index].carName2,
              carName3: listReversed[index].carName3,
              carName4: listReversed[index].carName4,
              carName5: listReversed[index].carName5);

          Navigator.of(context).pushNamed(AppRoutes.searchListPage,
              arguments: {"searchListModel": searchListModel, "type": 1});
        },
      ),
    );
  }

  initFavoriteList() async {
    favoriteList = [];

    context.read<HistoryBloc>().add(GetHistoryDataEvent());
    var favorites = await context.read<HistoryBloc>().onGetCarObjectList(
        Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

    favorites.forEach((element) {
      favoriteList.add(FavoriteHive(questionNo: element.questionNo));
    });
    setState(() {});
  }
}
