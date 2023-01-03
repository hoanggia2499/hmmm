import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/multi_column_picker.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_13_new.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_input/data/models/search_input_model.dart';
import 'package:mirukuru/features/search_input/presentation/bloc/search_input_bloc.dart';

import '../../../../core/widgets/common/text_widget.dart';

class SearchInputPage extends StatefulWidget {
  String previousNameScreen;
  List<CarSearchHive> listDataCarName;
  SearchInputPage(
      {required this.previousNameScreen, required this.listDataCarName});

  @override
  State<SearchInputPage> createState() => _SearchInputPageState();
}

class _SearchInputPageState extends State<SearchInputPage> {
  LoginModel loginModel = LoginModel();
  List<String> bodyList = [];
  List<String> inputSearch = [];
  double sizeHeight = 50.0;

  String area = '';

  List<String> nenshikiJapanYear1 = [];
  List<String> nenshikiValue1 = [];
  String? nenshiki1;
  String? nenshiki2;
  int positionNenshikiJapanYear1 = 0;
  int positionNenshikiJapanYear2 = 0;

  List<String> priceList = [];
  List<String> priceValue = [];
  String? price1;
  String? price2;
  int positionPrice1 = 0;
  int positionPrice2 = 0;

  List<String> distanceList1 = [];
  List<String> distanceValue = [];
  String? distance1;
  String? distance2;
  int positionDistance1 = 0;
  int positionDistance2 = 0;

  List<String> shakenList = [];
  List<String> inspectionValue = [];
  String inspection = '';
  int positionShaken = 0;

  List<String> shufukuList = [];
  List<String> repairValue = [];
  String repair = '';
  int positionShufuku = 0;

  List<String> colorList = ['UNSPECIFIED'.tr()];
  String color = '';
  int positionColor = 0;

  List<String> missionList = [];
  List<String> missionValue = [];
  String mission = '';
  int positionMisstion = 0;

  List<String> haikiryouList1 = [];
  List<String> haikiryouValue = [];
  String? haikiryou1;
  String? haikiryou2;
  int positionHaikiryou1 = 0;
  int positionHaikiryou2 = 0;

  String freeWorld = '';

  int numbersOfChecked = 0;
  List<bool> initListSelectedValue = [false, false, false, false, false];
  ScrollController scroll = ScrollController();
  GlobalKey? keys;
  TextEditingController freeWorldController = TextEditingController();
  List<CarSearchHive> bodyListValueCheck = [];
  int positionArea = 0;

  @override
  void initState() {
    getData();
    getBodyListData();
    getArea();
    addNenshiki();
    addPrice();
    addDistance();
    addShaKen();
    addShufuku();
    addColor();
    addMission();
    addHaikiryou();
    keys = GlobalKey();
    super.initState();
  }

  getData() async {
    // get package info for version app
    loginModel = await HelperFunction.instance.getLoginModel();
    setState(() {});
  }

  getArea() async {
    var areaValue = await UserSecureStorage.instance.getArea() ?? '';
    if (areaValue == "" ||
        widget.previousNameScreen == Constants.CAR_LIST_PAGE) {
      area = "WHOLE_COUNTRY".tr();
      setArea();
    } else {
      area = areaValue;
    }
  }

  setArea() async {
    await UserSecureStorage.instance.setArea("");
  }

