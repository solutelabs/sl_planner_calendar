import 'package:equatable/equatable.dart';
import 'package:example/planner.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

abstract class EventState extends Equatable {}

class InitialState extends EventState {
  @override
  List<Object> get props => [];
}

class LoadingState extends EventState {
  @override
  List<Object> get props => [];
}

class LoadedState extends EventState {
  LoadedState(this.events);

  final List<TimetableItem<Event>> events;

  @override
  List<Object> get props => [events];
}

class ErrorState extends EventState {
  @override
  List<Object> get props => [];
}

class AddeingEvent extends EventState {
  @override
  List<Object> get props => [];
}
