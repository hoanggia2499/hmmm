import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/search_input/data/models/input_model.dart';

class DatePickerCupertinoWidget extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final int minimumYear;
  final int? maximumYear;
  final bool openDatePicker;

  DatePickerCupertinoWidget(
      {Key? key,
      DateTime? initialDateTime,
      required this.onDateTimeChanged,
      this.openDatePicker = false,
      this.minimumDate,
      this.maximumDate,
      this.minimumYear = 1,
      this.maximumYear})
      : initialDateTime = initialDateTime ?? DateTime.now(),
        super(key: key) {
    assert(this.initialDateTime != null);
  }

  @override
  State<StatefulWidget> createState() => DatePickerCupertinoWidgetState();
}

class DatePickerCupertinoWidgetState extends State<DatePickerCupertinoWidget>
    with TickerProviderStateMixin {
  late FixedExtentScrollController firstValueListScrollController;
  late FixedExtentScrollController secondValueListScrollController;
  late FixedExtentScrollController thirdValueListScrollController;

  late List<String> yearValues;
  late List<String> monthValues;
  late List<String> dayValues;

  late int initYearIndex;
  late int initMonthIndex;
  late int initDayIndex;

  int yearIndexValue = 0;
  int monthIndexValue = 0;
  int dayIndexValue = 0;

  AnimationController? _animationController;
  Animation<double>? _expandAnimation;

  late DateTime initialDateTime;

  // The currently selected values of the picker.
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    initialDateTime = widget.initialDateTime!;

    selectedDay = initialDateTime.day;
    selectedMonth = initialDateTime.month;
    selectedYear = initialDateTime.year;

    yearValues = _buildYearValues(DateTime.now().year);
    yearValues.removeWhere((element) => element.isEmpty);
    monthValues = _buildMonthValues();
    monthValues.removeWhere((element) => element.isEmpty);
    dayValues = _buildDayValues();
    dayValues.removeWhere((element) => element.isEmpty);

    initYearIndex = yearValues.indexOf("$selectedYear");
    initMonthIndex = monthValues.indexOf("$selectedMonth");
    initDayIndex = dayValues.indexOf("$selectedDay");

    yearIndexValue = initYearIndex;
    monthIndexValue = initMonthIndex;
    dayIndexValue = initDayIndex;

    firstValueListScrollController =
        FixedExtentScrollController(initialItem: initYearIndex);
    secondValueListScrollController =
        FixedExtentScrollController(initialItem: initMonthIndex);
    thirdValueListScrollController =
        FixedExtentScrollController(initialItem: initDayIndex);

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
                      onSelectedDateChanged();
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
            child: _buildListWheel(
                yearValues, onValueFirstChange, firstValueListScrollController),
          ),
          Expanded(
            flex: 4,
            child: _buildListWheel(monthValues, onValueSecondChange,
                secondValueListScrollController),
          ),
          Expanded(
            flex: 4,
            child: _buildListWheel(
                dayValues, onValueThirdChange, thirdValueListScrollController),
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
            height: Dimens.getHeight(30.0),
            color: ResourceColors.color_d5,
          ),
        ),
        ListWheelScrollView(
          itemExtent: Dimens.getSize(30.0),
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

  // Calculate the number label center point by padding start and position to
  // get a reasonable offAxisFraction.

  void onValueFirstChange(int index) {
    setState(() {
      yearIndexValue = index;
      selectedYear = int.parse(yearValues[yearIndexValue]);

      // update valid date according selected month
      dayValues = _buildDayValues();
      dayValues.removeWhere((element) => element.isEmpty);
    });
  }

  void onValueSecondChange(int index) {
    setState(() {
      monthIndexValue = index;
      selectedMonth = int.parse(monthValues[monthIndexValue]);

      // update valid date according selected month
      dayValues = _buildDayValues();
      dayValues.removeWhere((element) => element.isEmpty);
    });
  }

  void onValueThirdChange(int index) {
    setState(() {
      dayIndexValue = index;
      selectedDay = int.parse(dayValues[dayIndexValue]);
    });
  }

  IndexModel getValueFirstSecond(IndexModel indexModel) {
    return indexModel;
  }

  void reset() {
    firstValueListScrollController.animateToItem(initYearIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
    secondValueListScrollController.animateToItem(initMonthIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
    thirdValueListScrollController.animateToItem(initDayIndex,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  onSelectedDateChanged() {
    if (_isCurrentDateValid) {
      widget.onDateTimeChanged(
          DateTime(selectedYear, selectedMonth, selectedDay));
    }
  }

  // The DateTime of the last day of a given month in a given year.
  // Let `DateTime` handle the year/month overflow.
  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  List<String> _buildDayValues() {
    final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day;

    return List<String>.generate(31, (index) {
      final int day = index + 1;
      return day <= daysInCurrentMonth ? "$day" : "";
    });
  }

  List<String> _buildMonthValues() {
    return List<String>.generate(12, (index) {
      final int month = index + 1;

      final bool isInvalidMonth = (widget.minimumDate?.year == selectedYear &&
              widget.minimumDate!.month > month) ||
          (widget.maximumDate?.year == selectedYear &&
              widget.maximumDate!.month < month);

      return !isInvalidMonth ? "$month" : "";
    });
  }

  List<String> _buildYearValues(int year) {
    if (year < widget.minimumYear) return List.empty();

    return List<String>.generate(20, (index) {
      if (widget.maximumYear != null && year > widget.maximumYear!) {
        return "${widget.maximumYear! - index}";
      }

      final bool isValidYear =
          (widget.minimumDate == null || widget.minimumDate!.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate!.year >= year);

      return isValidYear ? "${year - index}" : "";
    });
  }

  bool get _isCurrentDateValid {
    // The current date selection represents a range [minSelectedData, maxSelectDate].
    final DateTime minSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate?.isBefore(maxSelectedDate) ?? true;
    final bool maxCheck =
        widget.maximumDate?.isBefore(minSelectedDate) ?? false;

    return minCheck && !maxCheck && minSelectedDate.day == selectedDay;
  }
}
