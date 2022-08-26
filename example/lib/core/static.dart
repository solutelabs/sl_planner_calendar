import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///period of the event
List<Period> periodsForEvent = <Period>[
  Period(
      starttime: const TimeOfDay(hour: 9, minute: 30),
      endTime: const TimeOfDay(hour: 9, minute: 45)),
  Period(
      starttime: const TimeOfDay(hour: 9, minute: 45),
      endTime: const TimeOfDay(hour: 10, minute: 30)),
  Period(
      starttime: const TimeOfDay(hour: 9, minute: 45),
      endTime: const TimeOfDay(hour: 10, minute: 30)),
  Period(
      starttime: const TimeOfDay(hour: 13, minute: 30),
      endTime: const TimeOfDay(hour: 14, minute: 45)),
  Period(
      starttime: const TimeOfDay(hour: 9, minute: 30),
      endTime: const TimeOfDay(hour: 1, minute: 30)),
  Period(
      starttime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 45)),
  Period(
      starttime: const TimeOfDay(hour: 13, minute: 30),
      endTime: const TimeOfDay(hour: 15, minute: 00)),
  Period(
      starttime: const TimeOfDay(hour: 13, minute: 30),
      endTime: const TimeOfDay(hour: 15, minute: 00)),
  Period(
      starttime: const TimeOfDay(hour: 11, minute: 30),
      endTime: const TimeOfDay(hour: 12, minute: 30)),
  Period(
      starttime: const TimeOfDay(hour: 13, minute: 30),
      endTime: const TimeOfDay(hour: 14, minute: 15)),
];

///timetable events
List<CalendarEvent<Event>> dummyEvents = <CalendarEvent<Event>>[
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day, 9, 30),
      endTime: DateTime(now.year, now.month, now.day, 9, 45),
      eventData: Event(
          title: 'Lession 1, This is testing for longer title',
          period: Period(
              starttime: const TimeOfDay(hour: 9, minute: 30),
              endTime: const TimeOfDay(hour: 9, minute: 45)),
          description: 'Description 1sdasdasd asdasdasdsd asdasd asds sd',
          color: const Color(0xFF123CBB).withOpacity(0.30),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day, 9, 45),
      endTime: DateTime(now.year, now.month, now.day, 10, 30),
      eventData: Event(
          title: 'Lession 2',
          period: Period(
              starttime: const TimeOfDay(hour: 9, minute: 45),
              endTime: const TimeOfDay(hour: 10, minute: 30)),
          description: 'Description 2',
          color: const Color(0xFFF2A93B).withOpacity(0.60),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day, 11),
      endTime: DateTime(now.year, now.month, now.day, 11, 45),
      eventData: Event(
          title: 'Lession 3',
          period: Period(
              starttime: const TimeOfDay(hour: 9, minute: 45),
              endTime: const TimeOfDay(hour: 10, minute: 30)),
          description: 'Description 3',
          color: const Color(0xFF8CC1DA),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day, 13, 30),
      endTime: DateTime(now.year, now.month, now.day, 14, 15),
      eventData: Event(
          title: 'Lession 4',
          period: Period(
              starttime: const TimeOfDay(hour: 13, minute: 30),
              endTime: const TimeOfDay(hour: 14, minute: 45)),
          description: 'Description 4',
          color: const Color(0xFFE697A9),
          documents: <String>['documents.pdf'])),

  //second column
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 1, 9, 30),
      endTime: DateTime(now.year, now.month, now.day + 1, 10, 30),
      eventData: Event(
          title: 'Lession 5',
          period: Period(
              starttime: const TimeOfDay(hour: 9, minute: 30),
              endTime: const TimeOfDay(hour: 1, minute: 30)),
          description: 'Description 5',
          color: const Color(0xFF123CBB).withOpacity(0.30),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 1, 11),
      endTime: DateTime(now.year, now.month, now.day + 1, 11, 45),
      eventData: Event(
          title: 'Lession 6',
          period: Period(
              starttime: const TimeOfDay(hour: 11, minute: 0),
              endTime: const TimeOfDay(hour: 11, minute: 45)),
          description: 'Description 6',
          color: const Color(0xFFF2A93B).withOpacity(0.60),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 1, 13, 52),
      endTime: DateTime(now.year, now.month, now.day + 1, 15),
      eventData: Event(
          title: 'Free Time',
          freeTime: true,
          period: Period(
              starttime: const TimeOfDay(hour: 13, minute: 52),
              endTime: const TimeOfDay(hour: 15, minute: 00)),
          description: 'Description 7',
          color: const Color(0xFFCBCE42).withOpacity(0.5),
          documents: <String>['documents.pdf'])),

  ///third column
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 2, 9, 45),
      endTime: DateTime(now.year, now.month, now.day + 2, 10, 30),
      eventData: Event(
          title: 'Lession 8',
          period: Period(
              starttime: const TimeOfDay(hour: 13, minute: 30),
              endTime: const TimeOfDay(hour: 15, minute: 00)),
          description: 'Description 8',
          color: const Color(0xFF52B5D7).withOpacity(0.5),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 2, 11),
      endTime: DateTime(now.year, now.month, now.day + 2, 12, 08),
      eventData: Event(
          title: 'Free Time',
          freeTime: true,
          period: Period(
              starttime: const TimeOfDay(hour: 11, minute: 30),
              endTime: const TimeOfDay(hour: 12, minute: 30)),
          description: 'Description 9',
          color: const Color(0xFFCBCE42).withOpacity(0.5),
          documents: <String>['documents.pdf'])),
  CalendarEvent<Event>(
      startTime: DateTime(now.year, now.month, now.day + 2, 13, 30),
      endTime: DateTime(now.year, now.month, now.day + 2, 14, 15),
      eventData: Event(
          title: 'Lession 10',
          period: Period(
              starttime: const TimeOfDay(hour: 13, minute: 30),
              endTime: const TimeOfDay(hour: 14, minute: 15)),
          description: 'Description 10',
          color: const Color(0xFF52B5D7).withOpacity(0.5),
          documents: <String>['documents.pdf']))
];
