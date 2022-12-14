import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///
class CornerCell extends StatelessWidget {
  ///
  const CornerCell(
      {required this.controller,
      required this.headerHeight,
      this.cornerBuilder,
      Key? key})
      : super(key: key);

  ///header height
  final double headerHeight;

  /// Renders upper left corner of the timetable given the first visible date
  final Widget Function(DateTime current)? cornerBuilder;

  ///timetable controller
  final TimetableController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: controller.timelineWidth,
        height: headerHeight,
        child: cornerBuilder != null
            ? cornerBuilder!(controller.visibleDateStart)
            : Center(
                child: Text(
                  '${controller.visibleDateStart.year}',
                  textAlign: TextAlign.center,
                ),
              ),
      );
}
