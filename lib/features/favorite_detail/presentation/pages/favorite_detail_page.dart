import 'dart:collection';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/table_data/table_data_widget_1.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_bloc.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_event.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_state.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:http/http.dart';

class FavoriteDetailPage extends StatefulWidget {
  ItemSearchModel itemSearchModel;

  FavoriteDetailPage({required this.itemSearchModel});

  @override
  _FavoriteDetailPageState createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
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
        appBarTitle: "FAVORITE".tr(),
        hasMenuBar: false,
        buttonBottom: _openFooter(),
        appBarColor: ResourceColors.color_FF1979FF,
        body: _buildBody());
  }

  Widget _buildBody() {
    return BlocConsumer<FavoriteDetailBloc, FavoriteDetailState>(
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
      return _buildUI();
    });
  }

  callSearchDetail2Api() async {
    // Call API 35 (Search Detail)
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';
    SearchCarInputModel searchCarInputModel = SearchCarInputModel(
        exhNum: widget.itemSearchModel.exhNum.toString(),
        corner: widget.itemSearchModel.corner,
        makerCode: int.parse(widget.itemSearchModel.makerCode),
        aACount: widget.itemSearchModel.aaCount,
        carNo:
            widget.itemSearchModel.corner + widget.itemSearchModel.fullExhNum,
        memberNum: memberNum,
        userNum: int.parse(userNum));
    context
        .read<FavoriteDetailBloc>()
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
    dowloadAndSaveImageUrlToList();
  }

  _buildUI() {
    return _buildCarDetailInfo();
  }

  _buildCarDetailInfo() {
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
          _buildPrice(),
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
          )
        ],
      ),
    );
  }

  _buildPrice() {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.getHeight(8.0)),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: TextWidget(
                label: "PRICE_MAIN".tr(),
                textStyle:
                    MKStyle.t12R.copyWith(color: ResourceColors.color_3bb1dd),
              )),
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

  _buildQuestionNoAndPrice() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.getHeight(8.0), left: Dimens.getHeight(8.0)),
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
                textStyle: MKStyle.t14R,
                label: "500-" +
                    widget.itemSearchModel.corner +
                    widget.itemSearchModel.fullExhNum),
          ),
          Expanded(flex: 2, child: SizedBox.shrink())
        ],
      ),
    );
  }

  _buildCarInfoTitle() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.getHeight(8.0),
          top: Dimens.getHeight(8.0),
          right: Dimens.getHeight(8.0),
          left: Dimens.getHeight(8.0)),
      child: TextWidget(
        label: widget.itemSearchModel.makerName +
            widget.itemSearchModel.carName +
            widget.itemSearchModel.carGrade,
      ),
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
            PageView.builder(
              itemBuilder: (context, index) {
                return FittedBox(
                  child: photoBitmap[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount:
                  context.read<FavoriteDetailBloc>().countImageTotalEvent,
              onPageChanged: (int num) {
                print(num.toString());
                context
                    .read<FavoriteDetailBloc>()
                    .add(CountImageEvent(context, num + 1));
              },
              // Can be null
            ),
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
                          .read<FavoriteDetailBloc>()
                          .countImageCurrent
                          .toString(),
                      textStyle: MKStyle.t17R
                          .copyWith(color: ResourceColors.color_white),
                    ),
                    TextWidget(
                      label: '/',
                      textStyle: MKStyle.t17R
                          .copyWith(color: ResourceColors.color_white),
                    ),
                    TextWidget(
                      label: context
                          .read<FavoriteDetailBloc>()
                          .countImageTotalEvent
                          .toString(),
                      textStyle: MKStyle.t17R
                          .copyWith(color: ResourceColors.color_white),
                    )
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
        .read<FavoriteDetailBloc>()
        .onGetCarObjectList(
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

  dowloadAndSaveImageUrlToList() async {
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
      dowloadAndSaveImageUrlToList();
      return;
    }

    // When Click Back Buton(isBack = true) then dont dowload Image
    if (isBack == false && mounted) {
      context
          .read<FavoriteDetailBloc>()
          .add(CountImageTotalEvent(context, photoBitmap.length));

      if (photoUrl.length - 1 > downloadCnt) {
        //2回目以降
        downloadCnt++;
        dowloadAndSaveImageUrlToList();
      }
    }
  }

  _openFooter() {
    return Padding(
      padding: EdgeInsets.only(
        // bottom: Dimens.getHeight(5.0),
        top: Dimens.getHeight(5.0),
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
        callbackBtnLeft: (bool isFavoriteValue) {
          context
              .read<FavoriteDetailBloc>()
              .add(DeleteFavoriteFromDBEvent(widget.itemSearchModel));
          isBack = true;
          Navigator.pop(context);
        },
        callbackBtnCenter: () {
          Navigator.of(context).pushNamed(AppRoutes.quotationPage,
              arguments: {Constants.ITEM_SEARCH_MODEL: widget.itemSearchModel});
        },
        callbackToCall: () {},
      ),
    );
  }
}
