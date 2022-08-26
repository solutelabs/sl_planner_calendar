import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///hourcell
class HourCell extends StatelessWidget {
  ///
  const HourCell(
      {required this.controller,
      required this.period,
      Key? key,
      this.hourLabelBuilder})
      : super(key: key);

  ///timetable  controller
  final TimetableController controller;

  ///period of the even
  final Period period;

  /// Renders hour label given [TimeOfDay] for each hour
  final Widget Function(Period period)? hourLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final TimeOfDay start = TimeOfDay(
      hour: period.starttime.hour,
      minute: period.starttime.minute,
    );

    final TimeOfDay end = TimeOfDay(
      hour: period.endTime.hour,
      minute: period.endTime.minute,
    );
    return SizedBox(
        height: period.isBreak ? controller.breakHeight : controller.cellHeight,
        child: Center(
            child: hourLabelBuilder != null
                ? hourLabelBuilder!(period)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(start.format(context),
                          style: const TextStyle(fontSize: 11)),
                      Text(end.format(context),
                          style: const TextStyle(fontSize: 11)),
                    ],
                  )));
  }
}
