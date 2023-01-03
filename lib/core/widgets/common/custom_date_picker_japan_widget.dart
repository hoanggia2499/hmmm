import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

const double _kItemExtent = 32.0;
const double _kMagnification = 2.35 / 2.1;
const double _kSqueeze = 1.25;

/* const Widget _startSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capEndEdge: false); */
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
    capStartEdge: false, capEndEdge: false);
const Widget _endSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capStartEdge: false);

typedef _ColumnBuilder = Widget Function(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
    int index);

class CustomDatePickerJapan extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final int minimumYear;
  final int? maximumYear;
  final bool useMagnifier;

  CustomDatePickerJapan({
    Key? key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear = 1,
    this.maximumYear,
    this.useMagnifier = false,
  }) : super(key: key);

  @override
  State<CustomDatePickerJapan> createState() => _CustomDatePickerJapanState();
}

class _CustomDatePickerJapanState extends State<CustomDatePickerJapan> {
  List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];

  // The currently selected values of the picker.
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  int indexDate = 0;
  int indexYear = 0;

  // The controller of the day picker. There are cases where the selected value
  // of the picker is invalid (e.g. February 30th 2018), and this dayController
  // is responsible for jumping to a valid value.
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  double magnification = 1.0;

  @override
  void initState() {
    super.initState();

    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: 31 - selectedDay);
    monthController =
        FixedExtentScrollController(initialItem: 12 - selectedMonth);

    yearController = FixedExtentScrollController(initialItem: getIndexYear());

    magnification = widget.useMagnifier ? _kMagnification : 1.0;
  }

  getIndexYear() {
    int index = 0;
    if (selectedYear == 0) {
      index = 0;
    } else if (selectedYear == widget.maximumYear!) {
      index = 1;
    } else if (selectedYear == widget.maximumYear! - 1) {
      index = 2;
    } else if (selectedYear == widget.maximumYear! - 2) {
      index = 3;
    } else if (selectedYear == widget.maximumYear! - 3) {
      index = 4;
    } else if (selectedYear == widget.maximumYear! - 4) {
      index = 5;
    } else if (selectedYear == widget.maximumYear! - 5) {
      index = 6;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    pickerBuilders = <_ColumnBuilder>[];

    return Stack(
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
    );
  }

  // The DateTime of the last day of a given month in a given year.
  // Let `DateTime` handle the year/month overflow.
  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    /*  final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day; */

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        offAxisFraction: offAxisFraction,
        itemExtent: Dimens.getHeight(_kItemExtent),
        useMagnifier: widget.useMagnifier,
        magnification: magnification,
        backgroundColor: ResourceColors.color_FFFFFF,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          setState(() {
            selectedDay = 31 - index;
            indexDate = index;
          });
        },
        looping: false,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(31, (int index) {
          final int day = 31 - index;
          return itemPositioningBuilder(
            context,
            // _buildPickerLabel("$day" + "日", isValid: day <= daysInCurrentMonth),
            _buildPickerLabel("$day" + "DAY".tr(), isValid: true),
          );
        }),
      ),
    );
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

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: Dimens.getHeight(_kItemExtent),
        useMagnifier: widget.useMagnifier,
        magnification: magnification,
        backgroundColor: ResourceColors.color_FFFFFF,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          setState(() {
            selectedMonth = 12 - index;
          });
        },
        looping: false,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int month = 12 - index;
          /* final bool isInvalidMonth =
              (widget.minimumDate?.year == selectedYear &&
                      widget.minimumDate!.month > month) ||
                  (widget.maximumDate?.year == selectedYear &&
                      widget.maximumDate!.month < month);
 */
          return itemPositioningBuilder(
            context,
            _buildPickerLabel("$month" + "MONTH".tr(), isValid: true),
          );
        }),
      ),
    );
  }

  Widget _buildYearCustomPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: yearController,
        offAxisFraction: offAxisFraction,
        itemExtent: Dimens.getHeight(_kItemExtent),
        useMagnifier: widget.useMagnifier,
        magnification: magnification,
        backgroundColor: ResourceColors.color_FFFFFF,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          setState(() {
            // 0: "指定なし"
            selectedYear = index == 0 ? 0 : widget.maximumYear! - (index - 1);
            indexYear = index;
          });
        },
        looping: false,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(7, (int index) {
          // final bool isInvalidMonth =
          //     (widget.minimumDate?.year == selectedYear &&
          //             widget.minimumDate!.year > year) ||
          //         (widget.maximumDate?.year == selectedYear &&
          //             widget.maximumDate!.year < year);

          int year = widget.maximumYear! - (index - 1);
          return itemPositioningBuilder(
            context,
            _buildPickerLabel(
                index == 0
                    ? "UNSPECIFIED".tr()
                    : HelperFunction.instance.getJapanYearFromAd(year),
                isValid: true),
          );
        }),
      ),
    );
  }

  Widget _buildPickerLabel(String text, {bool isValid = true}) {
    return Center(
      child: TextWidget(
        label: text,
        textStyle: MKStyle.t14R.copyWith(
          color: isValid
              ? Colors.black
              : CupertinoDynamicColor.resolve(
                  CupertinoColors.inactiveGray, context),
        ),
        textOverflow: TextOverflow.visible,
      ),
    );
  }

  // One or more pickers have just stopped scrolling.
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final DateTime minSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumDate?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.maximumDate! : widget.minimumDate!;
      _scrollToDate(targetDate);
      return;
    }

    // Some months have less days (e.g. February). Go to the last day of that month
    // if the selectedDay exceeds the maximum.
    if (minSelectDate.day != selectedDay) {
      final DateTime lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  void _scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }

      if (selectedDay != newDate.day) {
        _animateColumnControllerToItem(dayController, indexDate + 1);
      }
    });
  }

  void _animateColumnControllerToItem(
      FixedExtentScrollController controller, int targetItem) {
    controller.animateToItem(
      targetItem,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildMainItem() {
    double offAxisFraction = 0.0;

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
      // EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: _buildYearCustomPicker(offAxisFraction,
                (context, child) => child!, _centerSelectionOverlay),
          ),
          Expanded(
            flex: 5,
            child: _buildMonthPicker(offAxisFraction,
                (context, child) => child!, _centerSelectionOverlay),
          ),
          Expanded(
            flex: 5,
            child: _buildDayPicker(offAxisFraction, (context, child) => child!,
                _endSelectionOverlay),
          ),
        ],
      ),
    );
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
                        if (_isCurrentDateValid) {
                          widget.onDateTimeChanged(DateTime(
                              selectedYear, selectedMonth, selectedDay));
                        }
                        Navigator.pop(context);
                      },
                      child: TextWidget(
                        label: "CONFIRM".tr(),
                        textStyle: MKStyle.t14B
                            .copyWith(color: ResourceColors.color_3768CE),
                      )),
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
}
