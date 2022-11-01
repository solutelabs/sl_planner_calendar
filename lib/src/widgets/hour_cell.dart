import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/core/text_styles.dart';

///Hour Cell widget build the widget for the hour label
class HourCell<T> extends StatelessWidget {
  /// initialized hourCell
  const HourCell(
      {required this.controller,
      required this.period,
      this.backgroundColor = Colors.transparent,
      Key? key,
      this.hourLabelBuilder})
      : super(key: key);

  ///timetable  controller
  final TimetableController<T> controller;

  ///period of the even
  final Period period;

  /// Renders hour label given [TimeOfDay] for each hour
  final Widget Function(Period period)? hourLabelBuilder;

  ///Color background color
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final TimeOfDay start = TimeOfDay(
      hour: period.startTime.hour,
      minute: period.startTime.minute,
    );

    final TimeOfDay end = TimeOfDay(
      hour: period.endTime.hour,
      minute: period.endTime.minute,
    );
    return Container(
        color: backgroundColor,
        height: period.isCustomeSlot
            ? controller.breakHeight
            : controller.cellHeight,
        child: Center(
            child: hourLabelBuilder != null
                ? hourLabelBuilder!(period)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        start.format(context),
                        style: context.subtitle1,
                      ),
                      Text(end.format(context), style: context.subtitle1),
                    ],
                  )));
  }
}
