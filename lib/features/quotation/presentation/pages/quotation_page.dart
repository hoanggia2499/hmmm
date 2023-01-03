import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/button_icon_widget.dart';
import 'package:mirukuru/core/widgets/common/sub_title_2_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/table_data/table_data_widget_1.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_event.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_state.dart';
import 'package:mirukuru/features/quotation/presentation/models/inquiry_type_enum.dart';
import 'package:mirukuru/features/quotation/presentation/widgets/animated_indicator.dart';
import 'package:mirukuru/features/quotation/presentation/widgets/blink_star_widget.dart';
import 'package:mirukuru/features/quotation/presentation/widgets/expandable_widget.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../../core/secure_storage/user_secure_storage.dart';
import '../../../../core/widgets/common/custom_text_field_note.dart';
import '../../../search_detail/data/models/search_car_input_model.dart';

class QuotationPage extends StatefulWidget {
  final ItemSearchModel itemSearchModel;

  QuotationPage({required this.itemSearchModel});

  @override
  _QuotationPageState createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  LoginModel loginModel = LoginModel();
  ValueNotifier<bool?> isFavorite = ValueNotifier(null);
  List<SearchCarModel> searchCarModelList = [];

  List<String> listQuotationData = InquiryTypeExtension.getInquiryListData();
  ValueNotifier<int> selectedQuotationOption = ValueNotifier(0);

  TextEditingController questionController = TextEditingController();

