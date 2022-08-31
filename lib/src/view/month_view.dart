// ignore_for_file: prefer_adjacent_string_concatenation

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/widgets/day_cell.dart';

import '../core/app_log.dart';

/// The [SlMonthView] widget displays calendar like view of the events
/// that scrolls
class SlMonthView<T> extends StatefulWidget {
  ///
  const SlMonthView({
    required this.timelines,
    required this.onWillAccept,
    required this.onMonthChanged,
    Key? key,
    this.onEventDragged,
    this.controller,
    this.cellBuilder,
    this.headerCellBuilder,
    // ignore: always_specify_types
    this.items = const [],
    this.itemBuilder,
    this.fullWeek = false,
    this.headerHeight = 45,
    this.hourLabelBuilder,
    this.nowIndicatorColor,
    this.isDragable = false,
    this.isSwipeEnable = false,
    this.showNowIndicator = true,
    this.deadCellBuilder,
    this.snapToDay = true,
    this.onTap,
  }) : super(key: key);

  /// [TimetableController] is the controller that also initialize the timetable
  final TimetableController? controller;

  /// Renders for the cells the represent each hour that provides
  /// that [DateTime] for that hour
  final Widget Function(Period)? cellBuilder;

  /// Renders for the header that provides the [DateTime] for the day
  final Widget Function(int)? headerCellBuilder;

  /// Timetable items to display in the timetable
  final List<CalendarEvent<T>> items;

  /// Renders event card from `TimetableItem<T>` for each item
  final Widget Function(List<CalendarEvent<T>>, Size size)? itemBuilder;

  /// Renders hour label given [TimeOfDay] for each hour
  final Widget Function(Period period)? hourLabelBuilder;

  /// Renders upper left corner of the timetable given the first visible date
  final Widget Function(DateTime current)? deadCellBuilder;

  /// Snap to hour column. Default is `true`.
  final bool snapToDay;

  ///bool is dragable
  ///
  final bool isDragable;

  ///final isSwipeEnable
  final bool isSwipeEnable;

  ///show now indicator,default is true
  final bool showNowIndicator;

  /// Color of indicator line that shows the current time.

  ///  Default is `Theme.indicatorColor`.
  final Color? nowIndicatorColor;

  /// Full week only

  final bool fullWeek;

  /// height  of the header
  final double headerHeight;

  ///onTap callback
  final Function(DateTime dateTime, Period, CalendarEvent<T>?)? onTap;

  /// The [SlMonthView] widget displays calendar like view
  /// of the events that scrolls

  /// list of the timeline
  final List<Period> timelines;

  ///return new and okd event
  final Function(CalendarEvent<T> old, CalendarEvent<T> newEvent)?
      onEventDragged;

  ///retun current month when user swipe and month changed
  final Function(Month) onMonthChanged;

  /// Called to determine whether this widget is interested in receiving a given
  /// piece of data being dragged over this drag target.
  ///
  /// Called when a piece of data enters the target. This will be followed by
  /// either [onAccept] and [onAcceptWithDetails], if the data is dropped, or
  /// [onLeave], if the drag leaves the target.
  final Function(CalendarEvent<T>, DateTime, Period) onWillAccept;

  @override
  State<SlMonthView<T>> createState() => _SlMonthViewState<T>();
}

class _SlMonthViewState<T> extends State<SlMonthView<T>> {
  double columnWidth = 50;
  TimetableController controller = TimetableController();
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  Color get nowIndicatorColor =>
      widget.nowIndicatorColor ?? Theme.of(context).indicatorColor;
  int? _listenerId;

  List<CalendarDay> dateRange = <CalendarDay>[];
  List<Month> monthRange = <Month>[];
  PageController pageController = PageController();

  @override
  void initState() {
    controller = widget.controller ?? controller;
    _listenerId = controller.addListener(_eventHandler);
    if (widget.items.isNotEmpty) {
      widget.items.sort((CalendarEvent<T> a, CalendarEvent<T> b) =>
          a.startTime.compareTo(b.startTime));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => adjustColumnWidth());
    initDate();
    super.initState();
  }

  ///get initial list of dates
  void initDate() {
    log('Setting dates in month view');
    final int diff = controller.end.difference(controller.start).inDays;
    dateRange.clear();
    for (int i = 0; i < diff; i++) {
      final DateTime date = controller.start.add(Duration(days: i));
      if (widget.fullWeek) {
        dateRange.add(CalendarDay(dateTime: date));
      } else {
        if (date.weekday > 5) {
        } else {
          dateRange.add(CalendarDay(dateTime: date));
        }
      }
    }
    monthRange = getMonthRange(controller.start, controller.end);
    dateForHeader = dateRange[0].dateTime;
    setState(() {});
    controller.jumpTo(DateTime.now());
  }

