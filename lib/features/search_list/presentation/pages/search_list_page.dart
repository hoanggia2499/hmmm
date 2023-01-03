import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/features/search_list/presentation/pages/widget/listview_search.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/search_input/data/models/search_input_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_bloc.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_event.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_state.dart';

import '../../../../core/config/core_config.dart';
import '../../../../core/db/core_db.dart';
import '../../../../core/resources/core_resource.dart';
import '../../../../core/util/core_util.dart';
import '../../../../core/widgets/core_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchListPage extends StatefulWidget {
  final SearchInputModel searchListModel;
  final int typeScreen;
  SearchListPage({required this.searchListModel, required this.typeScreen});
  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  int loadCnt = 0;
  LoginModel loginModel = LoginModel();
  List<ItemSearchModel>? listItemSearchModel = [];
  bool isShowFooter = false;
  ScrollController scrollController = ScrollController();
  bool isCompletedLoadMore = false;
  List<int> listNumberOfChecked = [];
  List<FavoriteHive> favoriteList = [];

  @override
  void initState() {
    // Flag to show/hide bottom menu
    // which allow to add favorite car or request est
    isShowFooter = false;
    loadCnt = 1;
    // Set user info in top
    getLoginModel();
    // Get search result
    getSearchResult(loadCnt);
    // init scroll listener
    // loadMoreData();
    // Get favorite list in local DB
    // initFavoriteList();
    context.read<SearchListBloc>().add(InitFavoriteListEvent());
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
      appBarTitle: "SEARCH_LIST_PAGE".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      body: BlocListener<SearchListBloc, SearchListState>(
        listener: (buildContext, searchListState) async {
          if (searchListState is Loaded) {
            // listItemSearchModel = getNewListItemSearchModel(
            //     pic1Map, searchListState.listItemSearchModel);
            listItemSearchModel?.addAll(searchListState.listItemSearchModel);
          }

          if (searchListState is RequestEstimate) {
            // Move to MultiEstimateActivity With (Common.multiEstimateList) =  listItemSearchModel data
          }

          if (searchListState is Loading &&
              (listItemSearchModel?.isEmpty ?? true)) {
            await EasyLoading.show();
          }

          if (searchListState is Error) {
            await CommonDialog.displayDialog(
                context, searchListState.messageCode, eventCallBack: () {
              if (searchListState.messageCode == "5MA016SE") {
                Navigator.pop(context);
              }
            }, searchListState.messageContent, false);
          }
          if (searchListState is TimeOut) {
            await CommonDialog.displayDialog(
                context,
                searchListState.messageCode,
                searchListState.messageContent,
                false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchListBloc, SearchListState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      if (state is Loading) {
        EasyLoading.show();
      }
      if (state is LoadedInitFavorite) {
        // Get Favorite List and based on Favorite List for Check お気に入り ( Show Favorite Icon UI)
        favoriteList = state.listFavoriteHive;
      }
      return Stack(
        children: [
          ListviewSearch(
              initListFavorite: favoriteList,
              initListNumberOfChecked: listNumberOfChecked,
              completedLoadMore: () {
                isCompletedLoadMore = true;
              },
              scrollController: scrollController,
              listItemSearchModel: listItemSearchModel,
              callBackItemChecked: (int currentNumberOfCheckedValue,
                  List<int> listNumberOfCheckedValue) {
                context.read<SearchListBloc>().add(IncreaseRequestCountEvent(
                    context, currentNumberOfCheckedValue));
                listNumberOfChecked = listNumberOfCheckedValue;
              },
              deleteCallBack: () {},
              topCallBack: (int index) async {
                // Move to SearchDetailActivity With data itemSearchModel -- Continute for Next Sprint
                Logging.log.info("top call back");
                context
                    .read<SearchListBloc>()
                    .add(SaveCarToDBEvent(listItemSearchModel![index]));
                Logging.log.info("save car db");
                Navigator.of(context).pushNamed(AppRoutes.searchDetailPage,
                    arguments: {
                      Constants.ITEM_SEARCH_MODEL: listItemSearchModel![index]
                    }).then((value) => {
                      Logging.log.info('Back from car detail screen'),
                      // Update favorite status on each car
                      context
                          .read<SearchListBloc>()
                          .add(InitFavoriteListEvent())
                    });
              },
              favoriteCallBack: (bool isFavorite, int index) {
                Logging.log.info("favoriteCallBack");
                print(isFavorite);
                if (isFavorite) {
                  // When check a Favorite Icon
                  context
                      .read<SearchListBloc>()
                      .add(SaveFavoriteToDBEvent(listItemSearchModel![index]));
                  callApiFavoriteAccess(index);
                } else {
                  // When UnFavorite a Favorite Iconcontext
                  context.read<SearchListBloc>().add(
                      DeleteFavoriteFromDBEvent(listItemSearchModel![index]));
                }
              },
              quoteCallBack: (int index) {
                Logging.log.info("quoteCallBack");
                Navigator.of(context).pushNamed(AppRoutes.quotationPage,
                    arguments: {
                      Constants.ITEM_SEARCH_MODEL: listItemSearchModel![index]
                    }).then((value) => {
                      Logging.log.info('Back from Quotation screen'),
                      // Update favorite status on each car
                      context
                          .read<SearchListBloc>()
                          .add(InitFavoriteListEvent()),
                    });
              },
              phoneCallBack: () {
                Logging.log.info("phoneCallBack");
              },
              isEndList: !context.read<SearchListBloc>().hasMoreData,
              totalItemsCount: context.read<SearchListBloc>().totalCount,
              loadMorePageCallback: () {
                context.read<SearchListBloc>().add(GetSearchListEvent(
                    context,
                    context.read<SearchListBloc>().getSearchListModelParam,
                    context.read<SearchListBloc>().pic1MapVar));
              }),
        ],
      );
    });
  }

  callApiFavoriteAccess(int index) {
    var exhNumValue = listItemSearchModel![index].corner +
        listItemSearchModel![index].fullExhNum;
    FavoriteAccessModel favoriteAccessModel = FavoriteAccessModel(
        memberNum: loginModel.memberNum,
        carName: listItemSearchModel![index].carName,
        exhNum: exhNumValue,
        makerCode: int.parse(listItemSearchModel![index].makerCode),
        userNum: loginModel.userNum);

    context
        .read<SearchListBloc>()
        .add(GetFavoriteAccessEvent(context, favoriteAccessModel));
  }

  getNumberOfQuotationToday() {
    context.read<SearchListBloc>().add(RequestEstimateEvent(
        context, loginModel.memberNum, loginModel.userNum));
  }

  getSearchResult(int count) {
    // Get Pic1 to build url of each car
    context.read<SearchListBloc>().add(GetCarPic1Event(context,
        widget.searchListModel, count, widget.typeScreen == 0 ? 0 : 1));
  }
}
