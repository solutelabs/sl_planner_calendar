import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/core/applog.dart';

import '../../sl_planner_calendar.dart';

///check if give time is before or not
bool isTimeBefore(TimeOfDay a, TimeOfDay b) {
  final DateTime dateA = DateTime(2002, 12, 2, a.hour, a.minute);
  final DateTime dateB = DateTime(2002, 12, 2, b.hour, b.minute);
  return dateA.isBefore(dateB);
}

///get top Margin for celll

double getTopMargin(DateTime startTime, List<Period> timelines,
    double cellHeight, double breakHeight) {
  appLog('Event Date $startTime');
  final List<Period> t = timelines;
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
  appLog('ts $ts breaks $breaks');
  return ts * cellHeight + breaks * breakHeight;
}

///get bottom margin of the event
double getBottomMargin(DateTime startTime, List<Period> timelines,
    double cellHeight, double breakHeight) {
  appLog('Event Date $startTime');
  final List<Period> t = timelines;
  final int ts = t
      .where((Period element) =>
          !isTimeBefore(
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
          !isTimeBefore(
              element.starttime,
              TimeOfDay(
                hour: startTime.hour,
                minute: startTime.minute,
              )) &&
          element.isBreak == true)
      .toList()
      .length;
  appLog('ts $ts breaks $breaks');
  return ts * cellHeight + breaks * breakHeight;
}

///get total timelin

double getTimelineHeight(
    List<Period> timelines, double cellHeight, double breakHeight) {
  double h = 0;
  for (final Period timeline in timelines) {
    if (timeline.isBreak) {
      h = h + breakHeight;
    } else {
      h = h + cellHeight;
    }
  }
  return h;
}

///get top margin for nowTimeindicator
double getTimeIndicatorFromTop(
    List<Period> timelines, double cellHeight, double breakHeight) {
  final DateTime now = DateTime.now();
  final List<Period> t = timelines;
  final List<Period> ts = t
      .where((Period element) =>
          DateTime(now.year, now.month, now.day, element.endTime.hour,
                  element.endTime.minute)
              .isAtSameMomentAs(now) ||
          isTimeBefore(
              element.endTime,
              TimeOfDay(
                hour: now.hour,
                minute: now.minute,
              )))
      .toList();

  appLog('No  of periods before current time:${ts.length}');
  double total = 0;
  for (final Period item in ts) {
    total = total + (item.isBreak ? breakHeight : cellHeight);
  }
  final List<Period> times = t
      .where((Period element) => isDateBeetWeen(
          DateTime(now.year, now.month, now.day, element.starttime.hour,
              element.starttime.minute),
          DateTime(now.year, now.month, now.day, element.endTime.hour,
              element.endTime.minute),
          now))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.starttime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = now.difference(DateTime(now.year, now.month,
        now.day, time.starttime.hour, time.starttime.minute));

    appLog('Duration from start to now ${duration.inMinutes}');
    return total = total + rm * duration.inMinutes;
  } else {
    return total;
  }
}

///get top margin for event
double getEventMarginFromTop(List<Period> timelines, double cellHeight,
    double breakHeight, DateTime start) {
  final List<Period> t = timelines;
  final List<Period> ts = t
      .where((Period element) =>
          DateTime(start.year, start.month, start.day, element.endTime.hour,
                  element.endTime.minute)
              .isAtSameMomentAs(start) ||
          isTimeBefore(
              element.endTime,
              TimeOfDay(
                hour: start.hour,
                minute: start.minute,
              )))
      .toList();

  appLog('No  of periods before current time:${ts.length}');
  double total = 0;
  for (final Period item in ts) {
    total = total + (item.isBreak ? breakHeight : cellHeight);
  }
  final List<Period> times = t
      .where((Period element) => isDateBeetWeen(
          DateTime(start.year, start.month, start.day, element.starttime.hour,
              element.starttime.minute),
          DateTime(start.year, start.month, start.day, element.endTime.hour,
              element.endTime.minute),
          start))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.starttime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = start.difference(DateTime(start.year, start.month,
        start.day, time.starttime.hour, time.starttime.minute));

    appLog('Duration from start to now ${duration.inMinutes}');
    return total = total + rm * duration.inMinutes;
  } else {
    return total;
  }
}

