import 'package:equatable/equatable.dart';
import 'package:example/features/calendar/data/event_model.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///event state
abstract class TimeTableState extends Equatable {}

///event initial state
class InitialState extends TimeTableState {
  @override
  List<Object> get props => <Object>[];
}

///loading state
class LoadingState extends TimeTableState {
  @override
  List<Object> get props => <Object>[];
}

///loaded state
class LoadedState extends TimeTableState {
  ///
  LoadedState(this.events, this.viewType);

  ///list of events
  final List<CalendarEvent<Event>> events;

  ///
  final CalendarViewType viewType;

  @override
  List<Object> get props => <Object>[events, viewType];
}

///error state
class ErrorState extends TimeTableState {
  @override
  List<Object> get props => <Object>[];
}

///adding event state
class AddeingEvent extends TimeTableState {
  @override
  List<Object> get props => <Object>[];
}

///adding event state
class UpdatingEvent extends LoadingState {
  @override
  List<Object> get props => <Object>[];
}
