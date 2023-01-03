import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/process_util.dart';
import 'package:mirukuru/core/widgets/common/button_icon_widget.dart';
import 'package:mirukuru/core/widgets/common/button_tab_widget.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/app_bloc/app_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/common.dart';
import '../../../../core/util/app_route.dart';
import '../../../../core/util/helper_function.dart';
import '../../../../core/widgets/common/divider_no_text.dart';
import '../../../login/data/models/login_model.dart';
import '../bloc/search_top_bloc.dart';

class SearchTopPage extends StatefulWidget {
  @override
  _SearchTopPageState createState() => _SearchTopPageState();
}

class _SearchTopPageState extends State<SearchTopPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  LoginModel loginModel = LoginModel();

  String telCompany = '';

  bool tabButtonFlag = false;
  bool foreignMode = false;

  late List<Map<String, String>> listDataMaker;

  late List<Map<int, String>> listDataBodyType;

  List<String> listImgKoKuSanMaker = [];
  List<String> listImgBodyType = [];
  late TabController controller;
  var isShowingCheckVersionDialog = false;

  int numberOfUnreadNotifications = 0;

  @override
  void initState() {
    listDataMaker = <Map<String, String>>[];
    listDataBodyType = <Map<int, String>>[];
    controller = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    getLoginModel();
    // set data maker
    setMakerData();
    // set data body type
    setBodyTypeData();
    // set list name image maker
    setImageMaker();
    // set list name image body type
    setImageBodyType();

    final isNameLoaded = BlocProvider.of<AppBloc>(context).isNameLoaded;
    context
        .read<SearchTopBloc>()
        .add(TopInit(context: context, isNameLoaded: isNameLoaded));
  }

  void getLoginModel() async {
    var localLoginModel = await HelperFunction.instance.getLoginModel();
    Logging.log.info(
        'Company Logo URL: ${Common.imageUrl + localLoginModel.memberNum + '/' + localLoginModel.logoMark}');
    setState(() {
      loginModel = localLoginModel;
      // telCompany = localTelCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      isHiddenLeadingPop: true,
      hasOnlyLogo: true,
      controller: controller,
      appBarLogo: loginModel.logoMark.isEmpty
          ? ''
          : '${Common.imageUrl + loginModel.memberNum + '/' + loginModel.logoMark}',
      storeName: loginModel.storeName2.isNotEmpty
          ? '${loginModel.storeName}\n${loginModel.storeName2}'
          : loginModel.storeName,
      appBarColor: ResourceColors.color_FF1979FF,
      currentIndex: Constants.TOP_INDEX,
      body: BlocListener<SearchTopBloc, SearchTopState>(
        listener: (context, searchTopState) async {
          if (searchTopState is Error) {
            await CommonDialog.displayDialog(
                context,
                searchTopState.messageCode,
                searchTopState.messageContent,
                false);
          }
          if (searchTopState is TimeOut) {
            await CommonDialog.displayDialog(
                context,
                searchTopState.messageCode,
                searchTopState.messageContent,
                false);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
          }
          if (searchTopState is CheckedUpdateVersion) {
            isShowingCheckVersionDialog = true;
          }
          if (searchTopState is LoadedGetNumberOfUnread) {
            await BaseStorage.instance.setIntValue(
                Constants.NUMBER_OF_UNREAD_NOTIFICATIONS,
                searchTopState.numberUnread);
            numberOfUnreadNotifications = searchTopState.numberUnread;
            setState(() {});
          }
        },
        child: _buildBody(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!isShowingCheckVersionDialog && mounted) {
          context.read<SearchTopBloc>().add(CheckUpdateEvent(context: context));
        }
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
    }
  }

  Widget _buildBody() {
    return BlocBuilder<SearchTopBloc, SearchTopState>(
        builder: (context, state) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      return _buildTopTabPage();
    });
  }

  Widget _buildTopTabPage() {
    return Container(
      color: ResourceColors.color_FFFFFF,
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.getHeight(8.0),
            right: Dimens.getHeight(8.0),
            top: Dimens.getHeight(10.0)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildUICompareGasPrice(),
              SizedBox(
                height: Dimens.getWidth(10.0),
              ),
              // Build Tab Button
              _buildTabsButton(),
              // Build line
              DividerNoText(
                indent: 0.0,
                endIndent: 0.0,
                thickness: 4.0,
                colorLine: ResourceColors.color_3768CE,
                heightLine: 0.0,
              ),
              tabButtonFlag ? _buildBodyTypeWidget() : _buildMakerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabsButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.getWidth(10.0)),
      child: Row(
        children: [
          _buildTabButton('SEARCH_BY_MAKER'.tr(), tabButtonFlag,
              clickButtonCallBack: () {}),
          _buildTabButton('SEARCH_BY_BODY_TYPE'.tr(), !tabButtonFlag,
              clickButtonCallBack: () {}),
        ],
      ),
    );
  }

  Widget _buildUICompareGasPrice() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: _buildBoxGasPrice(),
      child: Column(
        children: [_buildTitleGas(), _buildBodyGas()],
      ),
    );
  }

  Widget _buildBodyGas() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.getWidth(10.0),
          top: Dimens.getWidth(10.0),
          left: Dimens.getWidth(10.0)),
      child: Row(
        children: [
          Image.asset(
            'assets/images/png/gogogs_main.png',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width / 3.3,
          ),
          SizedBox(
            width: Dimens.getWidth(10.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRowGas("EASY_SEARCH_GAS".tr()),
              _buildRowGas("GASOLINE_PRICE_COMPARISON".tr()),
              _buildRowGas("ADVANTAGES_INFORMATION_EACH_STORE".tr()),
              SizedBox(
                height: Dimens.getWidth(5.0),
              ),
              InkWell(
                onTap: () async {
                  _launchGoGoWeb();
                },
                child: TextWidget(
                  label: "CLICK_HERE_FOR_DETAILS".tr(),
                  textStyle:
                      MKStyle.t9B.copyWith(color: ResourceColors.color_0075C1),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _launchGoGoWeb() async {
    Uri myUri = Uri.parse(Constants.GOGO_WEB_LINK);
    await launchUrl(myUri, mode: LaunchMode.externalApplication);
  }

  Widget _buildTitleGas() {
    return Container(
      decoration: _buildBoxDecorationTitleGas(),
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.getWidth(10.0),
            top: Dimens.getWidth(5.0),
            bottom: Dimens.getWidth(5.0)),
        child: Row(
          children: [
            TextWidget(
              label: "GASOLINE_PRICE_COMPARISON_SITE".tr(),
              textStyle:
                  MKStyle.t12B.copyWith(color: ResourceColors.color_FFFFFF),
            ),
            SizedBox(
              width: Dimens.getWidth(10.0),
            ),
            Image.asset(
              'assets/images/png/gogogs.png',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width / 5,
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecorationTitleGas() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [ResourceColors.color_3768CE, ResourceColors.color_0FA4EA],
        begin: Alignment.topRight,
        end: Alignment.topLeft,
      ),
    );
  }

  Widget _buildRowGas(String label) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/svg/dot.svg',
          fit: BoxFit.fill, //Dimens.size15,
        ),
        SizedBox(
          width: Dimens.getWidth(5.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width -
              (Dimens.getWidth(20.0) +
                  Dimens.getWidth(28.0) +
                  MediaQuery.of(context).size.width / 3.3 +
                  Dimens.getWidth(8.0)),
          child: TextWidget(
            label: label,
            textStyle: MKStyle.t10R,
          ),
        )
      ],
    );
  }

  BoxDecoration _buildBoxGasPrice() {
    return BoxDecoration(
        border: Border.all(color: ResourceColors.color_3768CE, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)));
  }

  Widget _buildTabButton(
    String contentBtn,
    bool actionFlag, {
    Function? clickButtonCallBack,
  }) {
    return Expanded(
      child: IgnorePointer(
        ignoring: !actionFlag,
        child: ButtonTabWidget(
          actionFlag: actionFlag,
          size: 0.0,
          textStyle: MKStyle.t16R.copyWith(
              color: actionFlag
                  ? ResourceColors.color_3768CE
                  : ResourceColors.color_FFFFFF),
          clickButtonCallBack: () {
            changeTabButtonFlag();
            clickButtonCallBack?.call();
          },
          content: contentBtn,
          bgdColor: actionFlag
              ? ResourceColors.color_FFFFFF
              : ResourceColors.color_3768CE,
          borderColor: actionFlag
              ? ResourceColors.color_FFFFFF
              : ResourceColors.color_3768CE,
          hasBorderRadius: false,
        ),
      ),
    );
  }

  // Build Maker Widget
  Widget _buildMakerWidget() {
    return Container(
      color: ResourceColors.color_FFFFFF,
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.getWidth(10.0), vertical: Dimens.getHeight(30.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Build Maker Image View
          _buildMakerImageView(),
          // Build button next
          _buildSeeMore(),
        ],
      ),
    );
  }

  Widget _buildSeeMore() {
    return ButtonIconWidget(
        width: MediaQuery.of(context).size.width / 3,
        sizeIconRight: DimenFont.sp10,
        colorIconRight: ResourceColors.color_000000,
        textStyle: MKStyle.t10R,
        borderRadius: 8.0,
        strImageRight: Icons.navigate_next,
        textButton: 'SEE_MORE'.tr(),
        clickButtonCallBack: (bool value) {
          Navigator.of(context).pushNamed(AppRoutes.makerListPage);
        },
        backgroundColor: ResourceColors.color_FFFFFF);
  }

  Widget _buildMakerImageView() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: Dimens.getWidth(20.0), right: Dimens.getWidth(20.0)),
      crossAxisSpacing: Dimens.getWidth(15.0),
      mainAxisSpacing: Dimens.getHeight(10.0),
      crossAxisCount: 5,
      children: List.generate(listImgKoKuSanMaker.length, (index) {
        return _buildItem(listImgKoKuSanMaker[index], clickButtonCallBack: () {
          Navigator.of(context).pushNamed(AppRoutes.carListPage, arguments: {
            'makerCode': listDataMaker[index].keys.first,
            'makerName': listDataMaker[index].values.first
          });
        });
      }),
    );
  }

  // Build Maker Image
  Widget _buildItem(String pathImage, {Function? clickButtonCallBack}) {
    return GestureDetector(
      onTap: () async {
        ProcessUtil.instance.cancelProcess();
        await clickButtonCallBack?.call();
      },
      child: Image.asset(
        pathImage,
        height: Dimens.getHeight(5.0),
      ),
    );
  }

  // To do : have not applied the API yet
  // Build Body Type Widget
  Widget _buildBodyTypeWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.getWidth(10.0), vertical: Dimens.getHeight(30.0)),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            left: Dimens.getWidth(20.0), right: Dimens.getWidth(20.0)),
        crossAxisSpacing: Dimens.getWidth(60.0),
        mainAxisSpacing: Dimens.getHeight(3.0),
        crossAxisCount: 3,
        children: List.generate(listDataBodyType.length, (index) {
          return _buildItem(
            listImgBodyType[index],
            clickButtonCallBack: () async {
              await Navigator.of(context)
                  .pushNamed(AppRoutes.bodyListPage, arguments: {
                'id': listDataBodyType[index].keys.first,
                'bodyType': listDataBodyType[index].values.first,
              });
            },
          );
        }),
      ),
    );
  }

  // func change tab button
  void changeTabButtonFlag() {
    setState(() {
      tabButtonFlag = !tabButtonFlag;
      foreignMode = false;
    });
  }

  // func change tab image
  void changeTabImageFlag() {
    setState(() {
      foreignMode = !foreignMode;
    });

    setMakerData();
  }

  // set data maker
  void setMakerData() {
    if (foreignMode) {
      listDataMaker = [
        {'052': 'BMW'},
        {'060': 'ベンツ'},
        {'058': 'フォルクスワーゲン'},
        {'054': 'アウディ'},
        {'064': 'ミニ'},
        {'061': 'ポルシェ'},
        {'082': 'プジョー'},
        {'099': 'シボレー'},
        {'056': 'オペル'},
        {'072': 'ボルボ'},
      ];
    } else {
      listDataMaker = [
        {'010': 'トヨタ'},
        {'020': 'レクサス'},
        {'011': '日産'},
        {'015': 'ホンダ'},
        {'013': 'マツダ'},
        {'017': 'スバル'},
        {'018': 'スズキ'},
        {'012': '三菱'},
        {'016': 'ダイハツ'},
        {'014': 'イスズ'},
        {'052': 'BMW'},
        {'060': 'ベンツ'},
        {'058': 'フォルクスワーゲン'},
        {'054': 'アウディ'},
        {'064': 'ミニ'},
        {'061': 'ポルシェ'},
        {'082': 'プジョー'},
        {'099': 'シボレー'},
        {'056': 'オペル'},
        {'072': 'ボルボ'},
      ];
    }
  }

  void setBodyTypeData() {
    listDataBodyType = [
      {1: '軽自動車'},
      {12: '軽バン'},
      {13: '軽トラ'},
      {4: 'セダン'},
      {7: 'クーペ・オープン'},
      {5: 'ステーションワゴン'},
      {6: 'ハッチバック'},
      {2: 'ミニバン'},
      {3: 'クロカン・SUV'},
      {9: 'ハイブリッド'},
      {8: '商用車・バン'},
      {10: 'トラック'},
    ];
  }

  void setImageMaker() {
    listImgKoKuSanMaker = [
      'assets/images/png/toyota.png',
      'assets/images/png/lexus.png',
      'assets/images/png/nissan.png',
      'assets/images/png/honda.png',
      'assets/images/png/mazda.png',
      'assets/images/png/subaru.png',
      'assets/images/png/suzuki.png',
      'assets/images/png/mitsubishi.png',
      'assets/images/png/daihatsu.png',
      'assets/images/png/isuzu.png',
      'assets/images/png/bmw.png',
      'assets/images/png/benz.png',
      'assets/images/png/volkswagen.png',
      'assets/images/png/audi.png',
      'assets/images/png/mini.png',
      'assets/images/png/porsche.png',
      'assets/images/png/peugeot_button.png',
      'assets/images/png/chevrolet_button.png',
      'assets/images/png/opel.png',
      'assets/images/png/volbo.png',
    ];
  }

  void setImageBodyType() {
    listImgBodyType = [
      'assets/images/png/light_automobile.png',
      'assets/images/png/light_pan.png',
      'assets/images/png/light_track.png',
      'assets/images/png/sedan.png',
      'assets/images/png/coupe_open.png',
      'assets/images/png/station_wagon.png',
      'assets/images/png/hichback.png',
      'assets/images/png/minivan.png',
      'assets/images/png/crokan.png',
      'assets/images/png/hybrid.png',
      'assets/images/png/merchant_pan.png',
      'assets/images/png/track.png',
    ];
  }
}
