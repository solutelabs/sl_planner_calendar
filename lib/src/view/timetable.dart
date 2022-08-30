import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/widgets/cell.dart';
import 'package:sl_planner_calendar/src/widgets/corner_cell.dart';
import 'package:sl_planner_calendar/src/widgets/header_cell.dart';
import 'package:sl_planner_calendar/src/widgets/hour_cell.dart';
import 'package:sl_planner_calendar/src/widgets/time_indicator.dart';
import 'package:sl_planner_calendar/src/widgets/timetable_event.dart';

import '../core/app_log.dart';

/// The [SlCalendar] widget displays calendar like view of the events
/// that scrolls
class SlCalendar<T> extends StatefulWidget {
  ///
  const SlCalendar({
    required this.timelines,
    required this.onWillAccept,
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
    this.showNowIndicator = true,
    this.cornerBuilder,
    this.snapToDay = true,
    this.onTap,
  }) : super(key: key);

  /// [TimetableController] is the controller that also initialize the timetable
  final TimetableController? controller;

  /// Renders for the cells the represent each hour that provides
  /// that [DateTime] for that hour
  final Widget Function(Period)? cellBuilder;

  /// Renders for the header that provides the [DateTime] for the day
  final Widget Function(DateTime)? headerCellBuilder;

  /// Timetable items to display in the timetable
  final List<CalendarEvent<T>> items;

  /// Renders event card from `TimetableItem<T>` for each item
  final Widget Function(CalendarEvent<T>)? itemBuilder;

  /// Renders hour label given [TimeOfDay] for each hour
  final Widget Function(Period period)? hourLabelBuilder;

  /// Renders upper left corner of the timetable given the first visible date
  final Widget Function(DateTime current)? cornerBuilder;

  /// Snap to hour column. Default is `true`.
  final bool snapToDay;

  ///show now indicator,default is true
  final bool showNowIndicator;

  /// Color of indicator line that shows the current time.

  ///  Default is `Theme.indicatorColor`.
  final Color? nowIndicatorColor;

  /// Full week only

  final bool fullWeek;

  /// height  of the header
  final double headerHeight;

  ///onTap  callback
  final Function(DateTime dateTime, Period, CalendarEvent<T>?)? onTap;

  /// The [SlCalendar] widget displays calendar like view
  /// of the events that scrolls

  /// list of the timeline
  final List<Period> timelines;

  ///return new and okd event
  final Function(CalendarEvent<T> old, CalendarEvent<T> newEvent)?
      onEventDragged;

  /// Called to determine whether this widget is interested in receiving a given
  /// piece of data being dragged over this drag target.
  ///
  /// Called when a piece of data enters the target. This will be followed by
  /// either [onAccept] and [onAcceptWithDetails], if the data is dropped, or
  /// [onLeave], if the drag leaves the target.
  final DragTargetWillAccept<CalendarEvent<T>> onWillAccept;

  @override
  State<SlCalendar<T>> createState() => _SlCalendarState<T>();
}

class _SlCalendarState<T> extends State<SlCalendar<T>> {
  final ScrollController _dayScrollController = ScrollController();
  final ScrollController _dayHeadingScrollController = ScrollController();
  final ScrollController _timeScrollController = ScrollController();
  double columnWidth = 50;
  TimetableController controller = TimetableController();
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  Color get nowIndicatorColor =>
      widget.nowIndicatorColor ?? Theme.of(context).indicatorColor;
  int? _listenerId;

