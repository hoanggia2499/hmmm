import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/search_input/data/models/input_model.dart';

class DatePickerWidget3 extends StatefulWidget {
  DatePickerWidget3({
    required this.firstValueList,
    required this.secondValueList,
    this.openDatePicker = true,
    this.initFirstIndex = 0,
    this.initSecondIndex = 0,
    this.onChange,
    required this.thirdValueList,
    required this.initThirdIndex,
  });

  final List<String> firstValueList;
  final int initFirstIndex;
  final List<String> secondValueList;
  final int initSecondIndex;
  final List<String> thirdValueList;
  final int initThirdIndex;
  final bool openDatePicker;

  final Function(IndexModel)? onChange;

  @override
  State<StatefulWidget> createState() => DatePickerWidget3State();
}

class DatePickerWidget3State extends State<DatePickerWidget3>
    with TickerProviderStateMixin {
  late FixedExtentScrollController firstValueListScrollController;
  late FixedExtentScrollController secondValueListScrollController;
  late FixedExtentScrollController thirdValueListScrollController;

  int firstIndexValue = 0;
  int secondIndexValue = 0;
  int thirdIndexValue = 0;

  late int firstInitIndex;
  late int secondInitIndex;
  late int thirdInitIndex;

  AnimationController? _animationController;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    firstIndexValue = widget.initFirstIndex;
    secondIndexValue = widget.initSecondIndex;
    thirdInitIndex = widget.initThirdIndex;

    firstValueListScrollController =
        FixedExtentScrollController(initialItem: widget.initFirstIndex);
    secondValueListScrollController =
        FixedExtentScrollController(initialItem: widget.initSecondIndex);
    thirdValueListScrollController =
        FixedExtentScrollController(initialItem: widget.initThirdIndex);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: _buildListWheel(widget.firstValueList, onValueFirstChange,
                firstValueListScrollController),
          ),
          Expanded(
            flex: 4,
            child: _buildListWheel(widget.secondValueList, onValueSecondChange,
                secondValueListScrollController),
          ),
          Expanded(
            flex: 4,
            child: _buildListWheel(widget.thirdValueList, onValueThirdChange,
                thirdValueListScrollController),
          ),
        ],
      ),
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
            height: 30.0,
            color: ResourceColors.color_d5,
          ),
        ),
        ListWheelScrollView(
          itemExtent: 30.0,
          // Size of each child in main axis
          diameterRatio: 50,
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

  void onValueThirdChange(int index) {
    setState(() {
      thirdIndexValue = index;
    });
  }

  IndexModel getValueFirstSecond(IndexModel indexModel) {
    return indexModel;
  }

  void reset() {
    firstValueListScrollController.animateToItem(firstInitIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
    secondValueListScrollController.animateToItem(secondInitIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
    thirdValueListScrollController.animateToItem(thirdInitIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
