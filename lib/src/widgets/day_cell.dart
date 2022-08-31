import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/core/app_log.dart';

///DayCell for month and term view
class DayCell<T> extends StatelessWidget {
  ///
  const DayCell({
    required this.columnWidth,
    required this.period,
    required this.breakHeight,
    required this.cellHeight,
    required this.dateTime,
    required this.onTap,
    required this.onWillAccept,
    required this.onAcceptWithDetails,
    required this.calendarDay,
    required this.deadCellBuilder,
    this.isDragable = false,
    this.events,
    this.itemBuilder,
    this.onAccept,
    this.onLeave,
    this.onMove,
    this.cellBuilder,
    Key? key,
  }) : super(key: key);

  /// Renders for the cells the represent each hour that provides
  /// that [DateTime] for that hour
  final Widget Function(Period)? cellBuilder;

  ///column Width
  final double columnWidth;

  ///period
  final Period period;

  ///DateTime date
  final DateTime dateTime;

  ///breakHeight
  final double breakHeight;

  ///cellHeight
  final double cellHeight;

  ///onTap callback function
  final Function(DateTime dateTime, Period, CalendarEvent<T>?)? onTap;

  /// Called when an acceptable piece of data was dropped over this drag target.
  ///
  /// Equivalent to [onAccept], but with information, including the data, in a
  /// [DragTargetDetails].
  final DragTargetAcceptWithDetails<CalendarEvent<T>> onAcceptWithDetails;

  /// Called to determine whether this widget is interested in receiving a given
  /// piece of data being dragged over this drag target.
  ///
  /// Called when a piece of data enters the target. This will be followed by
  /// either [onAccept] and [onAcceptWithDetails], if the data is dropped, or
  /// [onLeave], if the drag leaves the target.
  final Function(CalendarEvent<T>, Period) onWillAccept;

  /// Called when an acceptable piece of data was dropped over this drag target.
  ///
  /// Equivalent to [onAcceptWithDetails], but only includes the data.
  final DragTargetAccept<T>? onAccept;

  /// Called when a given piece of data being dragged over this target leaves
  /// the target.
  final DragTargetLeave<T>? onLeave;

  /// Called when a [Draggable] moves within this [DragTarget].
  ///
  /// Note that this includes entering and leaving the target.
  final DragTargetMove<T>? onMove;

  /// Renders event card from `TimetableItem<T>` for each item
  final Widget Function(
    List<CalendarEvent<T>>,
  )? itemBuilder;

  ///rend card for cell that we added extra in the current view

  ///list of the eent for day
  final List<CalendarEvent<T>>? events;

  ///bool isDragable

  final bool isDragable;

  ///calendar day
  final CalendarDay calendarDay;

  /// Renders upper left corner of the timetable given the first visible date
  final Widget Function(DateTime current) deadCellBuilder;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          appLog('OnTap');
          onTap!(dateTime, period, null);
        },
        child: isDragable
            ? DragTarget<CalendarEvent<T>>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) =>
                    SizedBox(
                  width: columnWidth,
                  height: period.isBreak ? breakHeight : cellHeight,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 6,
                          right: 6,
                          child: Text(dateTime.day.toString())),
                      GestureDetector(
                        onTap: () {
                          appLog('onTap');
                          onTap!(dateTime, period, null);
                        },
                        child: Center(
                          child: cellBuilder != null
                              ? cellBuilder!(period)
                              : Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                onAcceptWithDetails: onAcceptWithDetails,
                onWillAccept: (CalendarEvent<T>? data) {
                  appLog('Cell  Dragged:${data!.toMap}');
                  return onWillAccept(data, period);
                },
                onAccept: (CalendarEvent<T> data) {
                  appLog(data.toMap.toString());
                },
                onLeave: (CalendarEvent<T>? value) {},
                onMove: (DragTargetDetails<CalendarEvent<T>> value) {},
              )
            : SizedBox(
                width: columnWidth,
                height: cellHeight,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 6,
                        right: 6,
                        child: Text(
                          dateTime.day.toString(),
                          style: TextStyle(
                              color: calendarDay.deadCell
                                  ? Colors.red
                                  : Colors.black),
                        )),
                    GestureDetector(
                      onTap: () {
                        appLog('onTap');
                        onTap!(dateTime, period, null);
                      },
                      child: Center(
                        child: calendarDay.deadCell
                            ? deadCellBuilder(calendarDay.dateTime)
                            : cellBuilder != null
                                ? cellBuilder!(period)
                                : Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(child: itemBuilder!(events!))
                  ],
                )),
      );
}
