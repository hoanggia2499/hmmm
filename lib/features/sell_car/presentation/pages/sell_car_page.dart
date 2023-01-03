import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_bloc.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_event.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_state.dart';
import '../../../../core/util/app_route.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/common/custom_text_field_note.dart';
import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import '../../../my_page/data/models/user_car_name_model.dart';
import '../../data/model/sell_car_get_list_image.dart';
import '../../data/model/sell_car_model.dart';

class SellCarPage extends StatefulWidget {
  final UserCarModel userCarModel;

  SellCarPage({required this.userCarModel});

  @override
  _SellCarPageState createState() => _SellCarPageState();
}

class _SellCarPageState extends State<SellCarPage> {
  LoginModel loginModel = LoginModel();
  TextEditingController freeWorldController = TextEditingController();
  var bodyColor = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // context.read<SellCarBloc>().add(SellCarInit());
    super.initState();
    getLoginModel();
    getLocalData();
  }

  void getLocalData() async {
    context.read<SellCarBloc>().add(GetLocalDataEvent());
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    setState(() {
      loginModel = localLoginModel;

      context.read<SellCarBloc>().add(
            GetCarListImagesEvent(
              SellCarGetCarImagesRequestModel(
                  memberNum: loginModel.memberNum,
                  upKind:
                      '1', // upKind = 1 is path directory to save photos of car regis
                  userNum: (loginModel.userNum).toString(),
                  userCarNum: widget.userCarModel.userCarNum ?? "0"),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "SELL_CAR_TITLE".tr(),
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      hasMenuBar: true,
      resizeToAvoidBottomInset: true,
      appBarColor: ResourceColors.color_FF1979FF,
      buttonBottom: _openFooter(),
      body: BlocListener<SellCarBloc, SellCarState>(
        listener: (context, state) async {
          if (state is Error) {
            await CommonDialog.displayDialog(context, state.errorModel.msgCode,
                state.errorModel.msgContent, false);
          }
          if (state is TimeOut) {
            await CommonDialog.displayDialog(context, state.errorModel.msgCode,
                state.errorModel.msgContent, false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }

          if (state is InitLocalData) {
            List<NameBeanHive> _listColorName = [];
            state.listNameBeanHive.forEach((element) {
              if (element.nameKbn == 7 || element.nameKbn == 0) {
                _listColorName.add(element);
              }
            });
            bodyColor = _listColorName
                    .firstWhere(
                        (e) =>
                            e.nameCode ==
                            int.parse(widget.userCarModel.colorName ?? "0"),
                        orElse: () => _listColorName.first)
                    .name ??
                Constants.OTHER_STATUS;
          }

          if (state is PostSuccess) {
            await CommonDialog.displayDialog(
              context,
              '',
              state.success,
              false,
            );
            Navigator.pop(
              context,
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SellCarBloc, SellCarState>(
      buildWhen: (previous, current) {
        if (previous is SellCarUpdatedPhotos &&
            current is SellCarUpdatedPhotos) {
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

        if (state is CarListImagesLoaded) {
          context.read<SellCarBloc>().existingPhotoList =
              PhotoData.convertFrom(state.images);
        }
        return Container(
            color: ResourceColors.color_FFFFFF, child: buildMain());
      },
    );
  }

  buildMain() {
    var carModelYear = widget.userCarModel.carModel != null
        ? HelperFunction.instance
            .getJapanYearFromAd(int.parse(widget.userCarModel.carModel!))
        : "";

    var inspectionDateExpiration = HelperFunction.instance
        .formatJapanDateString(widget.userCarModel.inspectionDate);

    var distance = widget.userCarModel.mileage != null
        ? widget.userCarModel.mileage.toString()
        : "";
    UserCarNameModel userCarModel =
        widget.userCarModel.userCarNameModel ?? UserCarNameModel();
    var carName =
        (userCarModel.makerName ?? "") + " " + (userCarModel.carGroup ?? "");
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(5.0), right: Dimens.getWidth(5.0)),
      child: Column(
        children: [
          buildSubTitle(),
          Expanded(
              child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              buildCarName(carName),
              buildRowInfo(
                  title1: "MODEL_YEAR_HISTORY".tr(),
                  value1: carModelYear,
                  title2: "INSPECTION_EXPIRARION".tr(),
                  value2: inspectionDateExpiration),
              buildRowInfo(
                title1: "COLOR".tr(),
                value1: bodyColor,
                title2: "MILEAGE".tr(),
                value2: distance,
              ),
              buildTitlePickupPhoto(),
              buttonPickupAPhoto(),
              buildTitleInputQuestion(),
              buildTextFieldNote(),
              SizedBox(
                height: Dimens.getHeight(10),
              ),
            ],
          )),
        ],
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

  Widget buildTextFieldNote() {
    final maxLines = 5;
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFieldNote(
            maxLines: maxLines,
            fieldNoteController: freeWorldController,
            maxLength: 500,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextWidget(
              label: "VALIDATE_INPUT_500".tr(),
              textStyle: MKStyle.t10R,
            ),
          ),
        ],
      ),
    );
  }

  _openFooter() {
    return Container(
      decoration: _buildBoxDecoration(),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: Dimens.getWidth(10.0),
          left: Dimens.getWidth(15.0),
          right: Dimens.getWidth(15.0),
        ),
        child: RowWidgetPattern17(
          widthLeft: MediaQuery.of(context).size.width / 3.0,
          widthRight: MediaQuery.of(context).size.width / 2.2,
          textButtonCenter: "CANCEL".tr(),
          textButtonRight: "REGISTER_WITH_CONTENT".tr(),
          backgroundColorCenter: ResourceColors.color_70,
          backgroundColorRight: ResourceColors.color_0FA4EA,
          callbackBtnLeft: (bool isFavoriteValue) async {},
          callbackBtnCenter: () {},
          callbackToCall: () {
            postSellCar();
          },
        ),
      ),
    );
  }

  /// Build button to send a new question
  postSellCar() async {
    int userCn = widget.userCarModel.userCarNum != null
        ? int.parse(widget.userCarModel.userCarNum!)
        : 0;

    int makerCd = widget.userCarModel.makerCode != null
        ? int.parse(widget.userCarModel.makerCode!)
        : 0;

    String makerNm = widget.userCarModel.userCarNameModel?.makerName != null
        ? widget.userCarModel.userCarNameModel?.makerName! ?? ""
        : "";
    String carNm = widget.userCarModel.userCarNameModel?.carGroup != null
        ? widget.userCarModel.userCarNameModel?.carGroup! ?? ""
        : "";

    var newSellCarRequest = SellCarModel(
      memberNum: loginModel.memberNum,
      userNum: loginModel.userNum,
      exhNum: "", // exhNum undefined so default is ""
      userCarNum: userCn,
      makerCode: makerCd,
      makerName: makerNm,
      carName: carNm,
      id: 4, // kubun_id is 5 to select other division
      question: freeWorldController.text.tr(),
      questionKbn: null,
      upKind: "1", // share the repository with own_car
    );

    validateForm(() =>
        {context.read<SellCarBloc>().add(PostSellCarEvent(newSellCarRequest))});
  }

  validateForm(Function nextAction) async {
    var errorComment = [];

    if (errorComment.isNotEmpty) {
      CommonDialog.displayDialog(
        context,
        "",
        errorComment.join("\n"),
        true,
        eventCallBack: () {},
      );
    } else {
      nextAction.call();
    }
  }

  Widget buttonPickupAPhoto() {
    return ShowAndPickupPhotoView(
      context: context,
      isGridViewTypeDisplay: true,
      onPhotoDeleted: (deletePhotoDataList) {
        context.read<SellCarBloc>().deletePhotoList = deletePhotoDataList;
      },
      onPhotoSelected: (uploadPhotoDataList) {
        context.read<SellCarBloc>().uploadPhotoList = uploadPhotoDataList;
      },
      photos: context.read<SellCarBloc>().existingPhotoList,
    );
  }

  Widget buildSubTitle() {
    return SubTitle(
      label: 'OWNED_CAR_INFORMATION'.tr(),
      textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_333333),
    );
  }

  Widget buildCarName(String carName) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(10.0), bottom: Dimens.getWidth(5.0)),
      child: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(label: carName, textStyle: MKStyle.t14R)),
    );
  }

  Widget buildTitlePickupPhoto() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.getWidth(5.0),
          bottom: Dimens.getWidth(5.0),
          top: Dimens.getWidth(5.0)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
            label: "PLEASE_POST_VEHICLE_INFORMATION".tr(),
            textStyle: MKStyle.t10R),
      ),
    );
  }

  Widget buildTitleInputQuestion() {
    return Padding(
      padding: EdgeInsets.only(
          top: Dimens.getWidth(10.0), bottom: Dimens.getWidth(10.0)),
      child: SubTitle(
        label: 'COMMENT_SELL_PAGE'.tr(),
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_333333),
      ),
    );
  }

  buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  Widget buildRowInfo(
      {String title1 = '',
      String value1 = '',
      String title2 = '',
      String value2 = ''}) {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextWidget(
              label: title1,
              textStyle: MKStyle.t8R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextWidget(label: value1, textStyle: MKStyle.t14R),
          ),
          SizedBox(
            width: Dimens.getWidth(20.0),
          ),
          Expanded(
            flex: 2,
            child: TextWidget(
              label: title2,
              textStyle: MKStyle.t8R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 7,
            child: TextWidget(label: value2, textStyle: MKStyle.t14R),
          ),
        ],
      ),
    );
  }
}
