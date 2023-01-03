import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_17_18.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class TemplatePattern1 extends StatefulWidget {
  final bool? isShowCheckBox;
  final int? typeButton;
  final bool? hasImage;
  final VoidCallback? topCallBack;
  final Function(bool)? checkBoxCallBack;
  final Function(bool)? favoriteCallBack;
  final VoidCallback? quoteCallBack;
  final VoidCallback? phoneCallBack;
  final VoidCallback? deleteCallBack;
  final ItemSearchModel? itemTemPlate;
  final bool? value;
  bool isFavorite;
  bool isShowbottomUI;

  TemplatePattern1(
      {this.isShowCheckBox = true,
      this.isFavorite = false,
      this.typeButton = 1,
      this.hasImage = true,
      this.checkBoxCallBack,
      this.favoriteCallBack,
      this.quoteCallBack,
      this.phoneCallBack,
      this.topCallBack,
      this.itemTemPlate,
      this.value,
      this.isShowbottomUI = true,
      this.deleteCallBack});
  @override
  _TemplatePattern1State createState() => _TemplatePattern1State();
}

class _TemplatePattern1State extends State<TemplatePattern1> {
  @override
  Widget build(BuildContext context) {
    return widget.typeButton == 1
        ? InkWell(
            onTap: () {
              widget.topCallBack!.call();
            },
            child: _buildMainWidget(),
          )
        : _buildMainWidget();
  }

