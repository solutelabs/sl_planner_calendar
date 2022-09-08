 
import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///return formatted tine
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

///return dayName for the index

String getWeekDay(int index) {
  switch (index) {
    case 0:
      return 'Monday';
    case 1:
      return 'Tuesday';
    case 2:
      return 'Wednesday';
    case 3:
      return 'Thursday';
    case 4:
      return 'Friday';
    case 5:
      return 'Saturday';
    case 6:
      return 'Sunday';
    default:
      return 'Day';
  }
}