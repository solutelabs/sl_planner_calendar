import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:sl_planner_calendar/src/core/app_log.dart';

///check if give time is before or not
bool isTimeBefore(TimeOfDay a, TimeOfDay b) {
  final DateTime dateA = DateTime(2002, 12, 2, a.hour, a.minute);
  final DateTime dateB = DateTime(2002, 12, 2, b.hour, b.minute);
  return dateA.isBefore(dateB);
}

///get top Margin for cell

double getTopMargin(DateTime startTime, List<Period> timelines,
    double cellHeight, double breakHeight) {
  appLog('Event Date $startTime');
  final List<Period> t = timelines;
  final int ts = t
      .where((Period element) =>
          isTimeBefore(
              element.startTime,
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
              element.startTime,
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
              element.startTime,
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
              element.startTime,
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

///get total timeline height
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

///get top margin for now TimeIndicator
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
          DateTime(now.year, now.month, now.day, element.startTime.hour,
              element.startTime.minute),
          DateTime(now.year, now.month, now.day, element.endTime.hour,
              element.endTime.minute),
          now))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.startTime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = now.difference(DateTime(now.year, now.month,
        now.day, time.startTime.hour, time.startTime.minute));

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
          DateTime(start.year, start.month, start.day, element.startTime.hour,
              element.startTime.minute),
          DateTime(start.year, start.month, start.day, element.endTime.hour,
              element.endTime.minute),
          start))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.startTime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = start.difference(DateTime(start.year, start.month,
        start.day, time.startTime.hour, time.startTime.minute));

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
          DateTime(start.year, start.month, start.day, element.startTime.hour,
              element.startTime.minute),
          DateTime(start.year, start.month, start.day, element.endTime.hour,
              element.endTime.minute),
          start))
      .toList();

  if (times.isNotEmpty) {
    final Period time = times.first;
    appLog('Period during current time${time.toMap}');

    appLog('Total top margin:$total');
    final Duration d = diffTime(time.endTime, time.startTime);

    appLog('Duration of the period:${d.inMinutes}');
    final double rm =
        time.isBreak ? (breakHeight / d.inMinutes) : (cellHeight / d.inMinutes);
    appLog('size of the minute:$rm');
    final Duration duration = start.difference(DateTime(start.year, start.month,
        start.day, time.startTime.hour, time.startTime.minute));

    appLog('Duration from start to now ${duration.inMinutes}');
    total = total + rm * duration.inMinutes;
    return totalHeightOfThePlanner - total;
  } else {
    return totalHeightOfThePlanner - total;
  }
}

///difference between teo TimeOfDay

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

///hh:mm format
final DateFormat dateFormat = DateFormat('h:mm a');

///return true if given slot is empty  in events
bool isSlotIsAvailable(List<CalendarEvent<dynamic>> events,
    CalendarEvent<dynamic> event, Period period) {
  final List<CalendarEvent<dynamic>> oveLappingEvents = events
      .where((CalendarEvent<dynamic> element) =>
          !isTimeIsEqualOrMore(
              element.startTime,
              DateTime(2000, 1, 1, period.startTime.hour,
                  period.startTime.minute)) &&
          isTimeIsEqualOrLess(element.endTime,
              DateTime(2000, 1, 1, period.endTime.hour, period.endTime.minute)))
      .toList();
  if (oveLappingEvents.isEmpty) {
    appLog('Slot available: ${event.toMap}', show: true);
    return true;
  } else {
    appLog('Slot Not available: ${event.toMap}', show: true);

    return false;
  }
}

