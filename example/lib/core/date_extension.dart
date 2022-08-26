import 'package:flutter/material.dart';

///datetime extension
extension DateTimeExtension on DateTime {
  ///firstday of week
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  ///last day of week
  DateTime get lastDayOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  ///last day of month
  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  ///datetime from the timeofday
  static DateTime fromTimeOfDay(TimeOfDay time) {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
}