///get top margin for event
double getEventMarginFromBottom(List<Period> timelines, double cellHeight,
    double breakHeight, DateTime start) {
  double totalHeightOfThePlanner = 0;
  for (final Period p in timelines) {
    totalHeightOfThePlanner =
        totalHeightOfThePlanner + (p.isBreak ? breakHeight : cellHeight);
  }
  final List<Period> t = timelines;
  final List<Period> ts = t
      .where((Period element) =>
          DateTime(start.year, start.month, start.day, element.endTime.hour,
                  element.endTime.minute)
              .isAtSameMomentAs(start) ||
          isTimeBefore(
              element.endTime,
              TimeOfDay(
                hour: start.hour,
                minute: start.minute,
              )))
      .toList();

  appLog('No  of periods before current time:${ts.length}');
  double total = 0;
  for (final Period item in ts) {
    total = total + (item.isBreak ? breakHeight : cellHeight);
  }
  final List<Period> times = t
      .where((Period element) => isDateBeetWeen(
          DateTime(start.year, start.month, start.day, element.starttime.hour,
              element.starttime.minute),
          DateTime(start.year, start.month, start.day, element.endTime.hour,
              element.endTime.minute),
          start))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.starttime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = start.difference(DateTime(start.year, start.month,
        start.day, time.starttime.hour, time.starttime.minute));

    appLog('Duration from start to now ${duration.inMinutes}');
    total = total + rm * duration.inMinutes;
    return totalHeightOfThePlanner - total;
  } else {
    return totalHeightOfThePlanner - total;
  }
}

///diffrence between teo TimeOfDay

Duration diffTime(TimeOfDay end, TimeOfDay start) {
  final DateTime e = DateTime(2000, 12, 2, end.hour, end.minute);
  final DateTime s = DateTime(2000, 12, 2, start.hour, start.minute);
  return e.difference(s);
}

///return true if given date is between given range
bool isDateBeetWeen(DateTime first, DateTime last, DateTime currentDate) {
  if (first.isBefore(currentDate) && last.isAfter(currentDate)) {
    return true;
  } else {
    return false;
  }
}

///hh:mm fformat
final DateFormat hmma = DateFormat('h:mm a');

///return true if given slot is empty  in events
bool isSlotIsAvailable(
    List<CalendarEvent<dynamic>> events, CalendarEvent<dynamic> event) {
  final List<CalendarEvent<dynamic>> ovelapingEvents = events
      .where((CalendarEvent<dynamic> element) =>
          !isTimeisEqualOrLess(element.startTime, event.startTime) &&
          isTimeisEqualOrLess(element.endTime, event.endTime))
      .toList();
  if (ovelapingEvents.isEmpty) {
    appLog('Slot available: ${event.toMap}', show: true);
    return true;
  } else {
    appLog('Slot Not available: ${event.toMap}', show: true);

    return false;
  }
}

///retur true if given date is less or qual
bool isTimeisEqualOrLess(DateTime first, DateTime seconds) {
  if (first.hour <= seconds.hour) {
    if (first.minute <= seconds.minute) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

///return true if date is same
bool isSameDate(DateTime date) {
  final DateTime now = DateTime.now();
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return true;
  } else {
    return false;
  }
}

bool isSloatAvailableForTheDrag(List<CalendarEvent<dynamic>> myEvents,
    CalendarEvent<dynamic> draggedEvent, DateTime dateTime) {
  final List<CalendarEvent<dynamic>> events = myEvents
      .where((CalendarEvent<dynamic> event) =>
          DateUtils.isSameDay(dateTime, event.startTime))
      .toList();
  final List<CalendarEvent<dynamic>> ovelapingEvents = events
      .where((CalendarEvent<dynamic> element) =>
          !isTimeisEqualOrLess(element.startTime, draggedEvent.startTime) &&
          isTimeisEqualOrLess(element.endTime, draggedEvent.endTime))
      .toList();
  if (ovelapingEvents.isEmpty) {
    log('Slot available: ${draggedEvent.toMap}');
    return true;
  } else {
    log('Slot Not available-> Start Time: '
        '${ovelapingEvents.first.startTime}'
        'End Time: ${ovelapingEvents.first.endTime}');

    return false;
  }
}
