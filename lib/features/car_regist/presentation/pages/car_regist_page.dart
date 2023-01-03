import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/show_and_pickup_photo_view.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_text_field.dart';
import 'package:mirukuru/features/car_regist/data/model/get_car_images_request.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_bloc.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_event.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_state.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';

import '../../../../core/db/name_bean_hive.dart';
import '../../../my_page/presentation/pages/car_ownership_settings_screen.dart';
import '../../data/model/local_data_model.dart';
import '../../data/model/delete_own_car_request.dart';
import '../../data/model/post_own_car_request.dart';

class CarRegistPage extends StatefulWidget {
  final UserCarModel? userCarModel;

  CarRegistPage({required this.userCarModel});

  @override
  State<CarRegistPage> createState() => _CarRegistPageState();
}

class _CarRegistPageState extends State<CarRegistPage> {
  LoginModel loginModel = LoginModel();
  String mGradeValue = '';
  String mCategoryNumber = '';
  String mGradeHiragana = '';
  String mSpecifyNumber = '';
  String mVehicleNumber = '';
  String mDistance = '';

  PostOwnCarRequestModel _ownCarRequestModel = PostOwnCarRequestModel();
  List<NameBeanHive> _listNameBean = [];
  InputTextModel modelText = InputTextModel();

  RIKUJIModel mRIKUJIModel = RIKUJIModel(Constants.SELECTION_STATUS, -1);
  List<RIKUJIModel> _listRIKUJI = [];

  String mColorName = Constants.SELECTION_STATUS;
  List<NameBeanHive> _listColorName = [];

  String mCarModel = Constants.SELECTION_STATUS;
  List<String> _listCarModelYear = [];

  String mSellTime = Constants.SELECTION_STATUS;
  List<NameBeanHive> _listSellTime = [];

  String mInsuranceCompany = Constants.SELECTION_STATUS;
  List<NameBeanHive> _listInsuranceCompany = [];

  String mInsuranceExpirationDate = Constants.SELECTION_STATUS;
  String mDateInsuranceExpiration = Constants.SELECTION_STATUS;
  String mCarType = Constants.SELECTION_STATUS;

  late ItemMakerModel mMaker;

  @override
  void initState() {
    super.initState();
    getLoginModel();
    initLocalData();
    initMakerName();
    initCarModelList();
  }

  initMakerName() {
    final makerName = widget.userCarModel?.userCarNameModel?.makerName;
    mMaker = ItemMakerModel(
        makerCode: widget.userCarModel?.makerCode ?? "",
        makerName: (makerName != null && makerName.isNotEmpty)
            ? makerName
            : Constants.SELECTION_STATUS);
  }

  initLocalData() async {
    context.read<CarRegisBloc>().add(GetLocalDataEvent());
  }

  initDisplayData() {
    mCarType = widget.userCarModel?.userCarNameModel?.carGroup ??
        Constants.SELECTION_STATUS;

    /// init display data display
    //init carGrade
    mGradeValue = widget.userCarModel?.carGrade ?? '';
    // init plateNo1
    int? elementRIKUJI = widget.userCarModel?.plateNo1 != null
        ? int.parse(widget.userCarModel?.plateNo1 ?? "0")
        : 4111; // check native

    mRIKUJIModel = RIKUJIModel(
        _listRIKUJI
            .firstWhere((e) => e.nameKbn == elementRIKUJI,
                orElse: () => RIKUJIModel(Constants.SELECTION_STATUS, -1))
            .nameCode,
        elementRIKUJI);
    //init plateNo2
    mCategoryNumber = widget.userCarModel?.plateNo2 ?? '';
    //init plateNo3
    mGradeHiragana = widget.userCarModel?.plateNo3 ?? '';
    //init plateNo4
    mSpecifyNumber = widget.userCarModel?.plateNo4 ?? '';
    // init platformNum
    mVehicleNumber = widget.userCarModel?.platformNum ?? "";
    // init colorName
    getBodyColor(widget.userCarModel?.colorName);
    // init carModel
    getCarModel(widget.userCarModel?.carModel);
    // init inspectionDate
    mInsuranceExpirationDate = HelperFunction.instance
        .formatJapanDateString(widget.userCarModel?.inspectionDate);
    // init mileage
    mDistance = (widget.userCarModel?.mileage != null
            ? widget.userCarModel?.mileage.toString()
            : null) ??
        "";
    // init sellTime
    getSellTime(widget.userCarModel?.sellTime);
    // init nHokenInc
    getInsuranceCompany(widget.userCarModel?.nHokenInc);
    // init nHokenEndDay
    getDateInsuranceExpiration(widget.userCarModel?.nHokenEndDay);
    //init carCode
    context.read<CarRegisBloc>().initCarType =
        widget.userCarModel?.userCarNameModel?.asnetCarCode ?? "";

    /// init API data when the first visit or no field changes
    _ownCarRequestModel = PostOwnCarRequestModel.convertForm(
        widget.userCarModel ?? UserCarModel());
  }