  List<String> result = [];
  getBodyListData() async {
    int i = 0;

    for (var element in widget.listDataCarName) {
      setState(() {
        bodyList.add(element.makerName! + " " + element.carGroup!);
        initListSelectedValue[i] = true;
        i++;
      });
    }
    numbersOfChecked = widget.listDataCarName.length;
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      appBarTitle: "SEARCH_INPUT_PAGE".tr(),
      appBarColor: ResourceColors.color_FF1979FF,
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      onBackAction: () async {
        for (var element in widget.listDataCarName) {
          result.add(
              '${element.makerCode}|${element.asnetCarCode}|${element.carGroup}');
        }
        Navigator.of(context).pop(result);
      },
      body: BlocListener<SearchInputBloc, SearchInputState>(
          listener: (buildContext, state) async {
            if (state is UpdateNenshikiState) {
              nenshiki1 = state.firstValue;
              nenshiki2 = state.secondValue;
              positionNenshikiJapanYear1 =
                  nenshikiValue1.indexOf(nenshiki1 ?? '0');
              positionNenshikiJapanYear2 =
                  nenshikiValue1.indexOf(nenshiki2 ?? '0');

              Navigator.pop(context);
            }

            if (state is UpdateDistanceState) {
              distance1 = state.firstValue;
              distance2 = state.secondValue;
              positionDistance1 = distanceValue.indexOf(distance1 ?? '0');
              positionDistance2 = distanceValue.indexOf(distance2 ?? '0');

              Navigator.pop(context);
            }

            if (state is UpdatePriceState) {
              price1 = state.firstValue;
              price2 = state.secondValue;
              positionPrice1 = priceValue.indexOf(price1 ?? '0');
              positionPrice2 = priceValue.indexOf(price2 ?? '0');

              Navigator.pop(context);
            }

            if (state is UpdateHaikiryouState) {
              haikiryou1 = state.firstValue;
              haikiryou2 = state.secondValue;
              positionHaikiryou1 = haikiryouValue.indexOf(haikiryou1 ?? '0');
              positionHaikiryou2 = haikiryouValue.indexOf(haikiryou2 ?? '0');

              Navigator.pop(context);
            }

            if (state is AlertState) {
              showAlert(buildContext, state.errorContent);
            }
            /*  */
          },
          child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchInputBloc, SearchInputState>(
      builder: (buildContext, state) {
        if (state is LoadedBodyListDataState) {
          bodyList = state.bodyList;
          initListSelectedValue = state.initListSelectedValue;
          numbersOfChecked = state.numbersOfChecked;
          inputSearch = state.bodyList;
        }
        return Container(
          color: ResourceColors.color_FFFFFF,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: _buildMain(),
                controller: scroll,
              ),
              Visibility(
                visible:
                    !HelperFunction.instance.isSoftKeyBoardVisible(context),
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: _buildBoxDecoration(),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildButtonSearch(),
                      ),
                    )
                  ],
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMain() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSubTitle("SELECT_CAR".tr()),
          // Build Selected cars list
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimens.getWidth(6.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWidgetPattern12(
                    listData: bodyList,
                    initListSelectedValue: initListSelectedValue,
                    callBackNumbersOfChecked:
                        (numbersOfCheckedValue, listSelectedValue) {
                      numbersOfChecked = numbersOfCheckedValue;
                      initListSelectedValue = listSelectedValue;
                      Logging.log.info(initListSelectedValue);
                    }),
              ],
            ),
          ),
          // Build condition about car status
          _buildSubTitle("SITUATION".tr()),
          Container(
            child: Column(
              children: [
                buildNenshi(),
                buildDistance(),
                buildShaken(),
                buildShufuku(),
                buildArea(),
                buildPrice(),
              ],
            ),
          ),
          // Buid condition about basic info
          _buildSubTitle("BASIC_SPECIFICATIONS".tr()),
          Container(
            child: Column(
              children: [
                _buildEngine(),
                _buildMisstion(),
                _buildInterioColor(),
                // _buildDoor(),
                //  _buildHandle(),
                //  _buildFuel(),
                //   _buildAirCondition(),
              ],
            ),
          ),
          // _buildSubTitle("装備".tr()),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Column(
          //     children: [
          //       EquipmentWidget(),
          //     ],
          //   ),
          // ),
          _buildSubTitle("FREE_WORLD".tr()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildInput(freeWorldController, isTypeNumber: false),
                SizedBox(
                  //key: keys,
                  height: Dimens.getHeight(100.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSubTitle(String title) {
    return SubTitle(
      label: title,
      textStyle: MKStyle.t14R.copyWith(
        color: ResourceColors.color_333333,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _buildButtonSearch() {
    return Visibility(
        visible: true,
        child: Center(
          child: ButtonWidget(
            size: Dimens.getHeight(8),
            width: MediaQuery.of(context).size.width / 3,
            content: "SEARCH".tr(),
            borderRadius: Dimens.getHeight(20),
            clickButtonCallBack: () async {
              handleButton();
            },
            bgdColor: ResourceColors.color_FF0FA4EA,
            borderColor: ResourceColors.color_FF4BC9FD,
            textStyle:
                MKStyle.t14R.copyWith(color: ResourceColors.color_FFFFFF),
            heightText: 1.2,
          ),
        ));
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

  handleButton() {
    if (numbersOfChecked == 0) {
      CommonDialog.displayDialog(context, "5MA016CE", "5MA016CE".tr(), false);
    } else {
      // Save Data and Move to SearchListActivity

      List<int> indexCheck = [];
      var resultCheck = initListSelectedValue.asMap();
      for (var item in resultCheck.entries) {
        if (item.value == true) {
          Logging.log.info(item.key);
          indexCheck.add(item.key);
        }
      }
      List<CarSearchHive> listData = [];
      for (var i in indexCheck) {
        listData.add(widget.listDataCarName[i]);
      }
      SearchInputModel searchListModel = SearchInputModel(
        checkBox1Checked: initListSelectedValue[0],
        checkBox2Checked: initListSelectedValue[1],
        checkBox3Checked: initListSelectedValue[2],
        checkBox4Checked: initListSelectedValue[3],
        checkBox5Checked: initListSelectedValue[4],
        color: color == 'UNSPECIFIED'.tr() ? '' : color,
        distance1: distance1,
        distance2: distance2,
        haikiryou1: haikiryou1,
        haikiryou2: haikiryou2,
        freeword: freeWorldController.text,
        inspection: inspection,
        mission: mission,
        nenshiki1: nenshiki1,
        nenshiki2: nenshiki2,
        price1: price1,
        price2: price2,
        repair: repair,
        area: area,
        makerCode1: listData.length > 0 ? listData[0].makerCode : '',
        makerCode2: listData.length > 1 ? listData[1].makerCode : '',
        makerCode3: listData.length > 2 ? listData[2].makerCode : '',
        makerCode4: listData.length > 3 ? listData[3].makerCode : '',
        makerCode5: listData.length > 4 ? listData[4].makerCode : '',
        carName1: listData.length > 0 ? listData[0].carGroup : '',
        carName2: listData.length > 1 ? listData[1].carGroup : '',
        carName3: listData.length > 2 ? listData[2].carGroup : '',
        carName4: listData.length > 3 ? listData[3].carGroup : '',
        carName5: listData.length > 4 ? listData[4].carGroup : '',
      );
      // Move to SearchInputActivity
      Navigator.of(context).pushNamed(AppRoutes.searchListPage,
          arguments: {"searchListModel": searchListModel, "type": 0});
    }
  }

  Widget buildNenshi() {
    return RowWidgetPattern13New(
      firstValue: nenshikiJapanYear1[positionNenshikiJapanYear1],
      secondValue: nenshikiJapanYear1[positionNenshikiJapanYear2],
      textStr: "MODEL_YEAR".tr(),
      btnCallBack: () async {
        await CommonDialog.displayMultiColumnPicker(
          context,
          [
            ColumnPickerData(
                data: nenshikiJapanYear1,
                initIndex: positionNenshikiJapanYear1),
            ColumnPickerData(
                data: nenshikiJapanYear1,
                initIndex: positionNenshikiJapanYear2),
          ],
          (value) async {
            context.read<SearchInputBloc>().add(
                  UpdateValueEvent(
                    type: TypeUpdate.NENSHIKI,
                    firstValue: nenshikiValue1[nenshikiJapanYear1
                        .indexOf(value.getSelectedItemAtColumn(0))],
                    secondValue: nenshikiValue1[nenshikiJapanYear1
                        .indexOf(value.getSelectedItemAtColumn(1))],
                  ),
                );
          },
          //検索条件に一致しない値を取得しないようにする
          needValidate: true,
        );
      },
    );
  }

  showAlert(BuildContext context, String title) async {
    await CommonDialog.displayConfirmOneButtonDialog(
      context,
      TextWidget(
        label: title,
        textStyle: MKStyle.t14R,
        alignment: TextAlign.start,
      ),
      'OK',
      "OK".tr(),
      okEvent: () async {},
      cancelEvent: () {},
    );
  }

  Widget buildDistance() {
    return RowWidgetPattern13New(
      firstValue: distanceList1[positionDistance1],
      secondValue: distanceList1[positionDistance2],
      textStr: "DISTANCE".tr(),
      btnCallBack: () async {
        await CommonDialog.displayMultiColumnPicker(
          context,
          [
            ColumnPickerData(data: distanceList1, initIndex: positionDistance1),
            ColumnPickerData(data: distanceList1, initIndex: positionDistance2),
          ],
          (value) {
            context.read<SearchInputBloc>().add(
                  UpdateValueEvent(
                    type: TypeUpdate.DISTANCE,
                    firstValue: distanceValue[distanceList1
                        .indexOf(value.getSelectedItemAtColumn(0))],
                    secondValue: distanceValue[distanceList1
                        .indexOf(value.getSelectedItemAtColumn(1))],
                  ),
                );
          },
          //検索条件に一致しない値を取得しないようにする
          needValidate: true,
        );
      },
    );
  }

  _buildEngine() {
    return RowWidgetPattern13New(
      firstValue: haikiryouList1[positionHaikiryou1],
      secondValue: haikiryouList1[positionHaikiryou2],
      textStr: "ENGINE_DISPLACEMENT".tr(),
      btnCallBack: () async {
        await CommonDialog.displayMultiColumnPicker(
          context,
          [
            ColumnPickerData(
                data: haikiryouList1, initIndex: positionHaikiryou1),
            ColumnPickerData(
                data: haikiryouList1, initIndex: positionHaikiryou2),
          ],
          (value) {
            context.read<SearchInputBloc>().add(
                  UpdateValueEvent(
                    type: TypeUpdate.HAIKIRYOU,
                    firstValue: haikiryouValue[haikiryouList1
                        .indexOf(value.getSelectedItemAtColumn(0))],
                    secondValue: haikiryouValue[haikiryouList1
                        .indexOf(value.getSelectedItemAtColumn(1))],
                  ),
                );
          },
          needValidate: true,
        );
      },
    );
  }

  Widget buildShaken() {
    return RowWidgetPattern6New(
      value: shakenList[positionShaken],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context, shakenList, positionShaken, (value) {
          positionShaken = shakenList.indexOf(value);
          inspection = inspectionValue[positionShaken];
          setState(() {});
        });
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "CAR_INSPECTION".tr(),
    );
  }

  Widget buildShufuku() {
    return RowWidgetPattern6New(
      value: shufukuList[positionShufuku],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context, shufukuList, positionShufuku, (value) {
          positionShufuku = shufukuList.indexOf(value as String);
          repair = repairValue[positionShufuku];
          setState(() {});
        });
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "REPAIR_HISTORY".tr(),
    );
  }

  buildPrice() {
    return RowWidgetPattern13New(
      firstValue: priceList[positionPrice1],
      secondValue: priceList[positionPrice2],
      textStr: "PRICE".tr(),
      btnCallBack: () async {
        await CommonDialog.displayMultiColumnPicker(
          context,
          [
            ColumnPickerData(data: priceList, initIndex: positionPrice1),
            ColumnPickerData(data: priceList, initIndex: positionPrice2),
          ],
          (value) {
            context.read<SearchInputBloc>().add(
                  UpdateValueEvent(
                    type: TypeUpdate.PRICE,
                    firstValue: priceValue[
                        priceList.indexOf(value.getSelectedItemAtColumn(0))],
                    secondValue: priceValue[
                        priceList.indexOf(value.getSelectedItemAtColumn(1))],
                  ),
                );
          },
          needValidate: true,
        );
      },
    );
  }

  Widget buildArea() {
    return RowWidgetPattern20(
      textStr: "AREA".tr(),
      content: area,
      rowCallBack: () {
        Logging.log.info('[SearchInputPage] Tapped on Area button');
        CommonDialog.displayAreaDialog(
            context,
            (value) => {
                  setState(() {
                    var areaReplace = value
                        .replaceAll("東北,", "")
                        .replaceAll("関東,", "")
                        .replaceAll("甲信越・北陸,", "")
                        .replaceAll("東海,", "")
                        .replaceAll("関西,", "")
                        .replaceAll("中国,", "")
                        .replaceAll("四国,", "")
                        .replaceAll("九州,", "");
                    area = areaReplace;
                  })
                });
      },
    );
  }

  _buildMisstion() {
    return RowWidgetPattern6New(
      value: missionList[positionMisstion],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context, missionList, positionMisstion, (value) {
          positionMisstion = missionList.indexOf(value as String);
          mission = missionValue[positionMisstion];
          setState(() {});
        });
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "MISSTION".tr(),
    );
  }

  _buildInterioColor() {
    return RowWidgetPattern6New(
      value: colorList[positionColor],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context, colorList, positionColor, (value) {
          color = value as String;
          positionColor = colorList.indexOf(value);
          setState(() {});
        });
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "INTERIO_COLOR".tr(),
    );
  }

  /*  _buildDoor() {
    return RowWidgetPattern6New(
      value: shufukuList[positionShufuku],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          shufukuList,
          positionShufuku,
          (value) => {
            repair = value as String,
            positionShufuku = shufukuList.indexOf(value),
            setState(() {}),
          },
        );
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "DOOR".tr(),
    );
  } */

  /*  _buildHandle() {
    return RowWidgetPattern6New(
      value: shufukuList[positionShufuku],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          shufukuList,
          positionShufuku,
          (value) => {
            repair = value as String,
            positionShufuku = shufukuList.indexOf(repair),
            setState(() {}),
          },
        );
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "HANDLE".tr(),
    );
  }
 */
  /*  _buildFuel() {
    return RowWidgetPattern6New(
      value: shufukuList[positionShufuku],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
          context,
          shufukuList,
          positionShufuku,
          (value) => {
            repair = value as String,
            positionShufuku = shufukuList.indexOf(value),
            setState(() {}),
          },
        );
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "FUEL".tr(),
    );
  } */

/*   _buildAirCondition() {
    return RowWidgetPattern6New(
      value: shufukuList[positionShufuku],
      typePattern: 7,
      btnCallBack: () async {
        await CommonDialog.displaySingleColumnPicker(
            context, shufukuList, positionShufuku, (value) {
          repair = value as String;
          positionShufuku = shufukuList.indexOf(repair);
          setState(() {});
        });
      },
      isPattern7: true,
      textBtn: shakenList[positionShaken],
      requiredField: false,
      textStr: "AIR_CONDITION".tr(),
    );
  }
 */
  Widget _buildInput(TextEditingController inputValue,
      {String hintInput = '',
      int? maxLength,
      bool isTypeNumber = true,
      bool obscureText = false}) {
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: isTypeNumber ? TextInputType.number : TextInputType.text,
      maxLength: maxLength,
      obscureText: obscureText,
      style: MKStyle.t14R,
      decoration: InputDecoration(
          suffixIconConstraints: BoxConstraints(minHeight: 30, minWidth: 30),
          suffixIcon: Icon(
            Icons.search,
            color: ResourceColors.color_70,
            size: Dimens.getHeight(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
                BorderSide(width: 1, color: ResourceColors.color_929292),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
                BorderSide(width: 1, color: ResourceColors.color_929292),
          ),
          hintText: hintInput,
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          hintStyle: _buildHintTextStyle(),
          counterText: ''),
      onChanged: (value) {
        Logging.log.info('Input: $value');
      },
      controller: inputValue,
    );
  }

  TextStyle _buildHintTextStyle() {
    return MKStyle.t14R.copyWith(color: ResourceColors.text_grey);
  }

  addNenshiki() {
    DateTime now = new DateTime.now();
    int currentYear = now.year;
    nenshikiJapanYear1.clear();
    nenshikiJapanYear1.add('UNSPECIFIED'.tr());

    nenshikiValue1.clear();
    nenshikiValue1.add('');

    while (nenshikiJapanYear1.length < 50) {
      nenshikiJapanYear1.add(getJapanYearFromAd(currentYear));
      nenshikiValue1.add(currentYear.toString());
      currentYear--;
    }
  }

  addPrice() {
    priceList.clear();
    priceList.add('UNSPECIFIED'.tr());

    priceValue.add('');

    priceList.add("30万");
    priceList.add("40万");
    priceList.add("50万");
    priceList.add("60万");
    priceList.add("70万");
    priceList.add("80万");
    priceList.add("90万");
    priceList.add("100万");
    priceList.add("120万");
    priceList.add("140万");
    priceList.add("160万");
    priceList.add("180万");
    priceList.add("200万");
    priceList.add("250万");
    priceList.add("300万");
    priceList.add("350万");
    priceList.add("400万");

    priceValue.add((30 * 10000).toString());
    priceValue.add((40 * 10000).toString());
    priceValue.add((50 * 10000).toString());
    priceValue.add((60 * 10000).toString());
    priceValue.add((70 * 10000).toString());
    priceValue.add((80 * 10000).toString());
    priceValue.add((90 * 10000).toString());
    priceValue.add((100 * 10000).toString());
    priceValue.add((120 * 10000).toString());
    priceValue.add((140 * 10000).toString());
    priceValue.add((160 * 10000).toString());
    priceValue.add((180 * 10000).toString());
    priceValue.add((200 * 10000).toString());
    priceValue.add((250 * 10000).toString());
    priceValue.add((300 * 10000).toString());
    priceValue.add((350 * 10000).toString());
    priceValue.add((400 * 10000).toString());
  }

  addDistance() {
    distanceList1.clear();
    distanceList1.add('UNSPECIFIED'.tr());

    distanceValue.add('');

    distanceList1.add("1,000km");
    distanceList1.add("5,000km");
    distanceList1.add("10,000km");
    distanceList1.add("20,000km");
    distanceList1.add("30,000km");
    distanceList1.add("50,000km");
    distanceList1.add("70,000km");
    distanceList1.add("100,000km");

    distanceValue.add("1");
    distanceValue.add("5");
    distanceValue.add("10");
    distanceValue.add("20");
    distanceValue.add("30");
    distanceValue.add("50");
    distanceValue.add("70");
    distanceValue.add("100");
  }

  addShaKen() {
    shakenList.clear();
    shakenList.add('UNSPECIFIED'.tr());
    inspectionValue.clear();
    inspectionValue.add('');

    shakenList.add("CAN_BE".tr());
    shakenList.add("1年以上");

    inspectionValue.add('1');
    inspectionValue.add('2');
  }

  addShufuku() {
    shufukuList.clear();
    shufukuList.add('UNSPECIFIED'.tr());
    repairValue.clear();
    repairValue.add('');

    shufukuList.add("NONE".tr());
    shufukuList.add("CAN_BE".tr());

    repairValue.add('1');
    repairValue.add('2');
  }

  addColor() async {
    var listNameBean = await context
        .read<SearchInputBloc>()
        .onGetNameBeanFavorite(Constants.NAME_BEAN_TABLE);

    //colorList.clear();
    //colorList.add('指定なし');

    listNameBean.forEach((element) {
      if (element.nameKbn == 7) {
        colorList.add(element.name!);
      }
    });
  }

  addMission() {
    missionList.clear();
    missionList.add('UNSPECIFIED'.tr());
    missionValue.clear();
    missionValue.add('');

    missionList.add("ＡＴ");
    missionList.add("ＭＴ");

    missionValue.add("1");
    missionValue.add("2");
  }

  addHaikiryou() {
    haikiryouList1.clear();
    haikiryouList1.add('UNSPECIFIED'.tr());

    haikiryouValue.add('');

    haikiryouList1.add("660cc");
    haikiryouList1.add("1000cc");
    haikiryouList1.add("1300cc");
    haikiryouList1.add("1500cc");
    haikiryouList1.add("1800cc");
    haikiryouList1.add("2000cc");
    haikiryouList1.add("2500cc");
    haikiryouList1.add("3000cc");
    haikiryouList1.add("3500cc");
    haikiryouList1.add("4000cc");
    haikiryouList1.add("4500cc");

    haikiryouValue.add("660");
    haikiryouValue.add("1000");
    haikiryouValue.add("1300");
    haikiryouValue.add("1500");
    haikiryouValue.add("1800");
    haikiryouValue.add("2000");
    haikiryouValue.add("2500");
    haikiryouValue.add("3000");
    haikiryouValue.add("3500");
    haikiryouValue.add("4000");
    haikiryouValue.add("4500");
  }

  String getJapanYearFromAd(int adYear) {
    if (adYear > 2018) {
      //令和の場合
      return "R" + (adYear - 2018).toString() + "YEAR".tr();
    } else if (adYear > 1988) {
      //平成の場合
      return "H" + (adYear - 1988).toString() + "YEAR".tr();
    } else if (adYear > 1925) {
      //昭和の場合
      return "S" + (adYear - 1925).toString() + "YEAR".tr();
    } else {
      return "";
    }
  }
}
