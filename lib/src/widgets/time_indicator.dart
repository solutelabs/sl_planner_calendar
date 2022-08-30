import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

/// Current time indicator widget
class TimeIndicator extends StatelessWidget {
  ///time indicator
  const TimeIndicator({
    required this.controller,
    required this.columnWidth,
    required this.nowIndicatorColor,
    required this.timelines,
    Key? key,
  }) : super(key: key);

  ///timetable controller
  final TimetableController controller;

  ///column width
  final double columnWidth;

  ///color of the indicator
  final Color nowIndicatorColor;

  /// timeline of the calendar
  final List<Period> timelines;

  @override
  Widget build(BuildContext context) => Positioned(
        top: getTimeIndicatorFromTop(
            timelines, controller.cellHeight, controller.breakHeight),
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
                    shape: BoxShape.circle, color: nowIndicatorColor),
                height: 6,
                width: 6,
              ),
            ),
          ],
        ),
      );
}
