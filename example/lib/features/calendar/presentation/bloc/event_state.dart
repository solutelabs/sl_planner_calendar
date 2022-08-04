import 'package:equatable/equatable.dart';
import 'package:example/features/calendar/data/event_model.dart'; 
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///event state
abstract class EventState extends Equatable {}

///event initial state
class InitialState extends EventState {
  @override
  List<Object> get props => <Object>[];
}

///loading state
class LoadingState extends EventState {
  @override
  List<Object> get props => <Object>[];
}

///loaded state
class LoadedState extends EventState {
  ///
  LoadedState(this.events);

///list of events
  final List<TimetableItem<Event>> events;
  @override
  List<Object> get props => <Object>[events];
}

///error state
class ErrorState extends EventState {
  @override
  List<Object> get props => <Object>[];
}

///adding event state
class AddeingEvent extends EventState {
  @override
  List<Object> get props => <Object>[];
}