  ///get data range
  List<DateTime> getDateRange() {
    final List<DateTime> tempDateRange = <DateTime>[];
    appLog('Setting dates');
    final int diff = controller.end.difference(controller.start).inDays;
    dateRange.clear();
    for (int i = 0; i < diff; i++) {
      final DateTime date = controller.start.add(Duration(days: i));
      if (widget.fullWeek) {
        dateRange.add(CalendarDay(dateTime: date));
      } else {
        if (date.weekday > 5) {
        } else {
          dateRange.add(CalendarDay(dateTime: date));
        }
      }
    }

    return tempDateRange;
  }

  ///return count of periods and break that are overlapping
  List<int> getOverLappingTimeline(TimeOfDay start, TimeOfDay end) {
    const int p = 0;
    const int b = 0;

    appLog('Event P:$p and B:$b');
    return <int>[p, b];
  }

  ///get cell height
  double getCellHeight(List<int> data) =>
      data[0] * controller.cellHeight + data[1] * controller.breakHeight;

  @override
  void dispose() {
    if (_listenerId != null) {
      controller.removeListener(_listenerId!);
    }
    super.dispose();
  }

  Future<void> _eventHandler(TimetableControllerEvent event) async {
    if (event is TimetableJumpToRequested) {
      await _jumpTo(event.date);
    }

    if (event is TimetableVisibleDateChanged) {
      appLog('visible data changed');
      // final DateTime prev = controller.visibleDateStart;
      // final DateTime now = DateTime.now();
      await adjustColumnWidth();
      // await _jumpTo(
      //     DateTime(prev.year, prev.month, prev.day, now.hour, now.minute));
      return;
    }
    if (event is TimetableDateChanged) {
      appLog('date changed');
      initDate();
    }
    if (event is TimetableMaxColumnsChanged) {
      appLog('max column changed');
      await adjustColumnWidth();
    }
    if (mounted) {
      setState(() {});
    }
  }

  double getHeightOfTheEvent(CalendarEvent<dynamic> item) {
    double h = 0;

    final List<Period> periods = <Period>[];

    for (final Period period in widget.timelines) {
      if (period.startTime.hour >= item.startTime.hour) {
        if (period.endTime.hour <= item.endTime.hour) {
          if (period.startTime.minute >= item.startTime.minute) {
            if (period.endTime.minute <= item.endTime.minute) {
              periods.add(period);
            }
          }
        }
      }
    }

    for (final Period element in periods) {
      h = h +
          (element.isBreak ? controller.breakHeight : controller.cellHeight);
    }
    return h;
  }

  double maxColumn = 5;

  Future<dynamic> adjustColumnWidth() async {
    final RenderBox? box =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    if (box.hasSize) {
      final Size size = box.size;
      final double layoutWidth = size.width;
      final double width = layoutWidth < 550
          ? ((layoutWidth - controller.timelineWidth) / controller.columns)
          : (layoutWidth - controller.timelineWidth) / controller.maxColumn;
      if (width != columnWidth) {
        columnWidth = width;

        await Future<dynamic>.microtask(() => null);
        setState(() {});
      }
    }
  }