///return true if given date is less or qual
bool isTimeIsEqualOrLess(DateTime first, DateTime seconds) {
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

///return true if give date is more ore equal
bool isTimeIsEqualOrMore(DateTime first, DateTime seconds) {
  if (first.hour >= seconds.hour) {
    if (first.minute >= seconds.minute) {
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

///is available for the drag

bool isSlotAvlForSingleDay(List<CalendarEvent<dynamic>> myEvents,
    CalendarEvent<dynamic> draggedEvent, DateTime dateTime, Period period) {
  final List<CalendarEvent<dynamic>> events = myEvents
      .where((CalendarEvent<dynamic> event) =>
          DateUtils.isSameDay(dateTime, event.startTime))
      .toList();
  final List<CalendarEvent<dynamic>> overLappingEvents =
      <CalendarEvent<dynamic>>[];

  for (final CalendarEvent<dynamic> event in events) {
    if (isTimeIsEqualOrMore(
            event.startTime,
            DateTime(
                2000, 1, 1, period.startTime.hour, period.startTime.minute)) &&
        isTimeIsEqualOrLess(event.endTime,
            DateTime(2000, 1, 1, period.endTime.hour, period.endTime.minute))) {
      overLappingEvents.add(event);
    }
  }

  if (overLappingEvents.isEmpty) {
    return true;
  } else {
    appLog(overLappingEvents.toString());

    return false;
  }
}

///get month list between date
List<Month> getMonthRange(DateTime first, DateTime second) {
  DateTime date1 = first;
  final DateTime date2 = second;
  final List<Month> tempList = <Month>[];
  while (date1.isBefore(date2)) {
    tempList.add(Month(
        month: date1.month,
        startDay: 1,
        endDay: DateTime(date1.year, date1.month + 1)
            .subtract(const Duration(days: 1))
            .day,
        monthName: DateFormat('M').format(date1),
        year: date1.year));
    date1 = DateTime(date1.year, date1.month + 1);
  }
  log(tempList.toString());

  return tempList;
}

///get dates for current month

List<CalendarDay> getDatesForMonth(
    Month month, List<Month> months, List<CalendarDay> dateRange) {
  int skip = 0;
  final List<Month> previousMonth = months
      .where((Month element) =>
          element.month < month.month && element.year <= month.year)
      .toList();

  for (final Month i in previousMonth) {
    skip = skip + i.endDay;
  }

  return dateRange.skip(skip).take(month.endDay).toList();
}

///return the dates from the list depends on the current month
List<CalendarDay> getDatesForCurrentView(
    Month month, List<Month> months, List<CalendarDay> dateRange) {
  int skip = 0;
  final List<Month> previousMonth = months
      .where((Month element) =>
          element.month < month.month && element.year <= month.year)
      .toList();

  for (final Month i in previousMonth) {
    skip = skip + i.endDay;
  }

  final List<CalendarDay> tempDate =
      dateRange.skip(skip).take(month.endDay).toList();
  if (tempDate.first.dateTime.weekday == 1) {
    final int diff = 35 - month.endDay;

    final List<CalendarDay> temList =
        dateRange.skip(skip + month.endDay).take(diff).toList();
    if (temList.length < diff) {
      for (final CalendarDay element in temList) {
        tempDate.add(CalendarDay(dateTime: element.dateTime, deadCell: true));
      }
      final int newDif = diff - temList.length;
      for (int i = 1; i < newDif + 1; i++) {
        tempDate.add(CalendarDay(
            dateTime: tempDate.last.dateTime.add(const Duration(days: 1)),
            deadCell: true));
      }
    } else {
      for (final CalendarDay element in temList) {
        tempDate.add(CalendarDay(dateTime: element.dateTime, deadCell: true));
      }
    }

    return tempDate;
  } else {
    final int negativeDiff = 7 - tempDate.first.dateTime.weekday;

    for (int i = 1; i <= negativeDiff; i++) {
      tempDate.insert(
          0,
          CalendarDay(
              dateTime:
                  tempDate.first.dateTime.subtract(const Duration(days: 1)),
              deadCell: true));
    }
    final int diff = 35 - tempDate.length;

    final List<CalendarDay> temList =
        dateRange.skip(skip + month.endDay).take(diff).toList();
    if (temList.length < diff) {
      for (final CalendarDay element in temList) {
        tempDate.add(CalendarDay(dateTime: element.dateTime, deadCell: true));
      }
      final int newDif = diff - temList.length;
      for (int i = 1; i < newDif + 1; i++) {
        tempDate.add(CalendarDay(
            dateTime: tempDate.last.dateTime.add(const Duration(days: 1)),
            deadCell: true));
      }
    } else {
      for (final CalendarDay element in temList) {
        tempDate.add(CalendarDay(dateTime: element.dateTime, deadCell: true));
      }
    }
  }
  return tempDate;
}

///add extra date at start end end

List<CalendarDay> addPaddingDate(List<CalendarDay> myDateRange) {
  final List<CalendarDay> dateRange = myDateRange;
  final DateTime firstDay = dateRange.first.dateTime;
  if (firstDay.weekday == 1) {
    log('first day is monday');
  } else {
    log('First day is${firstDay.weekday}');
    final int diff = 7 - firstDay.weekday;
    log('Negative diff is $diff');

    for (int i = 1; i < firstDay.weekday; i++) {
      dateRange.insert(
          0,
          CalendarDay(
              deadCell: true, dateTime: firstDay.subtract(Duration(days: i))));
    }
  }
  final DateTime lastDay = dateRange.last.dateTime;
  if (lastDay.weekday == 7) {
    log('lazy day is sunday');
  } else {
    final int diff = 7 - lastDay.weekday;

    for (int i = 1; i <= diff; i++) {
      dateRange.add(CalendarDay(
          deadCell: true, dateTime: lastDay.add(Duration(days: i))));
    }
  }
  return dateRange;
}

///.convert string to TimeOfTheDay
TimeOfDay parseTimeOfDay(String t) {
  final DateTime dateTime = DateFormat('HH:mm').parse(t);
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}
