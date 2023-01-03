import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/process_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';

import '../../../features/search_top/presentation/widget/tab_controller_widget.dart';

class TemplatePage extends StatefulWidget {
  TemplatePage({
    required this.body,
    this.controller,
    this.hasMenuBar = true,
    this.hiddenBottomBar = false,
    this.routeName,
    this.backCallBack,
    this.appBarColor = Colors.lightBlue,
    this.bottomBarColor,
    this.hasAppBar = true,
    this.appBarLogo = '',
    this.appBarTitle = '',
    this.storeName = '',
    int? currentIndex,
    this.isHiddenLeadingPop = false,
    this.hasOnlyLogo = false,
    this.resizeToAvoidBottomInset,
    this.onBackAction,
    this.buttonBottom,
  }) : this.currentIndex = currentIndex ??
            BaseStorage.instance.getIntValue(Constants.CURRENT_TAB_INDEX);

  final Widget body;
  final bool hasMenuBar;
  final bool hiddenBottomBar;
  final String? routeName;
  final Color appBarColor;
  final Color? bottomBarColor;
  final bool hasAppBar;
  final String appBarLogo;
  final VoidCallback? backCallBack;
  final TabController? controller;
  final bool isHiddenLeadingPop;
  final bool hasOnlyLogo;
  final String appBarTitle;
  final int currentIndex;
  final String storeName;
  final bool? resizeToAvoidBottomInset;
  final Function()? onBackAction;
  final Widget? buttonBottom;

  @override
  TemplatePageState createState() => TemplatePageState();
}

