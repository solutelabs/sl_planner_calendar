import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///return formatted time
String getFormattedTime(Period period, BuildContext context) =>
    '${period.startTime.format(context)}'
    ' - ${period.endTime.format(context)}';

///return true if date is same
bool isSameDate(DateTime date) {
  final DateTime now = DateTime.now();
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return true;
  } else {
    return false;
  }
}
