import 'dart:collection';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_17_18.dart';
import 'package:mirukuru/core/widgets/table_data/table_data_widget_1.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_bloc.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_event.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_state.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import '../../../../core/widgets/common/template_page.dart';
import 'package:http/http.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';

class SearchDetailPage extends StatefulWidget {
  final ItemSearchModel itemSearchModel;

  SearchDetailPage({required this.itemSearchModel});

  @override
  _SearchDetailPageState createState() => _SearchDetailPageState();
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  LoginModel loginModel = LoginModel();
  bool isFavorite = false;
  PageController controller = PageController();
  List<Image> photoBitmap = [];
  List<String> photoUrl = [];
  bool downloadingL = true;
  int downloadCnt = 0;
  List<SearchCarModel> searchCarModelList = [];
  bool isBack = false;

  @override
  void initState() {
    getLoginModel();
    checkFavorite();
    callSearchDetail2Api();
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
        backCallBack: () {
          isBack = true;
          Navigator.pop(context);
        },
        appBarLogo: loginModel.logoMark.isEmpty
            ? ''
            : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
        appBarTitle: "SEARCH_DETAIL_TITLE".tr(),
        hasMenuBar: false,
        buttonBottom: _openFooter(),
        appBarColor: ResourceColors.color_FF1979FF,
        body: _buildBody());
  }

  Widget _buildBody() {
    return BlocConsumer<SearchDetailBloc, SearchDetailState>(
        listener: (context, state) async {
      // do stuff here based on BlocA's state
      if (state is Loaded) {
        searchCarModelList = state.searchCarModelList;
        handlePicNamesDataFromAPI35(searchCarModelList[0].pic);
      }

      if (state is Error) {
        await CommonDialog.displayDialog(context, state.messageCode,
            eventCallBack: () {
          if (state.messageCode == "5MA016SE") {
            Navigator.pop(context);
          }
        }, state.messageContent, false);
      }
      if (state is TimeOut) {
        await CommonDialog.displayDialog(
            context, state.messageCode, state.messageContent, false);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state
      return _buildCarInfo();
    });
  }

  callSearchDetail2Api() async {
    // Call API 35 (Search Detail)
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';
    SearchCarInputModel searchCarInputModel = SearchCarInputModel(
        exhNum: widget.itemSearchModel.exhNum.toString(),
        corner: widget.itemSearchModel.corner,
        makerCode: int.tryParse(widget.itemSearchModel.makerCode) != null
            ? int.parse(widget.itemSearchModel.makerCode)
            : 0,
        aACount: widget.itemSearchModel.aaCount,
        carNo:
            widget.itemSearchModel.corner + widget.itemSearchModel.fullExhNum,
        memberNum: memberNum,
        userNum: int.parse(userNum));
    context
        .read<SearchDetailBloc>()
        .add(SearchCarEvent(context, searchCarInputModel));
  }

  handlePicNamesDataFromAPI35(String picNames) {
    List<String> picNamesList = picNames.split(',');

    picNamesList.forEach((element) {
      photoUrl.add(widget.itemSearchModel.corner +
          widget.itemSearchModel.fullExhNum +
          element +
          ".jpg");
    });

    //1回目
    downloadingL = true;
    downloadCnt = 0;
    downloadAndSaveImageUrlToList();
  }

  _buildCarInfo() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarInfoTitle(),
          SizedBox(
            height: Dimens.getHeight(15.0),
          ),
          _buildPager(),
          SizedBox(
            height: Dimens.getHeight(25.0),
          ),
          _buildQuestionNoAndPrice(),
          _buildCarDetailInfo(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimens.getHeight(10.0),
                horizontal: Dimens.getWidth(10.0)),
            child: TableDataWidgetPage01(
                itemSearchModel: widget.itemSearchModel,
                searchCarModel: searchCarModelList.length >= 1
                    ? searchCarModelList[0]
                    : SearchCarModel()),
          ),
          SizedBox(
            height: Dimens.getHeight(28.0),
          ),
        ],
      ),
    );
  }

  _buildCarInfoTitle() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Dimens.getHeight(8.0),
        top: Dimens.getHeight(8.0),
        left: Dimens.getHeight(8.0),
        right: Dimens.getHeight(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: ScreenUtil.getScreenW(context) * (2 / 3),
            child: TextWidget(
              label: widget.itemSearchModel.makerName +
                  widget.itemSearchModel.carName +
                  widget.itemSearchModel.carGrade,
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                isFavorite = !isFavorite;
              });
              if (isFavorite == true) {
                context
                    .read<SearchDetailBloc>()
                    .add(SaveFavoriteToDBEvent(widget.itemSearchModel));
                callApiFavoriteAccess();
              } else {
                context
                    .read<SearchDetailBloc>()
                    .add(DeleteFavoriteFromDBEvent(widget.itemSearchModel));
              }
            },
            child: Image.asset(
              "assets/images/png/star.png",
              width: Dimens.getWidth(28.0),
              height: Dimens.getHeight(28.0),
              color: isFavorite == true
                  ? Colors.yellow
                  : ResourceColors.color_E1E1E1,
            ),
          ),
        ],
      ),
    );
  }

  _buildQuestionNoAndPrice() {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.getHeight(8.0)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextWidget(
              label: "CONTACT_US_NUMBER".tr(),
              textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextWidget(
              label: "500-" +
                  widget.itemSearchModel.corner +
                  widget.itemSearchModel.fullExhNum,
              textStyle: MKStyle.t14R,
            ),
          ),
          Expanded(flex: 2, child: SizedBox.shrink()),
        ],
      ),
    );
  }

  _buildCarDetailInfo() {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.getHeight(8.0)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextWidget(
              label: "PRICE_MAIN".tr(),
              textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 4,
            child: _buildPriceValue(),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }

  _buildPriceValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(
          label: widget.itemSearchModel.priceValue,
          textStyle: MKStyle.t20B.copyWith(color: ResourceColors.red_bg),
        ),
        Padding(
          padding: EdgeInsets.only(top: Dimens.getWidth(5.0)),
          child: TextWidget(
            label: widget.itemSearchModel.priceValue2,
            textStyle: MKStyle.t15B.copyWith(color: ResourceColors.red_bg),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: Dimens.getWidth(5.0)),
          child: TextWidget(
              label: widget.itemSearchModel.yen, textStyle: MKStyle.t15R),
        ),
        Visibility(
          visible: (widget.itemSearchModel.priceValue == "ーー" &&
                  widget.itemSearchModel.priceValue2 == '')
              ? false
              : true,
          child: Padding(
            padding: EdgeInsets.only(top: Dimens.getWidth(8.0)),
            child:
                TextWidget(label: 'RECYCLE_FEE'.tr(), textStyle: MKStyle.t11R),
          ),
        ),
        _buildIconStar(widget.itemSearchModel.stars < 1 ? false : true),
        _buildIconStar(widget.itemSearchModel.stars < 2 ? false : true),
        _buildIconStar(widget.itemSearchModel.stars < 3 ? false : true),
        _buildIconStar(widget.itemSearchModel.stars < 4 ? false : true),
        _buildIconStar(widget.itemSearchModel.stars < 5 ? false : true),
      ],
    );
  }

  _buildIconStar(bool isShowIcon) {
    return Visibility(
      visible: isShowIcon,
      child: Image.asset(
        'assets/images/png/bookmark_icon.png',
        fit: BoxFit.fill,
        height: Dimens.getHeight(15.0),
      ),
    );
  }

  _buildPager() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(8.0),
        right: Dimens.getHeight(8.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.width / 1.33,
        child: Stack(
          children: [
            // Image gallery
            PageView.builder(
              itemBuilder: (context, index) {
                return FittedBox(
                  child: photoBitmap[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: context.read<SearchDetailBloc>().countImageTotalEvent,
              onPageChanged: (int num) {
                print(num.toString());
                context
                    .read<SearchDetailBloc>()
                    .add(CountImageEvent(context, num + 1));
              },
              // Can be null
            ),
            // Number of images on left corner
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 6,
                color: Colors.black,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      label: context
                          .read<SearchDetailBloc>()
                          .countImageCurrent
                          .toString(),
                      textStyle: MKStyle.t16R
                          .copyWith(color: ResourceColors.color_white),
                    ),
                    TextWidget(
                        label: '/',
                        textStyle: MKStyle.t16R
                            .copyWith(color: ResourceColors.color_white)),
                    TextWidget(
                        label: context
                            .read<SearchDetailBloc>()
                            .countImageTotalEvent
                            .toString(),
                        textStyle: MKStyle.t16R
                            .copyWith(color: ResourceColors.color_white))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkFavorite() async {
    var favoriteList = await context
        .read<SearchDetailBloc>()
        .onGetFavoriteObjectList(
            Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

    var questionNo =
        widget.itemSearchModel.corner + widget.itemSearchModel.fullExhNum;

    bool alreadyExist = false;
    favoriteList.forEach((element) {
      if (element.questionNo == questionNo) {
        alreadyExist = true;
      }
    });
    if (alreadyExist) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
    setState(() {});
  }

  downloadAndSaveImageUrlToList() async {
    String imgUrl = "";
    String middleStr = widget.itemSearchModel.fullExhNum.substring(0, 4);

    if (downloadingL == true) {
      imgUrl = "https://imgml.asnet2.com/ASDATA/" +
          widget.itemSearchModel.corner +
          "/L/0000" +
          middleStr +
          "/" +
          photoUrl[downloadCnt];
      print(imgUrl);
    } else {
      imgUrl = "https://imgml.asnet2.com/ASDATA/" +
          widget.itemSearchModel.corner +
          "/M/0000" +
          middleStr +
          "/" +
          photoUrl[downloadCnt];
    }

    Uri myUri = Uri.parse(imgUrl);
    Response response = await get(myUri);
    Uint8List uint8list = response.bodyBytes;

    if ((response.statusCode == 200)) {
      photoBitmap.add(Image.memory(uint8list));
      downloadingL = true;
    } else if (downloadingL == true) {
      downloadingL = false;
      downloadAndSaveImageUrlToList();
      return;
    }

    // When Click Back Buton(isBack = true) then dont dowload Image
    if (isBack == false && mounted) {
      context
          .read<SearchDetailBloc>()
          .add(CountImageTotalEvent(context, photoBitmap.length));

      if (photoUrl.length - 1 > downloadCnt) {
        //2回目以降
        downloadCnt++;
        downloadAndSaveImageUrlToList();
      }
    }
  }

  _openFooter() {
    return Container(
      decoration: _buildBoxDecoration(),
      child: Padding(
        padding: EdgeInsets.only(
          top: Dimens.getHeight(10.0),
          bottom: Dimens.getHeight(3.0),
          left: Dimens.getWidth(10.0),
          right: Dimens.getWidth(10.0),
        ),
        child: RowWidgetPattern17(
          hasDivider: false,
          clickIcon: isFavorite,
          iconButtonCenter: "assets/images/png/mitsumori_icon.png",
          iconButtonRight: "assets/images/png/tel_icon.png",
          textButtonCenter: "QUOTATION_REQUEST".tr(),
          textButtonRight: "TO_CALL".tr(),
          callbackBtnLeft: (bool isFavoriteValue) async {
            if (isFavoriteValue) {
              context
                  .read<SearchDetailBloc>()
                  .add(SaveFavoriteToDBEvent(widget.itemSearchModel));
            } else {
              context
                  .read<SearchDetailBloc>()
                  .add(DeleteFavoriteFromDBEvent(widget.itemSearchModel));
            }
            checkFavorite();
          },
          callbackBtnCenter: () {
            Navigator.of(context).pushNamed(AppRoutes.quotationPage,
                arguments: {
                  Constants.ITEM_SEARCH_MODEL: widget.itemSearchModel
                }).then((value) => {
                  Logging.log.info('Back from Quotation  screen'),
                  // Update favorite status on each car
                  checkFavorite()
                });
          },
          callbackToCall: () {},
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [const Color(0xFFEEF9FF), const Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter));
  }

  callApiFavoriteAccess() {
    var exhNumValue =
        widget.itemSearchModel.corner + widget.itemSearchModel.fullExhNum;
    FavoriteAccessModel favoriteAccessModel = FavoriteAccessModel(
        memberNum: loginModel.memberNum,
        carName: widget.itemSearchModel.carName,
        exhNum: exhNumValue,
        makerCode: int.parse(widget.itemSearchModel.makerCode),
        userNum: loginModel.userNum);

    context
        .read<SearchDetailBloc>()
        .add(GetFavoriteAccessEvent(context, favoriteAccessModel));
  }
}