  getLoginModel() async {
    loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
    context.read<CarRegisBloc>().add(
          GetCarListImagesEvent(
            GetCarImagesRequestModel(
                memberNum: widget.userCarModel?.memberNum,
                upKind:
                    '1', // upKind = 1 is path directory to save photos of car regis
                userNum: widget.userCarModel?.userNum,
                userCarNum: widget.userCarModel?.userCarNum),
          ),
        );
  }

  String getSellTime(String? sellTimeHive) {
    if (sellTimeHive != null) {
      //check native
      sellTimeHive = sellTimeHive.replaceAll(" ", "");
      if (sellTimeHive.isNotEmpty &&
          !(sellTimeHive == "0") &&
          !(sellTimeHive == "") &&
          !(sellTimeHive == "          ") &&
          !(sellTimeHive == "0     ")) {
        String sellTime =
            PostOwnCarRequestModel.getSellTime(sellTimeHive, _listNameBean);
        mSellTime = sellTime;
        return mSellTime;
      }
    } else {
      mSellTime = _listSellTime.first.name ?? Constants.SELECTION_STATUS;
    }
    return mSellTime;
  }

  String getCarModel(String? modelYear) {
    mCarModel = modelYear != null && modelYear.isNotEmpty
        ? HelperFunction.instance.getJapanYearFromAd(int.parse(modelYear))
        : _listCarModelYear[0];
    return mCarModel;
  }

  String getBodyColor(String? carColorHive) {
    String colorName =
        PostOwnCarRequestModel.getColorName(carColorHive, _listNameBean);
    mColorName = colorName.isNotEmpty
        ? colorName
        : _listColorName.first.name ?? Constants.SELECTION_STATUS;
    return mColorName;
  }

  String getDateInsuranceExpiration(String? nHokenEndDayHive) {
    if (nHokenEndDayHive != null) {
      nHokenEndDayHive = nHokenEndDayHive.replaceAll(" ", "");
      if (nHokenEndDayHive.isNotEmpty &&
          !(nHokenEndDayHive == "0") &&
          !(nHokenEndDayHive == "") &&
          !(nHokenEndDayHive == "          ") &&
          !(nHokenEndDayHive == "0     ")) {
        String nHokenDay = HelperFunction.instance
            .getJapanYearFromAdWithResultString(nHokenEndDayHive);
        mDateInsuranceExpiration = nHokenDay;
        return mDateInsuranceExpiration;
      }
    }
    return mDateInsuranceExpiration;
  }

  String getInsuranceCompany(String? nHokenIncHive) {
    String insurance =
        PostOwnCarRequestModel.getInsurance(nHokenIncHive, _listNameBean);
    mInsuranceCompany = insurance.isNotEmpty
        ? insurance
        : _listInsuranceCompany.first.name ??
            Constants.SELECTION_STATUS; //check native
    return mInsuranceCompany;
  }

  initListInsuranceCompany() {
    _listNameBean.forEach((element) {
      //nameKbn = 0 use to add 指定なし
      if (element.nameKbn == 6 || element.nameKbn == 0) {
        _listInsuranceCompany.add(element);
      }
    });
  }