class TemplatePageState extends State<TemplatePage> {
  String telCompany = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            color: Color(0xFFEEF9FF),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: ResourceColors.color_white,
                appBar: _buildAppBar(),
                bottomNavigationBar:
                    widget.hiddenBottomBar ? null : _buildBottomNavigationBar(),
                body: widget.body,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, Dimens.getHeight(98.0)),
      child: Container(
        height: double.maxFinite,
        decoration: _buildBoxDecoration(),
        child: Padding(
          padding: EdgeInsets.only(
              top: Dimens.getHeight(10.0),
              left: Dimens.getHeight(10.0),
              right: Dimens.getHeight(10.0)),
          child: Stack(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.backCallBack != null) {
                      widget.backCallBack!.call();
                    } else {
                      handleBack();
                    }
                  },
                  child: SvgPicture.asset(
                    width: MediaQuery.of(context).size.width / 6,
                    'assets/images/svg/mirulogo.svg',
                    fit: BoxFit.fill, //Dimens.size15,
                  ),
                ),
              ),
              // Back arrow and screen title
              // Back button
              Padding(
                padding: EdgeInsets.only(bottom: Dimens.getHeight(15.0)),
                child: Visibility(
                  visible: widget.isHiddenLeadingPop ? false : true,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: _buildBackButton(widget.onBackAction),
                  ),
                ),
              ),
              // Screen Title
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  widget.appBarLogo.isNotEmpty
                      ? _buildLogoMark()
                      : _buildStoreName(),
                  Visibility(
                      visible:
                          !(widget.isHiddenLeadingPop && widget.hasOnlyLogo),
                      child: SizedBox(
                        height: Dimens.getHeight(5),
                      )),
                  Visibility(
                    visible: !(widget.isHiddenLeadingPop && widget.hasOnlyLogo),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextWidget(
                        label: widget.appBarTitle,
                        textStyle: MKStyle.t16R
                            .copyWith(color: ResourceColors.color_0058A6),
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: widget.hasMenuBar,
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      print('Menu tapped');
                      await CommonDialog.displayMenuDialog(context);
                    },
                    child: SvgPicture.asset(
                      width: MediaQuery.of(context).size.width / 14,
                      'assets/images/svg/menu.svg',
                      fit: BoxFit.fill, //Dimens.size15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreName() {
    return Align(
      alignment: Alignment.center,
      child: TextWidget(
        label: widget.storeName,
        textStyle: widget.storeName.contains(RegExp(r'\n')) &&
                !(widget.isHiddenLeadingPop && widget.hasOnlyLogo)
            ? MKStyle.t12R.copyWith(color: ResourceColors.color_0058A6)
            : MKStyle.t18R.copyWith(color: ResourceColors.color_0058A6),
        alignment: TextAlign.center,
      ),
    );
  }

  Widget _buildLogoMark() {
    return Row(
      children: [
        Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
          flex: widget.isHiddenLeadingPop && widget.hasOnlyLogo ? 3 : 2,
          child: Container(
            padding: EdgeInsets.only(top: Dimens.getHeight(5.0)),
            child: Image.network(widget.appBarLogo,
                fit: BoxFit.contain,
                height: Dimens.getHeight(
                    widget.isHiddenLeadingPop && widget.hasOnlyLogo ? 80 : 50),
                errorBuilder: (context, object, stack) {
              Logging.log.info(stack);
              return TextWidget(
                label: widget.storeName,
                textStyle: widget.storeName.contains(RegExp(r'\n'))
                    ? MKStyle.t12R.copyWith(color: ResourceColors.color_0058A6)
                    : MKStyle.t18R.copyWith(color: ResourceColors.color_0058A6),
                alignment: TextAlign.center,
              );
            }),
          ),
        ),
        Expanded(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildBackButton(Function()? onBackAction) {
    return InkWell(
      onTap: onBackAction ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: 40.0,
        height: 40.0,
        alignment: Alignment.bottomLeft,
        child: SvgPicture.asset(
          'assets/images/svg/back.svg',
          width: Dimens.getHeight(10.0),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  // tab menu bottom
  Widget _buildBottomNavigationBar() {
    int numberOfUnreadNotifications = BaseStorage.instance
        .getIntValue(Constants.NUMBER_OF_UNREAD_NOTIFICATIONS);
    return DefaultTabController(
      length: 5,
      child: Container(
        decoration: widget.bottomBarColor == null
            ? _buildBoxDecorationBottomTab()
            : _buildBoxDecorationBottomTabNoGradient(),
        child: widget.buttonBottom != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.buttonBottom!,
                  _builDefaultTabControllerListener(
                      numberOfUnreadNotifications),
                ],
              )
            : _builDefaultTabControllerListener(numberOfUnreadNotifications),
      ),
    );
  }

  DefaultTabControllerListener _builDefaultTabControllerListener(
      int numberOfUnreadNotifications) {
    return DefaultTabControllerListener(
      child: TabBar(
        labelColor: ResourceColors.color_0e67ed,
        unselectedLabelColor: ResourceColors.color_666666,
        indicatorColor: ResourceColors.color_trans,
        indicatorWeight: 1.0,
        labelPadding: EdgeInsets.symmetric(horizontal: 1.0),
        labelStyle: MKStyle.t12B,
        unselectedLabelStyle: MKStyle.t12R.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          showTab(icon: 'assets/images/png/top.png', index: 0),
          showTab(icon: 'assets/images/png/history.png', index: 1),
          showTab(icon: 'assets/images/png/favorite.png', index: 2),
          showTab(icon: 'assets/images/png/inquiry.png', index: 3),
          showTab(
              icon: 'assets/images/png/notification.png',
              index: 4,
              badgeCounter: numberOfUnreadNotifications),
        ],
      ),
    );
  }

  Tab showTab({String icon = '', int index = 0, int badgeCounter = 0}) {
    return Tab(
      height: Dimens.getHeight(55.0),
      icon: InkWell(
        onTap: () async {
          await BaseStorage.instance
              .setIntValue(Constants.CURRENT_TAB_INDEX, index);

          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.searchTopPage);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.historyPage);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(
                AppRoutes.favoriteListPage,
                arguments: {"pic1Map": Map<String, String>()});
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.questionPage);
          } else {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.informListPage);
          }
        },
        child: Container(
          height: Dimens.getHeight(55.0, isFit: true),
          padding: EdgeInsets.only(bottom: Dimens.getHeight(5.0)),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                child: Image.asset(
                  icon,
                  height: Dimens.getHeight(36.0),
                  color: index == widget.currentIndex
                      ? ResourceColors.color_3768CE
                      : ResourceColors.color_929292,
                  fit: BoxFit.fill,
                ),
              ),
              badgeCounter > 0
                  ? Positioned(
                      top: Dimens.getHeight(10.0),
                      left: Dimens.getHeight(55.0 / 2),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(Dimens.getSize(2.0)),
                        decoration: ShapeDecoration(
                          color: Colors.red,
                          shape: StadiumBorder(),
                        ),
                        constraints: BoxConstraints(
                            minWidth: Dimens.getSize(12.0),
                            minHeight: Dimens.getSize(12.0)),
                        child: TextWidget(
                          label: badgeCounter < 10 ? "$badgeCounter" : "10+",
                          textStyle: MKStyle.t8R.copyWith(color: Colors.white),
                          alignment: TextAlign.center,
                        ),
                      ))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecorationBottomTab() {
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

  BoxDecoration _buildBoxDecorationBottomTabNoGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFEEF9FF),
          const Color(0xFFEEF9FF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFEEF9FF),
          const Color(0xFFFDFEFF),
          const Color(0xFFFFFFFF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Future handleBack() async {
    ProcessUtil.instance.cancelProcess();
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
    if (widget.routeName == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == widget.routeName);
    }
  }
}