  _buildMainWidget() {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.getWidth(8.0),
          vertical: Dimens.getHeight(15.0),
        ),
        child: Column(
          children: [
            _buildTopWidget(),
            _buidCenterWidget(),
            Visibility(
                visible: widget.isShowbottomUI, child: _buildBottomWidget())
          ],
        ));
  }

  _buildTopWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRightSideWidget(),
          InkWell(
            onTap: () {
              setState(() {
                widget.isFavorite = !widget.isFavorite;
              });
              widget.favoriteCallBack!.call(widget.isFavorite);
            },
            child: Image.asset("assets/images/png/star.png",
                width: Dimens.getWidth(28.0),
                height: Dimens.getHeight(28.0),
                color: widget.isFavorite == true
                    ? Colors.yellow
                    : ResourceColors.color_E1E1E1),
          )
        ],
      ),
    );
  }

  _buidCenterWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildMainLeftWidget(), _buildMainRightWidget()],
    );
  }

  _buildBottomWidget() {
    return Padding(
      padding: EdgeInsets.only(top: Dimens.getHeight(15)),
      child: Visibility(
        visible: widget.typeButton == 1 ? true : false,
        child: RowWidgetPattern17(
          clickIcon: widget.isFavorite,
          iconButtonLeft: widget.isShowCheckBox == true
              ? "assets/images/png/okiniiri_icon.png"
              : "assets/images/png/delete_button_icon.png",
          iconButtonCenter: "assets/images/png/mitsumori_icon.png",
          iconButtonRight: "assets/images/png/tel_icon.png",
          textButtonLeft:
              widget.isShowCheckBox == true ? "FAVORITE".tr() : "DELETE".tr(),
          textButtonCenter: "QUOTATION_REQUEST".tr(),
          textButtonRight: "TO_CALL".tr(),
          callbackBtnLeft: (bool value) {
            widget.favoriteCallBack!.call(value);
          },
          callbackBtnCenter: () {
            widget.quoteCallBack!.call();
          },
          callbackToCall: () {
            widget.phoneCallBack!.call();
          },
        ),
      ),
    );
  }

  /*  _buildTopButton(Color backgroundColor, String label) {
    return label == "✖"
        ? InkWell(
            onTap: () {
              widget.deleteCallBack!.call();
            },
            child: _buildMainButton(backgroundColor, label),
          )
        : _buildMainButton(backgroundColor, label);
  }
 */
  /*  _buildMainButton(Color backgroundColor, String label) {
    return Container(
      width: MediaQuery.of(context).size.width / 11,
      height: MediaQuery.of(context).size.width / 11,
      alignment: Alignment.center,
      color: backgroundColor,
      child: Center(
        child: Text(label,
            textAlign: TextAlign.center,
            style: MKStyle.t25R
                .copyWith(height: 1.0, color: ResourceColors.color_white)),
      ),
    );
  } */

  _buildMainLeftWidget() {
    if (widget.itemTemPlate != null &&
        widget.itemTemPlate!.imageUrl.isNotEmpty) {
      return FadeInImage.assetNetwork(
        width: MediaQuery.of(context).size.width / 3,
        image: widget.itemTemPlate?.imageUrl ?? "",
        imageErrorBuilder: (_, __, ___) {
          return Image.asset(
            width: MediaQuery.of(context).size.width / 3,
            'assets/images/png/no_image_s.png',
          ); //this is what will fill the Container in case error happened
        },
        placeholder:
            'assets/images/png/no_image_s.png', // your assets image path
        fit: BoxFit.fill,
      );
    }
    return Image.asset(
      width: MediaQuery.of(context).size.width / 3,
      'assets/images/png/no_image_s.png',
    );
  }

  _buildMainRightWidget() {
    return Expanded(
        flex: 6,
        child: Padding(
          padding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMainRowWidget(
                  "CONTACT_US_NUMBER".tr(),
                  "500-" +
                      widget.itemTemPlate!.corner +
                      widget.itemTemPlate!.fullExhNum,
                  sizeTitle: DimenFont.sp10,
                  sizeValue: DimenFont.sp14),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      label: "PRICE_MAIN".tr(),
                      textStyle:
                          MKStyle.t10R.copyWith(color: ResourceColors.color_70),
                    ),
                  ),
                  SizedBox(
                    width: Dimens.getHeight(10),
                  ),
                  Expanded(flex: 4, child: _buildPriceValue())
                ],
              ),
              SizedBox(
                height: Dimens.getHeight(10),
              ),
              _buildMainRowWidget(
                  'MODEL_YEAR_HISTORY'.tr(),
                  HelperFunction.instance
                      .getJapanYearFromAd(widget.itemTemPlate!.carModel),
                  columnLength: 2,
                  titleRight: 'RUNNING'.tr(),
                  valueRight:
                      '${widget.itemTemPlate!.carMileage / 10}${'TEN_THOUSAND'.tr()}km'),
              _buildMainRowWidget("CAR_INSPECTION".tr(),
                  getInspection(widget.itemTemPlate!.inspection),
                  columnLength: 2,
                  titleRight: 'REPAIR'.tr(),
                  valueRight: widget.itemTemPlate!.dTPointTotal == 'R'
                      ? "CAN_BE".tr()
                      : "NONE".tr()),
              _buildMainRowWidget('FUEL'.tr(), widget.itemTemPlate!.fuelName,
                  columnLength: 2,
                  titleRight: 'SHIFT'.tr(),
                  valueRight: widget.itemTemPlate!.shiftName),
              _buildMainRowWidget('ENGINE_DISPLACEMENT'.tr(),
                  '${widget.itemTemPlate!.carVolume}cc',
                  columnLength: 2,
                  titleRight: 'LOCATION'.tr(),
                  valueRight: widget.itemTemPlate!.carLocation),
              _buildMainRowWidget(
                'INTERIO_COLOR'.tr(),
                '${widget.itemTemPlate!.sysColorName}',
                columnLength: 2,
                titleRight: '',
                valueRight: '',
              ),
            ],
          ),
        ));
  }

  Widget _buildPriceValue() {
    return Stack(
      children: [
        Visibility(
          visible: widget.itemTemPlate!.priceValue == "ーー" ? true : false,
          child: Align(
            alignment: Alignment.center,
            child: TextWidget(
              label: widget.itemTemPlate!.priceValue,
              textStyle:
                  MKStyle.t14B.copyWith(color: ResourceColors.color_EA3323),
            ),
          ),
        ),
        Visibility(
          visible: widget.itemTemPlate!.priceValue == "ーー" ? false : true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                label: widget.itemTemPlate!.priceValue,
                textStyle:
                    MKStyle.t14B.copyWith(color: ResourceColors.color_EA3323),
              ),
              TextWidget(
                label: widget.itemTemPlate!.priceValue2,
                textStyle: MKStyle.t14B.copyWith(color: ResourceColors.red_bg),
              ),
              TextWidget(
                  label: widget.itemTemPlate!.yen, textStyle: MKStyle.t14R),
              ..._buildIconStar(widget.itemTemPlate!.stars),
            ],
          ),
        ),
      ],
    );
  }

  _buildMainRowWidget(String titleLeft, String valueLeft,
      {int columnLength = 1,
      String titleRight = '',
      String valueRight = '',
      double sizeTitle = 0,
      double sizeValue = 0}) {
    return Row(children: [
      //Left Side
      Expanded(
          child: _buildRowWithValue(titleLeft, valueLeft,
              sizeTitle: sizeTitle, sizeValue: sizeValue)),
      //Right Side
      if (columnLength > 1)
        Expanded(
          child: _buildRowWithValue(titleRight, valueRight),
        )
    ]);
  }

  /*  _buildRowLeftWithValue(String title, String value,
      {double sizeTitle = 0, double sizeValue = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: TextWidget(
            label: title,
            textStyle: MKStyle.t8R.copyWith(
                color: ResourceColors.color_70,
                fontSize: sizeTitle == 0 ? DimenFont.sp8 : sizeTitle),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextWidget(
            label: value,
            textStyle: MKStyle.t10R.copyWith(
                fontSize: sizeValue == 0 ? DimenFont.sp10 : sizeValue),
          ),
        )
      ],
    );
  } */

  _buildRowWithValue(String title, String value,
      {double sizeTitle = 0, double sizeValue = 0}) {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            label: title,
            textStyle: MKStyle.t8R.copyWith(
                color: ResourceColors.color_70,
                fontSize: sizeTitle == 0 ? DimenFont.sp8 : sizeTitle),
          ),
        ),
        Expanded(
          child: TextWidget(
            label: value,
            textStyle: MKStyle.t10R.copyWith(
                fontSize: sizeValue == 0 ? DimenFont.sp10 : sizeValue),
          ),
        )
      ],
    );
  }

  _buildRightSideWidget() {
    return Expanded(
        flex: 6,
        child: Padding(
          padding: EdgeInsets.only(right: Dimens.getWidth(30.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  label: widget.itemTemPlate!.makerName +
                      " " +
                      widget.itemTemPlate!.carName +
                      " " +
                      widget.itemTemPlate!.carGrade,
                  textStyle: MKStyle.t14R),
            ],
          ),
        ));
  }

  List<Widget> _buildIconStar(int stars) {
    return List.generate(
        stars,
        (index) => Image.asset(
              'assets/images/png/bookmark_icon.png',
              fit: BoxFit.fill,
              height: Dimens.getHeight(15.0),
            ));
  }

  String getInspection(String year) {
    String newYear = year.replaceAll(' ', '');
    if (newYear != '') {
      return HelperFunction.instance.getJapanYearFormat(newYear);
    } else {
      return '';
    }
  }
}