  initListColorName() {
    _listNameBean.forEach((element) {
      if (element.nameKbn == 7 || element.nameKbn == 0) {
        _listColorName.add(element);
      }
    });
  }

  initListSellTime() {
    _listNameBean.forEach((element) {
      if (element.nameKbn == 3 || element.nameKbn == 0) {
        _listSellTime.add(element);
      }
    });
  }

  initCarModelList() async {
    DateTime now = new DateTime.now();
    int currentYear = now.year;

    _listCarModelYear.clear();
    _listCarModelYear.add('指定なし');

    while (_listCarModelYear.length < 50) {
      _listCarModelYear
          .add(HelperFunction.instance.getJapanYearFromAd(currentYear));
      currentYear--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
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
      appBarTitle: 'OWNED_CAR_INFORMATION'.tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      resizeToAvoidBottomInset: true,
      buttonBottom: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildListButtonBottom(),
      ),
      body: BlocListener<CarRegisBloc, CarRegisState>(
          listener: (context, state) async {
            if (!(state is Loading) && EasyLoading.isShow) {
              await EasyLoading.dismiss();
            }

            if (state is Loading) {
              await EasyLoading.show();
            }

            if (state is Error) {
              await CommonDialog.displayDialog(context, state.messageCode,
                  eventCallBack: () {
                if (state.messageContent == '5MA015SE') {
                  Navigator.pop(context);
                }
              }, state.messageContent, false);
            }

            /// controller fields
            _buildState(state);

            if (state is PostSuccess) {
              await CommonDialog.displayDialog(
                context,
                '',
                state.successContent,
                false,
              );
              Navigator.pop(
                context,
                ReturnedUserCarModel(
                  action: UserCarAction.EDIT,
                  userCarModel: null,
                ),
              );
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

            if (state is DeleteOwnCarLoaded) {
              Navigator.pop(
                context,
                ReturnedUserCarModel(
                  action: UserCarAction.DELETE,
                  userCarModel: widget.userCarModel,
                ),
              );
            }
          },
          child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CarRegisBloc, CarRegisState>(
      buildWhen: (previous, current) {
        if (previous is UpdatedPhotos && current is UpdatedPhotos) {
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

        if (state is CarTypePickerPopped) {
          mCarType = state.selectedCarTypeName;
          _ownCarRequestModel =
              _ownCarRequestModel.copyWith(carCode: state.selectedCarCode);
        }

        if (state is MakerCodeDialogPopped) {
          if (mMaker != state.selectedMaker) {
            mCarType = Constants.SELECTION_STATUS;
          }
          mMaker = state.selectedMaker;
        }
        if (state is CarListImagesLoaded) {
          context.read<CarRegisBloc>().existingPhotoList =
              PhotoData.convertFrom(state.images);
        }

        return Container(
          color: ResourceColors.color_FFFFFF,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: _buildMain(),
        );
      },
    );
  }

  Widget _buildMain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        subTitleGuide(),
        Expanded(
            child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            /// build makerCode, carCode
            buildMaker(),
            buildCarType(),

            /// build carGrade グレード
            buildGrade(),

            /// build templateNo1 地名コード
            buildGradeWithAreaCode(),

            ///build templateNo2 分類番号
            buildGradeWithCategoryNumber(),

            /// build templateNo3 ひらがな
            buildGradeWithHiragana(),

            /// build templateNo4 指定番号
            buildGradeWithSpecifyNumber(),

            /// build vehicle number 車台番号
            buildGradeWithVehicleNumber(),

            /// build nameColor ボディ色
            buildBodyColor(),

            /// build carModel 年式
            buildCarModelYear(),

            /// build inspectionDate 車検満了日
            buildExpirationDateOfVihicle(),

            /// build mileage 走行距離
            buildDistance(),

            /// build sellTime 売却時期
            buildSellTime(),

            /// build nHokenInc 任意保険会社
            buildInsuranceCompany(),

            /// build nHokenEndDay 任期保険満期日
            buildInsuranceExpirationDate(),

            /// build photo upload
            buildTextViewPhoto(),
            buttonPickupAPhoto(),

            SizedBox(
              height: Dimens.getHeight(10),
            ),
          ],
        )),
      ],
    );
  }

  void _buildState(CarRegisState state) {
    if (state is InitLocalData) {
      _listRIKUJI = state.localModel.listRIKUJI;
      _listNameBean = state.localModel.listNameBeanHive;
      _ownCarRequestModel = _ownCarRequestModel.copyWith(
        userNum: int.parse(widget.userCarModel?.userNum ?? "0"),
        memberNum: widget.userCarModel?.memberNum,
        userCarNum: int.parse(widget.userCarModel?.userCarNum ?? "0"),
      );
      initListSellTime();
      initListColorName();
      initListInsuranceCompany();
      initDisplayData();
    }

    if (state is MakerCodeDialogPopped) {
      /// api-makerCode
      var _itemMarkerCode = state.selectedMaker;
      _ownCarRequestModel =
          _ownCarRequestModel.copyWith(makerCode: _itemMarkerCode.makerCode);
      Logging.log.warn(_ownCarRequestModel.makerCode);
    }

    if (state is ChangeRIKUJIState) {
      ///api-plateNo1
      mRIKUJIModel = state.value;
      _ownCarRequestModel = _ownCarRequestModel.copyWith(
        plateNo1: state.value.nameKbn,
      );
    }

    if (state is ChangeSelectionFieldState) {
      ///api-inspectionDate
      if (state.modelSelection.inspectionDate != null &&
          state.modelSelection.inspectionDate !=
              DateTime.tryParse(widget.userCarModel?.inspectionDate ??
                  DateTime.now().toString())) {
        //case year is '指定なし' -> field is null
        if (state.modelSelection.inspectionDate!.year != 0) {
          mInsuranceExpirationDate = HelperFunction.instance.formatJapanDate(
              state.modelSelection.inspectionDate ?? DateTime.now());
          _ownCarRequestModel = _ownCarRequestModel.copyWith(
            inspectionDate:
                state.modelSelection.inspectionDate ?? DateTime.now(),
          );
        } else {
          mInsuranceExpirationDate = Constants.SELECTION_STATUS;
          _ownCarRequestModel = _ownCarRequestModel.copyWith(
            inspectionDate: DateTime.utc(0000), //-> mark that it's null
          );
        }
      }

      ///api-nHokenEndDate
      if (state.modelSelection.nHokenEndDate != null) {
        var param = DateUtil.formatDateStr(
            state.modelSelection.nHokenEndDate.toString(),
            isUtc: false,
            format: "yyyyMMdd");
        //case year is '指定なし' -> field is null
        if (param.substring(0, 1) != "0") {
          mDateInsuranceExpiration = HelperFunction.instance.formatJapanDate(
              state.modelSelection.nHokenEndDate ?? DateTime.now());

          _ownCarRequestModel = _ownCarRequestModel.copyWith(
            nHokenEndDay: param,
          );
        } else {
          mDateInsuranceExpiration = Constants.SELECTION_STATUS;
          _ownCarRequestModel = _ownCarRequestModel.copyWith(
            nHokenEndDay: "0000", //-> mark that it's null
          );
        }
      }

      ///api-bodyColor
      if (state.modelSelection.mColorName != null) {
        mColorName =
            state.modelSelection.mColorName ?? Constants.SELECTION_STATUS;

        var code = _listColorName
            .firstWhere((e) => e.name == state.modelSelection.mColorName)
            .nameCode;
        _ownCarRequestModel = _ownCarRequestModel.copyWith(
          bodyColor: code,
        );
      }

      ///api-nHkenInc
      if (state.modelSelection.mInsuranceCompany != null) {
        var code = _listInsuranceCompany
            .firstWhere((e) => e.name == state.modelSelection.mInsuranceCompany,
                orElse: () => _listInsuranceCompany.first)
            .nameCode;
        mInsuranceCompany = state.modelSelection.mInsuranceCompany ??
            Constants.SELECTION_STATUS;
        _ownCarRequestModel = _ownCarRequestModel.copyWith(
          nHokenInc: code,
        );
      }

      ///api-sellTime
      if (state.modelSelection.mSellTime != null) {
        var code = _listSellTime
            .firstWhere((e) => e.name == state.modelSelection.mSellTime)
            .nameCode;
        mSellTime =
            state.modelSelection.mSellTime ?? Constants.SELECTION_STATUS;
        _ownCarRequestModel = _ownCarRequestModel.copyWith(
          sellTime: code.toString(),
        );
      }

      ///api-carModel
      if (state.modelSelection.mCarModel != null) {
        DateTime now = new DateTime.now();
        int currentYear = now.year;
        //add 1 unit to remove the 0th element
        int modelYear = 1 + currentYear - (state.modelSelection.mCarModel ?? 0);
        mCarModel = modelYear <= currentYear
            ? HelperFunction.instance.getJapanYearFromAd(modelYear)
            : _listCarModelYear.first;
        _ownCarRequestModel = _ownCarRequestModel.copyWith(
          carModel: modelYear <= currentYear ? modelYear.toString() : "0000",
        );
      }
    }

    if (state is ChangeInputTextState) {
      ///api-plateNo2
      if (state.modelText.mCategoryNumber != null ||
          (state.modelText.mCategoryNumber ?? "").isNotEmpty) {
        mCategoryNumber = state.modelText.mCategoryNumber ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(plateNo2: int.parse(mCategoryNumber));
      }

      ///api-plateNo3
      if (state.modelText.mGradeHiragana != null ||
          (state.modelText.mGradeHiragana ?? "").isNotEmpty) {
        mGradeHiragana = state.modelText.mGradeHiragana ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(plateNo3: mGradeHiragana);
      }

      ///api-plateNo4
      if (state.modelText.mSpecifyNumber != null ||
          (state.modelText.mSpecifyNumber ?? "").isNotEmpty) {
        mSpecifyNumber = state.modelText.mSpecifyNumber ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(plateNo4: int.parse(mSpecifyNumber));
      }

      ///api-mileage
      if (state.modelText.mDistance != null ||
          (state.modelText.mDistance ?? "").isNotEmpty) {
        mDistance = state.modelText.mDistance ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(mileage: int.parse(mDistance));
      }

      ///api-chasisNum
      if (state.modelText.mVehicleNumber != null ||
          (state.modelText.mVehicleNumber ?? "").isNotEmpty) {
        mVehicleNumber = state.modelText.mVehicleNumber ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(platformNum: mVehicleNumber);
      }

      ///api-carGrade
      if (state.modelText.mGradeValue != null ||
          (state.modelText.mGradeValue ?? "").isNotEmpty) {
        mGradeValue = state.modelText.mGradeValue ?? "";
        _ownCarRequestModel =
            _ownCarRequestModel.copyWith(carGrade: mGradeValue);
      }
    }
  }

  Widget buttonPickupAPhoto() {
    return ShowAndPickupPhotoView(
      context: context,
      isGridViewTypeDisplay: true,
      onPhotoDeleted: (deletePhotoDataList) {
        context.read<CarRegisBloc>().deletePhotoList = deletePhotoDataList;
      },
      onPhotoSelected: (uploadPhotoDataList) {
        context.read<CarRegisBloc>().uploadPhotoList = uploadPhotoDataList;
      },
      photos: context.read<CarRegisBloc>().existingPhotoList,
    );
  }

  validateForm(Function nextAction) async {
    var errorComment = [];

    if (_ownCarRequestModel.makerCode == null) {
      errorComment.add("SELECT_A_MANUFACTURER_WARNING".tr());
    }
    if (_ownCarRequestModel.carCode == null) {
      errorComment.add("SELECT_A_MODEL_NAME".tr());
    }
    if (_ownCarRequestModel.plateNo3 != null &&
        !(RegExp(r'^[ぁ-ん]+$').hasMatch(_ownCarRequestModel.plateNo3!))) {
      errorComment.add("REGISTRATION_NUMBER_HIRAGANA".tr());
    }

    if (_ownCarRequestModel.inspectionDate != null &&
        _ownCarRequestModel.inspectionDate?.substring(0, 2) != "00") {
      // 1825 days = 5 years
      if (differenceDateTime(_ownCarRequestModel.inspectionDate!) < 0 ||
          differenceDateTime(_ownCarRequestModel.inspectionDate!) >= 1825) {
        errorComment.add("SET_THE_VEHICLE".tr());
      }
    }

    if (_ownCarRequestModel.nHokenEndDay != null) {
      var date = HelperFunction.instance.parseDateString(
          _ownCarRequestModel.nHokenEndDay ?? DateTime.now().toString());
      // 1825 days = 5 years
      if (differenceDateTime(date.toString()) < 0 ||
          differenceDateTime(date.toString()) >= 1825) {
        errorComment.add("SET_THE_INSURANCE_DATE".tr());
      }
    }

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

  int differenceDateTime(String dateTime) {
    return DateTime.parse(dateTime).difference(DateTime.now()).inDays;
  }

  buildTextViewPhoto() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getWidth(10.0)),
      child: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            label: "PLEASE_POST_PHOTO".tr(),
            textStyle: MKStyle.t10R,
          )),
    );
  }

  subTitleGuide() {
    return SubTitle(
      label: "PLEASE_PRESS_REGISTRATION_BUTTON".tr(),
      textStyle: MKStyle.t14R,
    );
  }

  Widget buildInsuranceExpirationDate() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getWidth(20.0)),
      child: RowWidgetPattern6New(
        value: mDateInsuranceExpiration.isNotEmpty
            ? mDateInsuranceExpiration
            : "PLEASE_SELECT".tr(),
        typeScreen: Constants.CAR_INFORMATION_SCREEN,
        typePattern: 7,
        btnCallBack: () async {
          var initDateTime = _ownCarRequestModel.nHokenEndDay != null &&
                  _ownCarRequestModel.nHokenEndDay!.isNotEmpty
              ? HelperFunction.instance
                  .parseDateString(_ownCarRequestModel.nHokenEndDay!)
              : DateTime.now();

          await CommonDialog.displayCupertinoDatePickerJapan(
              context, initDateTime, (newDate) {
            context.read<CarRegisBloc>().add(
                  OnChangeSelectionFieldEvent(SelectionFieldModel(
                      nHokenEndDate: DateTime.utc(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          newDate.hour,
                          newDate.minute,
                          newDate.second))),
                );
          });
        },
        isPattern7: true,
        requiredField: false,
        textStr: "INSURANCE_EXPIRATION_DATE".tr(),
      ),
    );
  }

  Widget buildInsuranceCompany() {
    var list = _listInsuranceCompany.map((e) => e.name).toList();
    return RowWidgetPattern6New(
      value: mInsuranceCompany,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          list,
          list.indexOf(mInsuranceCompany),
          (value) {
            context.read<CarRegisBloc>().add(OnChangeSelectionFieldEvent(
                SelectionFieldModel(mInsuranceCompany: value)));
          },
        );
      },
      isPattern7: true,
      requiredField: false,
      textStr: "INSURANCE_COMPANY".tr(),
    );
  }

  Widget buildCarModelYear() {
    return RowWidgetPattern6New(
      value: mCarModel,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          _listCarModelYear,
          _listCarModelYear.indexOf(mCarModel),
          (value) => {
            context.read<CarRegisBloc>().add(OnChangeSelectionFieldEvent(
                SelectionFieldModel(
                    mCarModel: _listCarModelYear.indexOf(value))))
          },
        );
      },
      isPattern7: true,
      requiredField: false,
      textStr: "MODEL_YEAR".tr(),
    );
  }

  Widget buildBodyColor() {
    var list = _listColorName.map((e) => e.name).toList();
    return RowWidgetPattern6New(
      value: mColorName,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          list,
          list.indexOf(mColorName),
          (value) => {
            context.read<CarRegisBloc>().add(
                  OnChangeSelectionFieldEvent(
                    SelectionFieldModel(
                      mColorName: value,
                    ),
                  ),
                ),
          },
        );
      },
      isPattern7: true,
      requiredField: false,
      textStr: "BODY_COLOR".tr(),
    );
  }

  Widget buildSellTime() {
    var list = _listSellTime.map((e) => e.name).toList();
    return RowWidgetPattern6New(
      value: mSellTime,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          list,
          list.indexOf(mSellTime),
          (value) => {
            context.read<CarRegisBloc>().add(OnChangeSelectionFieldEvent(
                SelectionFieldModel(mSellTime: value)))
          },
        );
      },
      isPattern7: true,
      requiredField: false,
      textStr: "SELL_TIME".tr(),
    );
  }

  Widget buildDistance() {
    return RowWidgetTextField(
        initValue: mDistance,
        maxLength: 6,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        textStr: "DISTANCE_KM".tr(),
        extraTextInputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onTextChange: (String value) {
          context.read<CarRegisBloc>().add(
              OnChangeInputTextFieldEvent(InputTextModel(mDistance: value)));
        });
  }

  Widget buildExpirationDateOfVihicle() {
    return RowWidgetPattern6New(
      value: mInsuranceExpirationDate.isNotEmpty
          ? mInsuranceExpirationDate
          : "PLEASE_SELECT".tr(),
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        final initDateTime = _ownCarRequestModel.inspectionDate != null &&
                _ownCarRequestModel.inspectionDate!.isNotEmpty
            ? DateTime.parse(_ownCarRequestModel.inspectionDate!)
            : DateTime.now();

        await CommonDialog.displayCupertinoDatePickerJapan(
            context, initDateTime, (newDate) {
          context.read<CarRegisBloc>().add(
                OnChangeSelectionFieldEvent(
                  SelectionFieldModel(inspectionDate: newDate),
                ),
              );
        });
      },
      isPattern7: true,
      requiredField: false,
      textStr: "EXPIRATION_DATE_OF_VEHICLE".tr(),
    );
  }

  Widget buildGradeWithVehicleNumber() {
    return RowWidgetTextField(
        initValue: mVehicleNumber,
        maxLength: 50,
        textStr: "CHASSIS_NUMBER".tr(),
        onTextChange: (String value) {
          context.read<CarRegisBloc>().add(OnChangeInputTextFieldEvent(
              InputTextModel(mVehicleNumber: value)));
        });
  }

  Widget buildGrade() {
    return RowWidgetTextField(
        initValue: mGradeValue,
        maxLength: 60,
        textStr: "GRADE".tr(),
        onTextChange: (String value) {
          context.read<CarRegisBloc>().add(
              OnChangeInputTextFieldEvent(InputTextModel(mGradeValue: value)));
        });
  }

  Widget buildGradeWithCategoryNumber() {
    return RowWidgetTextField(
        initValue: mCategoryNumber,
        keyboardType: TextInputType.number,
        maxLength: 3,
        extraTextInputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        textStr: "PLATE_2".tr(),
        onTextChange: (String value) {
          _ownCarRequestModel =
              _ownCarRequestModel.copyWith(plateNo2: int.parse(value));

          context.read<CarRegisBloc>().add(OnChangeInputTextFieldEvent(
              InputTextModel(mCategoryNumber: value)));
        });
  }

  Widget buildGradeWithHiragana() {
    return RowWidgetTextField(
        initValue: mGradeHiragana,
        maxLength: 1,
        textStr: "PLATE_HIRAGANA_3".tr(),
        onTextChange: (String value) {
          context.read<CarRegisBloc>().add(OnChangeInputTextFieldEvent(
              InputTextModel(mGradeHiragana: value)));
        });
  }

  Widget buildGradeWithSpecifyNumber() {
    return RowWidgetTextField(
        initValue: mSpecifyNumber,
        keyboardType: TextInputType.number,
        maxLength: 4,
        textStr: "PLATE_4".tr(),
        extraTextInputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onTextChange: (String value) {
          context.read<CarRegisBloc>().add(OnChangeInputTextFieldEvent(
                InputTextModel(mSpecifyNumber: value),
              ));
        });
  }

  Widget buildGradeWithAreaCode() {
    var list = _listRIKUJI.map((e) => e.nameCode).toList();

    return RowWidgetPattern6New(
      value: mRIKUJIModel.nameCode,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          list,
          list.indexOf(mRIKUJIModel.nameCode),
          (value) {
            value as String;
            context
                .read<CarRegisBloc>()
                .add(OnSelectRIKUJIEvent(_listRIKUJI.firstWhere(
                  (e) => e.nameCode == value,
                  orElse: () => _listRIKUJI.first,
                )));
          },
        );
      },
      isPattern7: true,
      requiredField: false,
      textStr: "PLATE_1".tr(),
    );
  }

  Widget buildCarType() {
    return RowWidgetPattern6New(
      value: mCarType,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context
              .read<CarRegisBloc>()
              .add(OpenCarTypePicker(context, loginModel, mMaker.makerCode));
        });
      },
      isPattern7: true,
      requiredField: true,
      textStr: "CAR_MODEL_NAME".tr(),
    );
  }

  Widget buildMaker() {
    return RowWidgetPattern6New(
      value: mMaker.makerName,
      typeScreen: Constants.CAR_INFORMATION_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CarRegisBloc>().add(OpenMakerCodePicker(
              context: context, loginModel: loginModel, initMakerCode: mMaker));
        });
      },
      isPattern7: true,
      requiredField: true,
      textStr: "MANUFACTURE_NAME".tr(),
    );
  }

  // BoxDecoration _buildBoxDecoration() {
  //   return BoxDecoration(
  //     gradient: LinearGradient(
  //       colors: [
  //         const Color(0xFFFDFEFF),
  //         const Color(0xFFEEF9FF),
  //       ],
  //       begin: Alignment.topCenter,
  //       end: Alignment.bottomCenter,
  //     ),
  //   );
  // }

  _buildListButtonBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: widget.userCarModel?.userCarNum != "0",
          child: InkWell(
            onTap: () {
              showConfirmDeleteOwnCar(loginModel.memberNum, loginModel.userNum,
                  int.parse(widget.userCarModel!.userCarNum ?? "0"));
            },
            child: Image.asset(
              "assets/images/png/deleteIcon.png",
              height: Dimens.getHeight(36.0),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Row(
          children: [
            ButtonWidget(
              size: Dimens.getHeight(8),
              width: MediaQuery.of(context).size.width / 2.8,
              content: "CANCEL".tr(),
              borderRadius: Dimens.getHeight(20),
              clickButtonCallBack: () async {
                // handleButton();
              },
              bgdColor: ResourceColors.color_70,
              borderColor: ResourceColors.color_70,
              textStyle:
                  MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
              heightText: 1.2,
            ),
            SizedBox(
              width: Dimens.getWidth(15.0),
            ),
            ButtonWidget(
              size: Dimens.getHeight(8),
              width: MediaQuery.of(context).size.width / 2.8,
              content: "NEW_USER_REGISTRATION_NEXT".tr(),
              borderRadius: Dimens.getHeight(20),
              clickButtonCallBack: () async {
                validateForm(() => {
                      context.read<CarRegisBloc>().add(
                            PostOwnCarEvent(
                              _ownCarRequestModel,
                            ),
                          ),
                    });
              },
              bgdColor: ResourceColors.color_FF0FA4EA,
              borderColor: ResourceColors.color_FF4BC9FD,
              textStyle:
                  MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
              heightText: 1.2,
            ),
          ],
        )
      ],
    );
  }

  showConfirmDeleteOwnCar(String memberNum, int userNum, int userCarNum) async {
    await CommonDialog.displayConfirmDialog(
      context,
      TextWidget(
        label: "CONFIRM_DELETE_VEHICLE_REGISTRATION".tr(),
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_000000),
        alignment: TextAlign.start,
      ),
      'DELETE'.tr(),
      "CANCEL".tr(),
      okEvent: () async {
        context.read<CarRegisBloc>().add(
              DeleteOwnCarEvent(
                DeleteOwnCarRequestModel(
                    userCarNum: userCarNum,
                    memberNum: memberNum,
                    userNum: userNum),
              ),
            );
      },
      cancelEvent: () {},
    );
  }
}