  DateTime dateForHeader = DateTime.now();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      key: _key,
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        final double columnHeight = (size.height) / 4;
        final double aspectRation = columnWidth / columnHeight;
        log('aspect ratio $aspectRation');
        return SizedBox(
          height: getTimelineHeight(
              widget.timelines, controller.cellHeight, controller.breakHeight),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: controller.headerHeight,
                child: GridView.builder(
                    itemCount: 7,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7),
                    itemBuilder: (BuildContext context, int index) => Column(
                          children: <Widget>[widget.headerCellBuilder!(index)],
                        )),
              ),
              SizedBox(
                height: size.height - controller.headerHeight,
                child: PageView.builder(
                    // cacheExtent: 10000.0,
                    controller: pageController,
                    padEnds: false,
                    physics: widget.isSwipeEnable
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    onPageChanged: (int value) {
                      dateForHeader = dateRange[value].dateTime;
                      setState(() {});
                      widget.onMonthChanged(monthRange[value]);
                    },
                    itemCount: monthRange.length,
                    // itemExtent: size.width - controller.timelineWidth,
                    // controller: _dayScrollController,
                    itemBuilder: (BuildContext context, int index) {
                      final Month month = monthRange[index];
                      final List<CalendarDay> dates =
                          getDatesForCurrentView(month, monthRange, dateRange);
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: 35,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: aspectRation, crossAxisCount: 7),
                        itemBuilder: (BuildContext context, int index) {
                          final DateTime dateTime = dates[index].dateTime;
                          final List<CalendarEvent<T>> events = widget.items
                              .where((CalendarEvent<T> event) =>
                                  DateUtils.isSameDay(
                                      dateTime, event.startTime))
                              .toList();
                          return DayCell<T>(
                              calendarDay: dates[index],
                              columnWidth: columnWidth,
                              deadCellBuilder: widget.deadCellBuilder!,
                              itemBuilder: (List<CalendarEvent<T>> dayEvents) =>
                                  widget.itemBuilder!(dayEvents,
                                      Size(columnWidth, columnHeight)),
                              events: events,
                              period: Period(
                                  endTime:
                                      const TimeOfDay(hour: 12, minute: 00),
                                  title: 'asdasd',
                                  startTime:
                                      const TimeOfDay(hour: 11, minute: 00)),
                              breakHeight: controller.breakHeight,
                              cellHeight: controller.cellHeight,
                              dateTime: dateTime,
                              onTap: (DateTime date, Period period,
                                  CalendarEvent<Object?>? event) {},
                              onWillAccept: (CalendarEvent<Object?> event,
                                      Period period) =>
                                  true,
                              onAcceptWithDetails:
                                  (DragTargetDetails<CalendarEvent<Object?>>
                                      event) {});
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      });

  // bool _isSnapping = false;
  // final Duration _animationDuration = const Duration(milliseconds: 300);
  // final Curve _animationCurve = Curves.bounceOut;

  // Future<dynamic> _snapToCloset() async {
  //   if (_isSnapping || !widget.snapToDay) {
  //     return;
  //   }

  //   _isSnapping = true;
  //   await Future<dynamic>.microtask(() => null);
  //   final double snapPosition =
  //       ((_dayScrollController.offset) / columnWidth).round() * columnWidth;
  //   await _dayScrollController.animateTo(
  //     snapPosition,
  //     duration: _animationDuration,
  //     curve: _animationCurve,
  //   );
  //   await _dayHeadingScrollController.animateTo(
  //     snapPosition,
  //     duration: _animationDuration,
  //     curve: _animationCurve,
  //   );
  //   _isSnapping = false;
  // }

  // Future<dynamic> _updateVisibleDate() async {
  //   final DateTime date = controller.start.add(Duration(
  //     days: _dayHeadingScrollController.position.pixels ~/ columnWidth,
  //   ));
  //   if (date != controller.visibleDateStart) {
  //     controller.updateVisibleDate(date);
  //     setState(() {});
  //   }
  // }

  ///jump to current date
  Future<dynamic> _jumpTo(DateTime date) async {
    if (pageController.hasClients) {
      final Iterable<Month> tempMonths = monthRange.where((Month element) =>
          element.year == date.year && element.month == date.month);
      if (tempMonths.isEmpty) {
      } else {
        await pageController.animateToPage(monthRange.indexOf(tempMonths.first),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
  }
}

/// month ckass
class Month {
  ///month constructor
  Month(
      {required this.month,
      required this.monthName,
      required this.endDay,
      required this.startDay,
      required this.year});

  /// int month
  int month;

  ///int year
  int year;

  ///int startDay
  int startDay;

  ///int endDay
  int endDay;

  /// monthName
  String monthName;

  @override
  String toString() => 'Month Name $monthName Month $month StartDay $startDay'
      ' EndDay $endDay $year';
}

///calend day

class CalendarDay {
  ///
  CalendarDay({required this.dateTime, this.deadCell = false});

  ///bool is deadCell
  bool deadCell;

  ///
  /// DateTime
  DateTime dateTime;

  @override
  String toString() => 'DeadCell $deadCell' + ' DateTime: $dateTime';
}

///get month list between date
List<Month> getMonthRange(DateTime first, DateTime second) {
  DateTime date1 = first;
  final DateTime date2 = second;
  final List<Month> tempList = <Month>[];
  while (date1.isBefore(date2)) {
    tempList.add(Month(
        month: date1.month,
        startDay: 1,
        endDay: DateTime(date1.year, date1.month + 1)
            .subtract(const Duration(days: 1))
            .day,
        monthName: DateFormat('M').format(date1),
        year: date1.year));
    date1 = DateTime(date1.year, date1.month + 1);
  }
  log(tempList.toString());

  return tempList;
}

///return the dates from the list depends on the current month
List<CalendarDay> getDatesForCurrentView(
    Month month, List<Month> months, List<CalendarDay> dateRange) {
  int skip = 0;
  final List<Month> previousMonth = months
      .where((Month element) =>
          element.month < month.month && element.year <= month.year)
      .toList();

  for (final Month i in previousMonth) {
    skip = skip + i.endDay;
  }

  final List<CalendarDay> tempDate =
      dateRange.skip(skip).take(month.endDay).toList();
  if (tempDate.first.dateTime.weekday == 1) {
    final int diff = 35 - month.endDay;

    final List<CalendarDay> temList =
        dateRange.skip(skip + month.endDay).take(diff).toList();
    if (temList.length < diff) {
    } else {
      for (int i = 1; i < diff + 1; i++) {
        tempDate.add(CalendarDay(
            dateTime: tempDate.last.dateTime.add(Duration(days: i)),
            deadCell: true));
      }
    }

    return tempDate;
  } else {
    return dateRange
        .skip(skip - tempDate.first.dateTime.weekday)
        .take(45)
        .toList();
  }
}
