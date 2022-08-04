import 'package:bloc/bloc.dart';
import 'package:example/features/calendar/presentation/bloc/event_state.dart';
import 'package:example/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///
class EventCubit extends Cubit<EventState> {
  ///
  EventCubit() : super(InitialState()) {
    getTrendingMovies();
  }

  ///
  List<TimetableItem<Event>> get events => _events;

  ///
  List<TimetableItem<Event>> _events = [];

  ///
  Future<void> getTrendingMovies() async {
    try {
      emit(LoadingState());
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      _events = [
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 9, 30),
            DateTime(now.year, now.month, now.day, 9, 45),
            data: Event(
                title: 'Lession 1',
                description: 'Description 1',
                color: const Color(0xFF123CBB).withOpacity(0.30),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 9, 45),
            DateTime(now.year, now.month, now.day, 10, 30),
            data: Event(
                title: 'Lession 2',
                description: 'Description 2',
                color: const Color(0xFFF2A93B).withOpacity(0.60),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 11, 0),
            DateTime(now.year, now.month, now.day, 12, 30),
            data: Event(
                title: 'Lession 3',
                description: 'Description 3',
                color: const Color(0xFF8CC1DA),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day, 13, 30),
            DateTime(now.year, now.month, now.day, 14, 15),
            data: Event(
                title: 'Lession 4',
                description: 'Description 4',
                color: const Color(0xFFE697A9),
                documents: <String>['documents.pdf'])),

        //second column
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 9, 30),
            DateTime(now.year, now.month, now.day + 1, 10, 30),
            data: Event(
                title: 'Lession 5',
                description: 'Description 5',
                color: const Color(0xFF123CBB).withOpacity(0.30),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 11, 00),
            DateTime(now.year, now.month, now.day + 1, 11, 45),
            data: Event(
                title: 'Lession 6',
                description: 'Description 6',
                color: const Color(0xFFF2A93B).withOpacity(0.60),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 1, 13, 30),
            DateTime(now.year, now.month, now.day + 1, 15, 00),
            data: Event(
                title: 'Lession 7',
                description: 'Description 7',
                color: const Color(0xFFCBCE42).withOpacity(0.5),
                documents: <String>['documents.pdf'])),

        ///third column
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 2, 9, 45),
            DateTime(now.year, now.month, now.day + 2, 10, 30),
            data: Event(
                title: 'Lession 8',
                description: 'Description 8',
                color: const Color(0xFF52B5D7).withOpacity(0.5),
                documents: <String>['documents.pdf'])),
        TimetableItem<Event>(DateTime(now.year, now.month, now.day + 2, 11, 30),
            DateTime(now.year, now.month, now.day + 2, 12, 30),
            data: Event(
                title: 'Lession 9',
                description: 'Description 9',
                color: const Color(0xFFCBCE42).withOpacity(0.5),
                documents: <String>['documents.pdf'])),
        TimetableItem(DateTime(now.year, now.month, now.day + 2, 13, 30),
            DateTime(now.year, now.month, now.day + 2, 14, 15),
            data: Event(
                title: 'Lession 10',
                description: 'Description 10',
                color: const Color(0xFF52B5D7).withOpacity(0.5),
                documents: <String>['documents.pdf']))
      ];

      emit(LoadedState(_events));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> addEvent(TimetableItem<Event> value) async {
    emit(AddeingEvent());

    await Future<dynamic>.delayed(const Duration(seconds: 2));

    if (state is LoadedState) {}
    _events.add(value);
    emit(LoadedState(_events));
  }
}
