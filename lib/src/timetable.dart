import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

/// The [Timetable] widget displays calendar like view of the events
/// that scrolls
class Timetable<T> extends StatefulWidget {
  ///
  const Timetable({
    required this.timelines,
    Key? key,
    this.controller,
    this.cellBuilder,
    this.headerCellBuilder,
    this.items = const <TimetableItem<T>>[],
    this.itemBuilder,
    this.hourLabelBuilder,
    this.nowIndicatorColor,
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
  final List<TimetableItem<T>> items;

  /// Renders event card from `TimetableItem<T>` for each item
  final Widget Function(TimetableItem<T>)? itemBuilder;

  /// Renders hour label given [TimeOfDay] for each hour
  final Widget Function(Period period)? hourLabelBuilder;

  /// Renders upper left corner of the timetable given the first visible date
  final Widget Function(DateTime current)? cornerBuilder;

  /// Snap to hour column. Default is `true`.
  final bool snapToDay;

  /// Color of indicator line that shows the current time.
  ///  Default is `Theme.indicatorColor`.
  final Color? nowIndicatorColor;

  ///
  ///ontapt
  final Function(DateTime dateTime, Period, TimetableItem<T>?)? onTap;

  /// The [Timetable] widget displays calendar like view
  /// of the events that scrollsn

  /// list of the timeline
  final List<Period> timelines;

  /// show only mon to friday

  @override
  State<Timetable<T>> createState() => _TimetableState<T>();
}

class _TimetableState<T> extends State<Timetable<T>> {
  final ScrollController _dayScrollController = ScrollController();
  final ScrollController _dayHeadingScrollController = ScrollController();
  final ScrollController _timeScrollController = ScrollController();
  double columnWidth = 50;
  TimetableController controller = TimetableController();
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  Color get nowIndicatorColor =>
      widget.nowIndicatorColor ?? Theme.of(context).indicatorColor;
  int? _listenerId;

  @override
  void initState() {
    controller = widget.controller ?? controller;
    _listenerId = controller.addListener(_eventHandler);
    if (widget.items.isNotEmpty) {
      widget.items.sort((TimetableItem<T> a, TimetableItem<T> b) =>
          a.start.compareTo(b.start));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => adjustColumnWidth());

    super.initState();
  }

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

    if (event is TimetableColumnsChanged) {
      final DateTime prev = controller.visibleDateStart;
      final DateTime now = DateTime.now();
      await adjustColumnWidth();
      await _jumpTo(
          DateTime(prev.year, prev.month, prev.day, now.hour, now.minute));
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<dynamic> adjustColumnWidth() async {
    final RenderBox? box =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    if (box.hasSize) {
      final Size size = box.size;
      final double layoutWidth = size.width;
      final double width =
          (layoutWidth - controller.timelineWidth) / controller.columns;
      if (width != columnWidth) {
        columnWidth = width;
        await Future<dynamic>.microtask(() => null);
        setState(() {});
      }
    }
  }

  bool _isTableScrolling = false;
  bool _isHeaderScrolling = false;

  bool isTimeBefore(TimeOfDay a, TimeOfDay b) {
    // if (a.hour <= b.hour && a.minute < b.minute) {
    //   return true;
    // } else {
    //   return false;
    // }

    if (a.hour == b.hour) {
      if (a.minute < b.minute) {
        return true;
      } else {
        return false;
      }
    } else if (a.hour < b.hour) {
      return true;
    } else {
      return false;
    }
  }

  double getTopMargin(DateTime startTime) {
    log('Event Date $startTime');
    final List<Period> t = widget.timelines;
    final int ts = t
        .where((Period element) =>
            isTimeBefore(
                element.starttime,
                TimeOfDay(
                  hour: startTime.hour,
                  minute: startTime.minute,
                )) &&
            element.isBreak == false)
        .toList()
        .length;

    final int breaks = t
        .where((Period element) =>
            isTimeBefore(
                element.starttime,
                TimeOfDay(
                  hour: startTime.hour,
                  minute: startTime.minute,
                )) &&
            element.isBreak == true)
        .toList()
        .length;
    log('ts $ts breaks $breaks');
    return ts * controller.cellHeight + breaks * (controller.breakHeight);
  }

// Period getPeriod(TimetableItem item)
// {
//   if()
// }
  double getTimelineHeight() {
    double h = 0;
    for (final Period timeline in widget.timelines) {
      if (timeline.isBreak) {
        h = h + (controller.breakHeight);
      } else {
        h = h + controller.cellHeight;
      }
    }
    return h;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      key: _key,
      builder: (BuildContext context, BoxConstraints contraints) => Column(
            children: <Widget>[
              SizedBox(
                height: controller.headerHeight,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: controller.timelineWidth,
                      height: controller.headerHeight,
                      child: _buildCorner(),
                    ),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (_isTableScrolling) {
                            return false;
                          }
                          if (notification is ScrollEndNotification) {
                            _snapToCloset();
                            _updateVisibleDate();
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
                          itemBuilder: (BuildContext context, int i) {
                            final DateTime date =
                                controller.start.add(Duration(days: i));
                            if (date.weekday > 5) {
                              return const SizedBox(
                                width: 0,
                                height: 0,
                              );
                            }
                            return SizedBox(
                              width: columnWidth,
                              child: _buildHeaderCell(i),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (_isHeaderScrolling) {
                      return false;
                    }

                    if (notification is ScrollEndNotification) {
                      _snapToCloset();
                      _updateVisibleDate();
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
                      height: getTimelineHeight(),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: controller.timelineWidth,
                            height: controller.cellHeight * 24.0,
                            child: Column(
                              children: <Widget>[
                                // SizedBox(height: controller.cellHeight / 2),
                                for (Period item in widget.timelines)
                                  SizedBox(
                                    height: item.isBreak
                                        ? controller.breakHeight
                                        : controller.cellHeight,
                                    child: Center(child: _buildHour(item)),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // cacheExtent: 10000.0,
                              itemExtent: columnWidth,
                              controller: _dayScrollController,
                              itemBuilder: (BuildContext context, int index) {
                                final DateTime date =
                                    controller.start.add(Duration(days: index));
                                final List<TimetableItem<T>> events = widget
                                    .items
                                    .where((TimetableItem<T> event) =>
                                        DateUtils.isSameDay(date, event.start))
                                    .toList();
                                final DateTime now = DateTime.now();
                                final bool isToday =
                                    DateUtils.isSameDay(date, now);

                                if (date.weekday > 5) {
                                  return const SizedBox(
                                    width: 0,
                                    height: 0,
                                  );
                                }
                                return Container(
                                  width: columnWidth,
                                  height: controller.cellHeight * 24.0,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          for (Period period
                                              in widget.timelines)
                                            SizedBox(
                                              width: columnWidth,
                                              height: period.isBreak
                                                  ? controller.breakHeight
                                                  : controller.cellHeight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (widget.onTap != null) {
                                                    widget.onTap!(
                                                        date, period, null);
                                                  }
                                                },
                                                child: Center(
                                                  child: _buildCell(period),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      for (final TimetableItem<T> event
                                          in events)
                                        Positioned(
                                          // top: (event.start.hour +
                                          //         (event.start.minute / 60)) *
                                          //     controller.cellHeight,
                                          // top: controller.cellHeight,

                                          top: getTopMargin(event.start),
                                          width: columnWidth,
                                          // height: event.duration.inMinutes *
                                          //     controller.cellHeight /
                                          //     60,
                                          height: controller.cellHeight,
                                          child: GestureDetector(
                                              onTap: () {
                                                if (widget.onTap != null) {
                                                  // widget.onTap!(null, event);
                                                }
                                              },
                                              child: _buildEvent(event)),
                                        ),
                                      if (isToday)
                                        Positioned(
                                          top: ((now.hour +
                                                      (now.minute / 60.0)) *
                                                  controller.cellHeight) -
                                              1,
                                          width: columnWidth,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: <Widget>[
                                              Container(
                                                color: nowIndicatorColor,
                                                height: 2,
                                                width: columnWidth + 1,
                                              ),
                                              Positioned(
                                                top: -2,
                                                left: -2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: nowIndicatorColor,
                                                  ),
                                                  height: 6,
                                                  width: 6,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
          ));

  final DateFormat _dateFormatter = DateFormat('MMM\nd');

  Widget _buildHeaderCell(int i) {
    final DateTime date = controller.start.add(Duration(days: i));
    if (widget.headerCellBuilder != null) {
      return widget.headerCellBuilder!(date);
    }
    final FontWeight weight = DateUtils.isSameDay(date, DateTime.now()) //
        ? FontWeight.bold
        : FontWeight.normal;
    return Center(
      child: Text(
        _dateFormatter.format(date),
        style: TextStyle(fontSize: 12, fontWeight: weight),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(Period period) {
    if (widget.cellBuilder != null) {
      return widget.cellBuilder!(period);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildHour(Period period) {
    if (widget.hourLabelBuilder != null) {
      return widget.hourLabelBuilder!(period);
    }

    final TimeOfDay start = TimeOfDay(
      hour: period.starttime.hour,
      minute: period.starttime.minute,
    );

    final TimeOfDay end = TimeOfDay(
      hour: period.endTime.hour,
      minute: period.endTime.minute,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(start.format(context), style: const TextStyle(fontSize: 11)),
        Text(end.format(context), style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildCorner() {
    if (widget.cornerBuilder != null) {
      return widget.cornerBuilder!(controller.visibleDateStart);
    }
    return Center(
      child: Text(
        '${controller.visibleDateStart.year}',
        textAlign: TextAlign.center,
      ),
    );
  }

  final DateFormat _hmma = DateFormat('h:mm a');

  Widget _buildEvent(TimetableItem<T> event) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(event);
    }
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Text(
        '${_hmma.format(event.start)} - ${_hmma.format(event.end)}',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

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

  Future<dynamic> _updateVisibleDate() async {
    final DateTime date = controller.start.add(Duration(
      days: _dayHeadingScrollController.position.pixels ~/ columnWidth,
    ));
    if (date != controller.visibleDateStart) {
      controller.updateVisibleDate(date);
      setState(() {});
    }
  }

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