  List<DateTime> dateRange = <DateTime>[];

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
    appLog('Setting dates');
    final int diff = controller.end.difference(controller.start).inDays;
    dateRange.clear();
    for (int i = 0; i < diff; i++) {
      final DateTime date = controller.start.add(Duration(days: i));
      if (widget.fullWeek) {
        dateRange.add(date);
      } else {
        if (date.weekday > 5) {
        } else {
          dateRange.add(date);
        }
      }
    }
    setState(() {});
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
        dateRange.add(date);
      } else {
        if (date.weekday > 5) {
        } else {
          dateRange.add(date);
        }
      }
    }
    return tempDateRange;
  }

  ///return count of periods and break that are overLapping
  List<int> getOverLappingTimeLine(TimeOfDay start, TimeOfDay end) {
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
    _dayScrollController.dispose();
    _dayHeadingScrollController.dispose();
    _timeScrollController.dispose();
    super.dispose();
  }

  Future<void> _eventHandler(TimetableControllerEvent event) async {
    if (event is TimetableJumpToRequested) {
      await _jumpTo(event.date);
    }

    if (event is TimetableVisibleDateChanged) {
      appLog('visible data changed');
      final DateTime prev = controller.visibleDateStart;
      final DateTime now = DateTime.now();
      await adjustColumnWidth();
      await _jumpTo(
          DateTime(prev.year, prev.month, prev.day, now.hour, now.minute));
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

  bool _isTableScrolling = false;
  bool _isHeaderScrolling = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      key: _key,
      builder: (BuildContext context, BoxConstraints constraints) {
        adjustColumnWidth();
        return Column(
          children: <Widget>[
            SizedBox(
              height: widget.headerHeight,
              child: Row(
                children: <Widget>[
                  CornerCell(
                      controller: controller,
                      headerHeight: widget.headerHeight),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (_isTableScrolling) {
                          return false;
                        }
                        if (notification is ScrollEndNotification) {
                          _snapToCloset();
                          // _updateVisibleDate();
                          _isHeaderScrolling = false;
                          return true;
                        }
                        _isHeaderScrolling = true;
                        _dayScrollController.jumpTo(
                            _dayHeadingScrollController.position.pixels);
                        return false;
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _dayHeadingScrollController,
                        itemExtent: columnWidth,
                        itemCount: dateRange.length,
                        itemBuilder: (BuildContext context, int index) =>
                            HeaderCell(
                          dateTime: dateRange[index],
                          columnWidth: columnWidth,
                          headerCellBuilder: widget.headerCellBuilder,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
              height: 2,
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (_isHeaderScrolling) {
                    return false;
                  }

                  if (notification is ScrollEndNotification) {
                    _snapToCloset();

                    _isTableScrolling = false;
                    return true;
                  }
                  _isTableScrolling = true;
                  _dayHeadingScrollController
                      .jumpTo(_dayScrollController.position.pixels);
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _timeScrollController,
                  child: SizedBox(
                    height: getTimelineHeight(widget.timelines,
                        controller.cellHeight, controller.breakHeight),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: controller.timelineWidth,
                          height: controller.cellHeight * 24.0,
                          child: Column(
                            children: <Widget>[
                              // SizedBox(height: controller.cellHeight / 2),
                              for (Period item in widget.timelines)
                                HourCell(
                                  controller: controller,
                                  period: item,
                                  hourLabelBuilder: widget.hourLabelBuilder,
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // cacheExtent: 10000.0,

                            itemCount: dateRange.length,
                            itemExtent: columnWidth,
                            controller: _dayScrollController,
                            itemBuilder: (BuildContext context, int index) {
                              final DateTime date = dateRange[index];
                              final List<CalendarEvent<T>> events = widget.items
                                  .where((CalendarEvent<T> event) =>
                                      DateUtils.isSameDay(
                                          date, event.startTime))
                                  .toList();
                              final DateTime now = DateTime.now();
                              final bool isToday =
                                  DateUtils.isSameDay(date, now);

                              return Container(
                                width: columnWidth,
                                height: controller.cellHeight * 24.0,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        for (Period period in widget.timelines)
                                          TimeTableCell<T>(
                                            columnWidth: columnWidth,
                                            period: period,
                                            breakHeight: controller.breakHeight,
                                            cellHeight: controller.cellHeight,
                                            dateTime: date,
                                            onTap: (DateTime dateTime,
                                                Period p1,
                                                CalendarEvent<T>? p2) {
                                              appLog('data');
                                              widget.onTap!(dateTime, p1, p2);
                                            },
                                            onAcceptWithDetails:
                                                (DragTargetDetails<
                                                        CalendarEvent<T>>
                                                    details) {
                                              appLog(
                                                  'New period:${period.toMap}');
                                              appLog('Dragged event'
                                                  '${details.data.toMap}');
                                              final CalendarEvent<T> event =
                                                  details.data;
                                              final DateTime newStartTime =
                                                  DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      period.startTime.hour,
                                                      period.startTime.minute);
                                              final DateTime newEndTime =
                                                  DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      period.endTime.hour,
                                                      period.endTime.minute);

                                              final CalendarEvent<T> newEvent =
                                                  CalendarEvent<T>(
                                                      startTime: newStartTime,
                                                      endTime: newEndTime,
                                                      eventData:
                                                          event.eventData);

                                              widget.onEventDragged!(
                                                  details.data, newEvent);
                                            },
                                            onWillAccept:
                                                (CalendarEvent<T>? data,
                                                        Period period) =>
                                                    isSlotIsAvailable(
                                                        events, data!, period),
                                          )
                                      ],
                                    ),
                                    for (final CalendarEvent<T> event in events)
                                      Positioned(
                                        width: columnWidth,
                                        top: getEventMarginFromTop(
                                            widget.timelines,
                                            controller.cellHeight,
                                            controller.breakHeight,
                                            event.startTime),
                                        bottom: getEventMarginFromBottom(
                                            widget.timelines,
                                            controller.cellHeight,
                                            controller.breakHeight,
                                            event.endTime),
                                        child: TimeTableEvent<T>(
                                          onAcceptWithDetails:
                                              (DragTargetDetails<
                                                      CalendarEvent<T>>
                                                  details) {
                                            appLog(
                                                details.data.toMap.toString());
                                            final CalendarEvent<T> myEvents =
                                                details.data;
                                            final DateTime newStartTime =
                                                DateTime(
                                                    date.year,
                                                    date.month,
                                                    date.day,
                                                    event.startTime.hour,
                                                    event.startTime.minute);
                                            final DateTime newEndTime =
                                                DateTime(
                                                    date.year,
                                                    date.month,
                                                    date.day,
                                                    event.endTime.hour,
                                                    event.endTime.minute);
                                            myEvents
                                              ..startTime = newStartTime
                                              ..endTime = newEndTime;
                                            widget.onEventDragged!(
                                                details.data, myEvents);
                                          },
                                          onWillAccept:
                                              (CalendarEvent<T>? data) => false,
                                          columnWidth: columnWidth,
                                          event: event,
                                          itemBuilder: widget.itemBuilder,
                                        ),
                                      ),
                                    if (widget.showNowIndicator && isToday)
                                      StreamBuilder<DateTime>(
                                          stream: Stream<DateTime>.periodic(
                                              const Duration(seconds: 60),
                                              (int count) => DateTime.now().add(
                                                  const Duration(minutes: 1))),
                                          builder: (BuildContext context,
                                                  AsyncSnapshot<DateTime>
                                                      snapshot) =>
                                              TimeIndicator(
                                                  controller: controller,
                                                  columnWidth: columnWidth,
                                                  nowIndicatorColor:
                                                      nowIndicatorColor,
                                                  timelines: widget.timelines)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });

  bool _isSnapping = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.bounceOut;

  Future<dynamic> _snapToCloset() async {
    if (_isSnapping || !widget.snapToDay) {
      return;
    }

    _isSnapping = true;
    await Future<dynamic>.microtask(() => null);
    final double snapPosition =
        ((_dayScrollController.offset) / columnWidth).round() * columnWidth;
    await _dayScrollController.animateTo(
      snapPosition,
      duration: _animationDuration,
      curve: _animationCurve,
    );
    await _dayHeadingScrollController.animateTo(
      snapPosition,
      duration: _animationDuration,
      curve: _animationCurve,
    );
    _isSnapping = false;
  }

  // Future<dynamic> _updateVisibleDate() async {
  //   final DateTime date = controller.start.add(Duration(
  //     days: _dayHeadingScrollController.position.pixels ~/ columnWidth,
  //   ));
  //   if (date != controller.visibleDateStart) {
  //     controller.updateVisibleDate(date);
  //     setState(() {});
  //   }
  // }

  Future<dynamic> _jumpTo(DateTime date) async {
    final double datePosition =
        (date.difference(controller.start).inDays) * columnWidth;
    final double hourPosition =
        ((date.hour) * controller.cellHeight) - (controller.cellHeight / 2);
    await Future.wait<void>(<Future<void>>[
      _dayScrollController.animateTo(
        datePosition,
        duration: _animationDuration,
        curve: _animationCurve,
      ),
      _timeScrollController.animateTo(
        hourPosition,
        duration: _animationDuration,
        curve: _animationCurve,
      ),
    ]);
  }
}
