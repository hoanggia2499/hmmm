import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_text_field.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_input_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_bloc.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_event.dart';
import 'package:mirukuru/features/my_page/presentation/pages/utils/zip_code_input_formatter.dart';

import '../bloc/my_page_state.dart';

class MyPagePage extends StatefulWidget {
  const MyPagePage({Key? key}) : super(key: key);

  @override
  State<MyPagePage> createState() => _MyPagePageState();
}

class _MyPagePageState extends State<MyPagePage> {
  LoginModel _loginModel = LoginModel();

  List<UserCarModel> userCarList = [];
  int selectedCarIndex = 0;

  /// Current MyPage Information
  MyPageModel myPageModel = MyPageModel();

  /// Current Input Model
  MyPageInputModel myPageInputModel = MyPageInputModel();

  bool initFirstTime = true;

  @override
  void initState() {
    loadMyPageModelData();
    getData();
    super.initState();
  }

  void loadMyPageModelData() async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    var requestModel = MyPageRequestModel(
      memberNum: memberNum,
      userNum: int.tryParse(userNum) != null ? int.parse(userNum) : -1,
    );

    context.read<MyPageBloc>().add(LoadMyPageInformationEvent(requestModel));
  }

  void getData() async {
    _loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: _buildAppBarLogo(_loginModel),
      appBarTitle: "MY_PAGE".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      storeName: _loginModel.storeName2.isNotEmpty
          ? '${_loginModel.storeName}\n${_loginModel.storeName2}'
          : _loginModel.storeName,
      resizeToAvoidBottomInset: true,
      buttonBottom: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _buildSellButton(),
        ),
      ),
      body: BlocListener<MyPageBloc, MyPageState>(
          listener: (context, state) async {
            if (state is Error) {
              await CommonDialog.displayDialog(
                  context, state.errorModel.msgCode, eventCallBack: () {
                if (state.errorModel.msgCode == '5MA015SE') {
                  Navigator.pop(context);
                }
              }, state.errorModel.msgContent, false);
            }

            if (state is TimeOut) {
              await CommonDialog.displayDialog(
                context,
                state.errorModel.msgCode,
                state.errorModel.msgContent,
                false,
              );

              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage, (route) => false);
            }

            if (state is MyPageInfoUpdated) {
              Navigator.of(context).pushNamed(AppRoutes.sellCarPage,
                  arguments: {"userCarModel": userCarList[selectedCarIndex]});
            }

            if (state is MyPageInfoLoaded) {
              if (state.myPageModel != null && initFirstTime) {
                myPageInputModel = state.myPageModel!;
                userCarList = myPageInputModel.userCarList;
                initFirstTime = false;
              }
            }
            if (EasyLoading.isShow) {
              EasyLoading.dismiss();
            }

            if (state is Loading) {
              EasyLoading.show();
            }
          },
          child: _buildBody()),
    );
  }

  String _buildAppBarLogo(LoginModel loginModel) => loginModel.logoMark.isEmpty
      ? ''
      : '${Common.imageUrl + _loginModel.memberNum + '/' + _loginModel.logoMark}';

  Widget _buildBody() {
    return BlocBuilder<MyPageBloc, MyPageState>(
      builder: (context, state) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        if (state is Loading) {
          EasyLoading.show();
        }

        return Container(
          color: ResourceColors.color_FFFFFF,
          child: _buildMain(),
        );
      },
    );
  }

  Widget _buildMain() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.getWidth(10.0),
        right: Dimens.getWidth(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSubtitle("USER_INFORMATION".tr()),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                _buildNameInput(),
                _buildFuriganaInput(),
                _buildEmailInput(),
                _buildZipCodeInput(),
                _buildAddress1Input(),
                _buildAddress2Input(),
                _buildBirthDayDatePicker(),
                _buildGenderSelect(),
                _buildFamilySelect(),
                _buildJobCodeSelect(),
                _buildBudgetSelect(),
                _buildUserCarListSelect(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellButton() => ButtonWidget(
      content: "SELL_A_CAR".tr(),
      bgdColor: ResourceColors.color_3768CE,
      borderRadius: Dimens.getWidth(20.0),
      width: MediaQuery.of(context).size.width / 2.2,
      textStyle: MKStyle.t14R.copyWith(
        color: ResourceColors.color_white,
        fontWeight: FontWeight.w400,
      ),
      heightText: 1.2,
      clickButtonCallBack: () async {
        validateForm(() => {
              context.read<MyPageBloc>().add(SaveMyPageInformationEvent(
                  myPageInputModel.toUpdatePayload()))
            });
      });

  Widget _buildSubtitle(String subTitle) {
    return SubTitle(
      label: subTitle,
      textStyle: MKStyle.t14R.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNameInput() => RowWidgetTextField(
      initValue: myPageInputModel.username,
      textStr: "INPUT_NAME".tr(),
      requiredField: true,
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(username: value);
        });
      });

  Widget _buildFuriganaInput() => RowWidgetTextField(
      initValue: myPageInputModel.usernameKana,
      requiredField: true,
      textStr: "INPUT_NAME_KANA".tr(),
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(usernameKana: value);
        });
      });

  Widget _buildEmailInput() => RowWidgetTextField(
      initValue: myPageInputModel.email,
      textStr: "EMAIL_ADDRESS".tr(),
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(email: value);
        });
      });

  Widget _buildZipCodeInput() => RowWidgetTextField(
      initValue: myPageInputModel.zipCode.trim(),
      textStr: "POST_CODE".tr(),
      extraTextInputFormatters: [ZipCodeInputFormatter()],
      keyboardType: TextInputType.number,
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(zipCode: value);
        });
      });

  Widget _buildAddress1Input() => RowWidgetTextField(
      initValue: myPageInputModel.address1,
      textStr: "ADDRESS_1".tr(),
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(address1: value);
        });
      });

  Widget _buildAddress2Input() => RowWidgetTextField(
      initValue: myPageInputModel.address2,
      textStr: "ADDRESS_2".tr(),
      onTextChange: (String value) {
        setState(() {
          myPageInputModel = myPageInputModel.copyWith(address2: value);
        });
      });

  Widget _buildBirthDayDatePicker() {
    String firstValue = myPageInputModel.birthday != null
        ? "${myPageInputModel.birthday?.year}${'YEAR'.tr()}${myPageInputModel.birthday?.month}${'MONTH'.tr()}${myPageInputModel.birthday?.day}${'DAY'.tr()}"
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "DOB".tr(),
      value: firstValue,
      typeScreen: Constants.MY_PAGE_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displayCupertinoDatePicker(
            context,
            myPageInputModel.birthday != null
                ? myPageInputModel.birthday!
                : DateTime.now(), (newDate) {
          setState(() {
            myPageInputModel = myPageInputModel.copyWith(birthday: newDate);
            Logging.log.info("selected Date: ${myPageInputModel.birthday}");
          });
        });
      },
    );
  }

  Widget _buildGenderSelect() {
    String firstValue = myPageInputModel.gender != -1
        ? MyPageValues.genderValues[myPageInputModel.gender]
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "GENDER".tr(),
      typeScreen: Constants.MY_PAGE_SCREEN,
      value: firstValue,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context,
            MyPageValues.genderValues,
            MyPageValues.genderValues.indexOf(firstValue), (value) {
          String selectedGender = value;
          Logging.log.info("selectedGender: $selectedGender");
          setState(() {
            myPageInputModel = myPageInputModel.copyWith(
                gender: MyPageValues.genderValues.indexOf(selectedGender));
          });
        });
      },
    );
  }

  Widget _buildFamilySelect() {
    String firstValue = myPageInputModel.family > 0
        ? MyPageValues.familyValues[myPageInputModel.family - 1]
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "FAMILY_STRUCTURE".tr(),
      typeScreen: Constants.MY_PAGE_SCREEN,
      value: firstValue,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context,
            MyPageValues.familyValues,
            MyPageValues.familyValues.indexOf(firstValue), (value) {
          String selectedFamilyStructure = value;
          Logging.log.info("selectedFamilyStructure: $selectedFamilyStructure");
          setState(() {
            myPageInputModel = myPageInputModel.copyWith(
                family:
                    MyPageValues.familyValues.indexOf(selectedFamilyStructure) +
                        1);
          });
        });
      },
    );
  }

  Widget _buildJobCodeSelect() {
    String firstValue = myPageInputModel.jobCode != -1
        ? MyPageValues.jobCodeValues[myPageInputModel.jobCode]
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "JOB_CODE".tr(),
      // firstValue: genderList
      //     .firstWhere((element) => element == _myPageInputModel.gender),
      value: firstValue,
      typeScreen: Constants.MY_PAGE_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context,
            MyPageValues.jobCodeValues,
            MyPageValues.jobCodeValues.indexOf(firstValue), (value) {
          String selectedOccupationalClassification = value;
          Logging.log.info(
              "selectedOccupationalClassification: $selectedOccupationalClassification");
          setState(() {
            myPageInputModel = myPageInputModel.copyWith(
                jobCode: MyPageValues.jobCodeValues
                    .indexOf(selectedOccupationalClassification));
          });
        });
      },
    );
  }

  Widget _buildBudgetSelect() {
    String firstValue = myPageInputModel.budget >= 0
        ? MyPageValues.budgetValues[
            myPageInputModel.budget >= MyPageValues.budgetValues.length
                ? MyPageValues.budgetValues.length - 1
                : myPageInputModel.budget]
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "BUDGET".tr(),
      value: firstValue,
      typeScreen: Constants.MY_PAGE_SCREEN,
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          MyPageValues.budgetValues,
          MyPageValues.budgetValues.indexOf(firstValue),
          (value) {
            String selectedCarPurchaseBudget = value;
            Logging.log.info(
                "selectedCarPurchaseBudgetSelect: $selectedCarPurchaseBudget");

            setState(() {
              myPageInputModel = myPageInputModel.copyWith(
                  budget: MyPageValues.budgetValues
                      .indexOf(selectedCarPurchaseBudget));
            });
          },
        );
      },
    );
  }

  Widget _buildUserCarListSelect() {
    String firstValue = userCarList.isNotEmpty
        ? userCarList[selectedCarIndex]
                .userCarNameModel
                ?.displayUserCarName() ??
            ""
        : Constants.SELECTION_STATUS;

    return RowWidgetPattern6New(
      textStr: "OWNED_CAR".tr(),
      value: firstValue,
      typePattern: 7,
      typeScreen: Constants.MY_PAGE_SCREEN,
      btnCallBack: () async {
        // Navigate to CarOwnerShipSettingsScreen
        var arguments = Map<String, dynamic>();
        arguments.putIfAbsent("userCarList", () => userCarList);
        arguments.putIfAbsent("selectedIndex", () => selectedCarIndex);

        final result = await Navigator.of(context).pushNamed(
            AppRoutes.myPagePage_CarOwnershipSettingsScreen,
            arguments: arguments);

        if (!mounted) return;

        if (result != null) {
          result as Map<String, dynamic>;
          if (result['userCarList'] != null) {
            userCarList.clear();
            userCarList = result['userCarList'];
          }

          selectedCarIndex = result['selectedIndex'];
        }
        setState(() {});
      },
    );
  }

  void validateForm(Function nextAction) async {
    var errorComment = [];

    if (myPageInputModel.username.isEmpty) {
      errorComment.add("PLEASE_ENTER_YOUR_NAME".tr());
    }

    if (userCarList.isEmpty) {
      errorComment.add("PLEASE_SELECT_A_CAR".tr());
    }

    if (myPageInputModel.usernameKana.isEmpty) {
      errorComment.add("PLEASE_ENTER_FURIGANA".tr());
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
}