  @override
  void initState() {
    getLoginModel();
    checkFavorite();
    initCarModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarLogo: loginModel.logoMark.isEmpty
            ? ''
            : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
        appBarTitle: "QUOTATION_TITLE".tr(),
        storeName: loginModel.storeName2.isNotEmpty
            ? '${loginModel.storeName}\n${loginModel.storeName2}'
            : loginModel.storeName,
        hasMenuBar: false,
        appBarColor: ResourceColors.color_FF1979FF,
        body: BlocListener<QuotationBloc, QuotationState>(
            listener: (context, state) async {
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

                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.loginPage, (route) => false);
              }

              if (state is InquirySentState) {
                await CommonDialog.displayDialog(
                    context, "", "REGISTERED_COMMENT".tr(), true,
                    eventCallBack: () {
                  Navigator.of(context).pop();
                });
              }

              if (state is Loaded) {
                searchCarModelList = state.searchCarModelList;
              }
            },
            child: _buildBody()));
  }

  Widget _buildBody() {
    return BlocBuilder<QuotationBloc, QuotationState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        return Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCarTitle(),
                  _buildPager(),
                  _buildContactUsInfo(),
                  _buildPriceInfo(),
                  _buildCarDetailInfo(),
                  _buildQuestionTitle(),
                  _buildQuestionBody(),
                  _buildTextFieldNote(),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: _buildBoxDecoration(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _openFooter(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [const Color(0xFFEEF9FF), const Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter));
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;
    });
  }

  void initCarModel() async {
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
        .read<QuotationBloc>()
        .add(InitCarModelEvent(context, searchCarInputModel));
  }

  // @override
  // void setState(VoidCallback fn) {
  //   if ()
  // }

  checkFavorite() async {
    var favoriteList = await context
        .read<QuotationBloc>()
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
    isFavorite.value = alreadyExist;
  }

  _buildQuestionBody() {
    return Center(
      child: RowWidgetPattern15(
          listData: listQuotationData,
          radioCallBack: (int index) {
            Logging.log.info("Selected Index: $index");
            selectedQuotationOption.value = index;
          }),
    );
  }

  Widget _buildTextFieldNote() {
    final maxLines = 5;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
        bottom: Dimens.getHeight(80.0),
      ),
      child: CustomTextFieldNote(
        maxLines: maxLines,
        fieldNoteController: questionController,
      ),
    );
  }

  Widget _buildCarDetailInfo() => ExpandableWidget(
        headerWithIndicator: _buildCarInfoTitle,
        body: _buildCarInfoBody(),
      );

  Widget _buildCarInfoBody() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(25.0),
        right: Dimens.getHeight(25.0),
      ),
      child: TableDataWidgetPage01(
          hasEquipment: false,
          itemSearchModel: widget.itemSearchModel,
          searchCarModel: searchCarModelList.length >= 1
              ? searchCarModelList[0]
              : SearchCarModel()),
    );
  }

  Widget _buildCarInfoTitle(
      BuildContext context, ExpandableWidgetState newState) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
      ),
      child: SubTitle2.withIconWidget(
        label: "VIEW_CAR_INFORMATION".tr(),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
        iconWidget: AnimatedIndicator(
          icon: "assets/images/png/zoomOut.png",
          state: (newState == ExpandableWidgetState.INITIAL ||
                  newState == ExpandableWidgetState.COLLAPSED)
              ? AnimatedIndicatorState.ON
              : AnimatedIndicatorState.OFF,
        ),
      ),
    );
  }

  _buildQuestionTitle() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
      ),
      child: SubTitle2(
        label: "CONTACT_US_CONTENT".tr(),
        textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
      ),
    );
  }

  _buildCarTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: Dimens.getWidth(25.0),
        right: Dimens.getWidth(10.0),
        bottom: Dimens.getHeight(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 9,
            child: Container(
              margin: EdgeInsets.only(top: Dimens.getHeight(24.0)),
              child: TextWidget(
                textStyle: MKStyle.t14R,
                label:
                    "${widget.itemSearchModel.makerName} ${widget.itemSearchModel.carName} ${widget.itemSearchModel.carGrade}",
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder<bool?>(
              valueListenable: isFavorite,
              builder: (context, isFav, child) {
                if (isFav != null) {
                  return BlinkStarWidget(
                      onClickedListener: (value) async {
                        isFavorite.value = value;
                        if (isFavorite.value == true) {
                          context.read<QuotationBloc>().add(
                              SaveFavoriteToDBEvent(widget.itemSearchModel));
                        } else {
                          context.read<QuotationBloc>().add(
                              DeleteFavoriteFromDBEvent(
                                  widget.itemSearchModel));
                        }
                      },
                      initialValue: isFav);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildPager() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(25.0),
        right: Dimens.getHeight(25.0),
        bottom: Dimens.getHeight(10.0),
      ),
      child: Container(
        child: FadeInImage.assetNetwork(
          width: MediaQuery.of(context).size.width,
          image: widget.itemSearchModel.imageUrl,
          imageErrorBuilder: (_, __, ___) {
            return Image.asset(
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              'assets/images/png/no_image_s.png',
            ); //this is what will fill the Container in case error happened
          },
          placeholder: 'assets/images/png/no_image_s.png',
          placeholderFit: BoxFit.fill, // your assets image path
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _buildContactUsInfo() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getWidth(25.0),
        right: Dimens.getWidth(25.0),
      ),
      child: Row(
        children: [
          TextWidget(
            label: "CONTACT_US_NUMBER".tr(),
            textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
          ),
          SizedBox(
            width: Dimens.getWidth(30.0),
          ),
          TextWidget(
            label: "500-" +
                widget.itemSearchModel.corner +
                widget.itemSearchModel.fullExhNum,
            textStyle: MKStyle.t14R,
          )
        ],
      ),
    );
  }

  _buildPriceInfo() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(25.0),
        right: Dimens.getHeight(25.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
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
            flex: 1,
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
            label: widget.itemSearchModel.yen,
            textStyle: MKStyle.t15R,
          ),
        ),
        Visibility(
          visible: (widget.itemSearchModel.priceValue == "ーー" &&
                  widget.itemSearchModel.priceValue2 == '')
              ? false
              : true,
          child: Padding(
            padding: EdgeInsets.only(top: Dimens.getWidth(8.0)),
            child: TextWidget(
              label: "RECYCLE_FEE".tr(),
              textStyle: MKStyle.t11R,
            ),
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

  // When check a Favorite Icon

  _openFooter() {
    return Visibility(
      visible: !HelperFunction.instance.isSoftKeyBoardVisible(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonIconWidget(
            width: MediaQuery.of(context).size.width / 2.3,
            height: Dimens.getHeight(35),
            buttonType: Constants.MAIN_BUTTON,
            borderRadius: Dimens.getHeight(30),
            textButton: "CANCEL".tr(),
            clickButtonCallBack: (bool isFavoriteValue) async {
              if (isFavoriteValue) {
                context
                    .read<QuotationBloc>()
                    .add(SaveFavoriteToDBEvent(widget.itemSearchModel));
              } else {
                context
                    .read<QuotationBloc>()
                    .add(DeleteFavoriteFromDBEvent(widget.itemSearchModel));
              }
              checkFavorite();
            },
            backgroundColor: ResourceColors.color_70,
          ),
          ButtonIconWidget(
            width: MediaQuery.of(context).size.width / 2.3,
            height: Dimens.getHeight(35),
            buttonType: Constants.MAIN_BUTTON,
            borderRadius: Dimens.getHeight(30),
            textButton: "SEND".tr(),
            clickButtonCallBack: (bool value) async {
              var id = selectedQuotationOption.value + 1;
              context.read<QuotationBloc>().add(MakeAnInquiryEvent(
                  InquiryRequestModel.from(
                      loginModel.memberNum,
                      loginModel.userNum,
                      widget.itemSearchModel.corner +
                          widget.itemSearchModel.fullExhNum,
                      int.tryParse(widget.itemSearchModel.makerCode) ?? 0,
                      widget.itemSearchModel.makerName,
                      widget.itemSearchModel.carName,
                      id,
                      questionController.text)));
            },
            backgroundColor: ResourceColors.color_0FA4EA,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    isFavorite.dispose();
    selectedQuotationOption.dispose();
    super.dispose();
  }
}
