import 'package:bloc/bloc.dart';
import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/bloc/event_state.dart';
import 'package:example/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///
class EventCubit extends Cubit<EventState> {
  ///
  EventCubit() : super(InitialState()) {
    getEvents();
  }

  ///
  List<TimetableItem<Event>> get events => _events;

  ///
  List<TimetableItem<Event>> _events = <TimetableItem<Event>>[];

  ///
  Future<void> getEvents() async {
    try {
      emit(LoadingState());
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      _events = <TimetableItem<Event>>[
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 9, 30),
            DateTime(now.year, now.month, now.day, 9, 45),
            data: Event(
                title: 'Lession 1',
                period: Period(
                    starttime: const TimeOfDay(hour: 9, minute: 30),
                    endTime: const TimeOfDay(hour: 9, minute: 45)),
                description: 'Description 1',
                color: const Color(0xFF123CBB).withOpacity(0.30),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 9, 45),
            DateTime(now.year, now.month, now.day, 10, 30),
            data: Event(
                title: 'Lession 2',
                period: Period(
                    starttime: const TimeOfDay(hour: 9, minute: 45),
                    endTime: const TimeOfDay(hour: 10, minute: 30)),
                description: 'Description 2',
                color: const Color(0xFFF2A93B).withOpacity(0.60),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 11),
            DateTime(now.year, now.month, now.day, 12, 30),
            data: Event(
                title: 'Lession 3',
                period: Period(
                    starttime: const TimeOfDay(hour: 11, minute: 0),
                    endTime: const TimeOfDay(hour: 12, minute: 30)),
                description: 'Description 3',
                color: const Color(0xFF8CC1DA),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 13, 30),
            DateTime(now.year, now.month, now.day, 14, 15),
            data: Event(
                title: 'Lession 4',
                period: Period(
                    starttime: const TimeOfDay(hour: 13, minute: 30),
                    endTime: const TimeOfDay(hour: 14, minute: 45)),
                description: 'Description 4',
                color: const Color(0xFFE697A9),
                documents: <String>['documents.pdf'])),

        //second column
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 9, 30),
            DateTime(now.year, now.month, now.day + 1, 10, 30),
            data: Event(
                title: 'Lession 5',
                period: Period(
                    starttime: const TimeOfDay(hour: 9, minute: 30),
                    endTime: const TimeOfDay(hour: 1, minute: 30)),
                description: 'Description 5',
                color: const Color(0xFF123CBB).withOpacity(0.30),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 11),
            DateTime(now.year, now.month, now.day + 1, 11, 45),
            data: Event(
                title: 'Lession 6',
                period: Period(
                    starttime: const TimeOfDay(hour: 11, minute: 0),
                    endTime: const TimeOfDay(hour: 11, minute: 45)),
                description: 'Description 6',
                color: const Color(0xFFF2A93B).withOpacity(0.60),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 13, 30),
            DateTime(now.year, now.month, now.day + 1, 15),
            data: Event(
                title: 'Lession 7',
                period: Period(
                    starttime: const TimeOfDay(hour: 13, minute: 30),
                    endTime: const TimeOfDay(hour: 15, minute: 00)),
                description: 'Description 7',
                color: const Color(0xFFCBCE42).withOpacity(0.5),
                documents: <String>['documents.pdf'])),

        ///third column
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 2, 9, 45),
            DateTime(now.year, now.month, now.day + 2, 10, 30),
            data: Event(
                title: 'Lession 8',
                period: Period(
                    starttime: const TimeOfDay(hour: 9, minute: 45),
                    endTime: const TimeOfDay(hour: 10, minute: 30)),
                description: 'Description 8',
                color: const Color(0xFF52B5D7).withOpacity(0.5),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 2, 11, 30),
            DateTime(now.year, now.month, now.day + 2, 12, 30),
            data: Event(
                title: 'Lession 9',
                period: Period(
                    starttime: const TimeOfDay(hour: 11, minute: 30),
                    endTime: const TimeOfDay(hour: 12, minute: 30)),
                description: 'Description 9',
                color: const Color(0xFFCBCE42).withOpacity(0.5),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 2, 13, 30),
            DateTime(now.year, now.month, now.day + 2, 14, 15),
            data: Event(
                title: 'Lession 10',
                period: Period(
                    starttime: const TimeOfDay(hour: 13, minute: 30),
                    endTime: const TimeOfDay(hour: 14, minute: 15)),
                description: 'Description 10',
                color: const Color(0xFF52B5D7).withOpacity(0.5),
                documents: <String>['documents.pdf']))
      ];

      emit(LoadedState(_events));
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(ErrorState());
    }
  }

  ///call this function to add events
  Future<void> addEvent(TimetableItem<Event> value) async {
    emit(AddeingEvent());

    await Future<dynamic>.delayed(const Duration(seconds: 2));

    if (state is LoadedState) {}
    _events.add(value);
    emit(LoadedState(_events));
  }
}
