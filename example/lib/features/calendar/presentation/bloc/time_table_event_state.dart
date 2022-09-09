import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/event_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/get_events_model.dart';
import 'package:equatable/equatable.dart';
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
  final List<PlannerEvent> events;

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
class AddingEvent extends TimeTableState {
  @override
  List<Object> get props => <Object>[];
}

///adding event state
class UpdatingEvent extends LoadingState {
  @override
  List<Object> get props => <Object>[];
}

///date update event state
class DateUpdated extends LoadingState {
  ///initialize start
  DateUpdated(this.endDate, this.startDate);

  ///start date
  final DateTime startDate;

  ///end Date
  final DateTime endDate;

  @override
  List<Object> get props => <Object>[startDate, endDate];
}

///PeriodsUpdated event state
class PeriodsUpdated extends LoadingState {
  ///initialize start
  PeriodsUpdated(this.periods);

  ///list of the perioda
  final List<Period> periods;

  @override
  List<Object> get props => <Object>[periods];
}
