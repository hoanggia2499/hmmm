import 'package:flutter/material.dart';

class DateScrollView extends StatelessWidget {
  const DateScrollView({
    Key? key,
    required this.onChanged,
    required this.dates,
    required this.controller,
    required this.options,
    required this.scrollViewOptions,
    required this.selectedIndex,
    required this.locale,
    this.isYearScrollView = false,
    this.isMonthScrollView = false,
  }) : super(key: key);

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// This is a list of dates.
  final List dates;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// A set that allows you to specify options related to ScrollView.
  final ScrollViewDetailOptions scrollViewOptions;

  /// The currently selected date index.
  final int selectedIndex;

  /// Set calendar language
  final Locale locale;

  final bool isYearScrollView;

  final bool isMonthScrollView;

  double _getScrollViewWidth(BuildContext context) {
    String _longestText = '';
    //  List _dates = isMonthScrollView ? locale.months : dates;
    List _dates = dates;

    for (var text in _dates) {
      if ('$text'.length > _longestText.length) {
        _longestText = '$text'.padLeft(2, '0');
      }
    }
    _longestText += scrollViewOptions.label;
    final TextPainter _painter = TextPainter(
      text: TextSpan(
        style: scrollViewOptions.selectedTextStyle,
        text: _longestText,
      ),
      textDirection: Directionality.of(context),
    );
    _painter.layout();
    return _painter.size.width + 8.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int _maximumCount = constraints.maxHeight ~/ options.itemExtent;
        return Container(
          margin: scrollViewOptions.margin,
          width: _getScrollViewWidth(context),
          child: ListWheelScrollView.useDelegate(
            itemExtent: options.itemExtent,
            diameterRatio: options.diameterRatio,
            controller: controller,
            physics: const FixedExtentScrollPhysics(),
            perspective: options.perspective,
            onSelectedItemChanged: onChanged,
            childDelegate: options.isLoop && dates.length > _maximumCount
                ? ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                      dates.length,
                      (index) => _buildDateView(index: index),
                    ),
                  )
                : ListWheelChildListDelegate(
                    children: List<Widget>.generate(
                      dates.length,
                      (index) => _buildDateView(index: index),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDateView({required int index}) {
    return Container(
      alignment: scrollViewOptions.alignment,
      child: Text(
        '${dates[index]}${scrollViewOptions.label}',
        style: selectedIndex == index
            ? scrollViewOptions.selectedTextStyle
            : scrollViewOptions.textStyle,
      ),
    );
  }
}

class DatePickerOptions {
  const DatePickerOptions({
    this.itemExtent = 30.0,
    this.diameterRatio = 3,
    this.perspective = 0.01,
    this.isLoop = true,
  });

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// The loop iterates on an explicit list of values
  final bool isLoop;
}

class DatePickerScrollViewOptions {
  const DatePickerScrollViewOptions({
    this.year = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
    this.month = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
    this.day = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
  });

  final ScrollViewDetailOptions year;
  final ScrollViewDetailOptions month;
  final ScrollViewDetailOptions day;
}

class ScrollViewDetailOptions {
  const ScrollViewDetailOptions({
    this.label = '',
    this.alignment = Alignment.centerLeft,
    this.margin,
    this.selectedTextStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.textStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  });

  /// The text printed next to the year, month, and day.
  final String label;

  /// The year, month, and day text alignment method.
  final Alignment alignment;

  /// The amount of space that can be added to the year, month, and day.
  final EdgeInsets? margin;

  /// An immutable style describing how to format and paint text.
  final TextStyle textStyle;

  /// An invariant style that specifies the selected text format and explains how to draw it.
  final TextStyle selectedTextStyle;
}
