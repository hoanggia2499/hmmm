import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/search_input/data/models/input_model.dart';
import 'package:easy_localization/easy_localization.dart';

class DatePickerWidget2 extends StatefulWidget {
  DatePickerWidget2({
    required this.firstValueList,
    this.openDatePicker = true,
    this.initFirstIndex = 0,
    this.onChange,
  });

  final List<String> firstValueList;
  final int initFirstIndex;
  final bool openDatePicker;

  final Function(IndexModel)? onChange;
  @override
  State<StatefulWidget> createState() => DatePickerWidget2State();
}

class DatePickerWidget2State extends State<DatePickerWidget2>
    with TickerProviderStateMixin {
  late FixedExtentScrollController firstValueListScrollController;
  late FixedExtentScrollController secondValueListScrollController;

  int firstIndexValue = 0;
  int secondIndexValue = 0;

  late int firstInitIndex;
  late int initIndexMonth;

  AnimationController? _animationController;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    firstIndexValue = widget.initFirstIndex;

    firstValueListScrollController =
        FixedExtentScrollController(initialItem: widget.initFirstIndex);
    _buildAnimation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: widget.openDatePicker == false
            ? _expandAnimation =
                Tween(begin: 0.0, end: 1.0).animate(_animationController!)
            : _expandAnimation =
                Tween(begin: 1.0, end: 0.0).animate(_animationController!),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  color: ResourceColors.color_FFFFFF,
                  child: Stack(
                    children: [
                      _buildMainItem(),
                      _buildTopItem(),
                      _buildBottomItem()
                    ],
                  )),
            )
          ],
        ));
  }

  _buildAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController?.forward();
  }

  Widget _buildBottomItem() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 18,
        child: Container(
          decoration: _buildBoxDecorationBottom(),
        ),
      ),
    );
  }

  Widget _buildTopItem() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 16,
            color: ResourceColors.color_E1E1E1,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      //  widget.onChange?.call(getValueFirstSecond(IndexModel()));
                      Navigator.pop(context);
                    },
                    child: TextWidget(
                      label: "CANCEL".tr(),
                      textStyle: MKStyle.t14B
                          .copyWith(color: ResourceColors.color_3768CE),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onChange?.call(getValueFirstSecond(IndexModel(
                          firstIndex: firstIndexValue,
                          secondIndex: secondIndexValue)));
                      Navigator.pop(context);
                    },
                    child: TextWidget(
                      label: "CONFIRM".tr(),
                      textStyle: MKStyle.t14B
                          .copyWith(color: ResourceColors.color_3768CE),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 18,
            child: Container(
              decoration: _buildBoxDecorationTop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainItem() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
      // EdgeInsets.only(top: 0),
      child: _buildListWheel(widget.firstValueList, onValueFirstChange,
          firstValueListScrollController),
    );
  }

  BoxDecoration _buildBoxDecorationBottom() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ResourceColors.color_white_4,
          ResourceColors.color_FFFFFF,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration _buildBoxDecorationTop() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ResourceColors.color_FFFFFF,
          ResourceColors.color_white_4,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildListWheel(List<String> items, Function(int)? onChange,
      ScrollController controller) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: Dimens.getWidth(30.0),
            color: ResourceColors.color_d5,
          ),
        ),
        ListWheelScrollView(
          itemExtent: Dimens.getWidth(30.0), // Size of each child in main axis
          diameterRatio: Dimens.getWidth(50.0),
          clipBehavior: Clip.none,
          controller: controller,
          onSelectedItemChanged: onChange,
          children: [
            for (int i = 0; i < items.length; i++)
              Container(
                child: TextWidget(
                  label: items[i],
                  alignment: TextAlign.center,
                  textStyle: MKStyle.t14R,
                ),
              ),
          ], // Index of array
        ),
      ],
    );
  }

  void onValueFirstChange(int index) {
    setState(() {
      firstIndexValue = index;
    });
  }

  void onValueSecondChange(int index) {
    setState(() {
      secondIndexValue = index;
    });
  }

  IndexModel getValueFirstSecond(IndexModel indexModel) {
    return indexModel;
  }

  void reset() {
    firstValueListScrollController.animateToItem(firstInitIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
    secondValueListScrollController.animateToItem(initIndexMonth,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
