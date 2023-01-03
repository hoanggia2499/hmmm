import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/features/favorite_list/presentation/bloc/favorite_list_state.dart';
import 'package:mirukuru/features/favorite_list/presentation/pages/widget/listview_favorite.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../bloc/favorite_list_bloc.dart';
import '../bloc/favorite_list_event.dart';

class FavoriteListPage extends StatefulWidget {
  Map<String, String> pic1Map;

  FavoriteListPage({required this.pic1Map});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  LoginModel loginModel = LoginModel();
  List<ItemSearchModel> favoriteObjectList = [];

  @override
  void initState() {
    getLoginModel();
    getCarPic1();
    // getFavoriteList();
    context.read<FavoriteListBloc>().add(GetCarFavoriteEvent(
        Constants.FAVORITE_OBJECT_LIST_TABLE,
        context.read<FavoriteListBloc>().pic1MapVar));
    super.initState();
  }

  getCarPic1() {
    // Get Pic1 to build url of each car
    context.read<FavoriteListBloc>().add(GetCarPic1Event(context));
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
      isHiddenLeadingPop: true,
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      currentIndex: Constants.FAVORITE_INDEX,
      backCallBack: () {
        // Back to Search Input Page
        Navigator.popAndPushNamed(context, AppRoutes.searchTopPage);
      },
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "FAVORITE".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<FavoriteListBloc, FavoriteListState>(
        listener: (context, state) async {
      // do stuff here based on BlocA's state
      if (state is Loaded) {
        favoriteObjectList = state.favoriteObjectList.reversed.toList();
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state
      return _buildCarList();
    });
  }

  _buildCarList() {
    //  var reversedList = favoriteObjectList.reversed.toList();
    return Container(
        child: ListViewFavorite(
      favoriteObjectList: favoriteObjectList,
      deleteCallBack: () {},
      favoriteOrRemoveCallBack: (int index) {
        handleRemoveFavorite(index);
      },
      phoneCallBack: () {},
      quoteCallBack: (int index) {
        Navigator.of(context).pushNamed(AppRoutes.quotationPage, arguments: {
          Constants.ITEM_SEARCH_MODEL: favoriteObjectList[index]
        }).then((value) => {
              context.read<FavoriteListBloc>().add(GetCarFavoriteEvent(
                  Constants.FAVORITE_OBJECT_LIST_TABLE,
                  context.read<FavoriteListBloc>().pic1MapVar))
            });
      },
      topCallBack: (int index) {
        context.read<FavoriteListBloc>().add(SaveCarToDBEvent(
            favoriteObjectList[index],
            favoriteObjectList.indexOf(favoriteObjectList[index])));
        setState(() {});
        Navigator.of(context).pushNamed(AppRoutes.favoriteDetailPage,
            arguments: {
              Constants.ITEM_SEARCH_MODEL: favoriteObjectList[index]
            }).then((value) => {
              context.read<FavoriteListBloc>().add(GetCarFavoriteEvent(
                  Constants.FAVORITE_OBJECT_LIST_TABLE,
                  context.read<FavoriteListBloc>().pic1MapVar))
            });
      },
    ));
  }

  handleRemoveFavorite(int index) async {
    var questionNo =
        favoriteObjectList[index].corner + favoriteObjectList[index].fullExhNum;
    await context.read<FavoriteListBloc>().onDeleteFavoriteByPositionList(
        Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo);

    setState(() {
      favoriteObjectList.removeAt(index);
    });
  }
}
