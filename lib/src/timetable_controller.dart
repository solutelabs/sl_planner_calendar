import 'dart:math';
import 'package:flutter/material.dart';

/// A controller for the timetable.
///
/// The controller allow intialization of the timetable and to expose
/// timetable functionality to the outside.
class TimetableController {
  ///
  TimetableController({
    /// The number of day columns to show.
    int initialColumns = 3,

    /// The start date (first column) of the timetable. Default is today.
    DateTime? start,

    /// the end of the last date in time table
    DateTime? end,

    /// The height of each cell in the timetable. Default is 50.
    double? cellHeight,

    /// The height of the header in the timetable. Default is 50.
    double? headerHeight,

    /// The width of the timeline where hour labels are rendered. Default is 50.
    double? timelineWidth,

    ///height of the breakcell
    double? breakHeight,

    /// Controller event listener.
    Function(TimetableControllerEvent)? onEvent,
  }) {
    _columns = initialColumns;
    _start = DateUtils.dateOnly(start ?? DateTime.now());

    _end = DateUtils.dateOnly(
        end ?? DateTime.now().add(const Duration(days: 180)));
    _cellHeight = cellHeight ?? 50;
    _headerHeight = headerHeight ?? 50;
    _timelineWidth = timelineWidth ?? 50;
    _breakHeight = breakHeight ?? 35;
    _visibleDateStart = _start;
    if (onEvent != null) {
      addListener(onEvent);
    }
  }

  late DateTime _start;

  late DateTime _end;

  /// The [start] date (first column) of the timetable.
  DateTime get start => _start;

  /// The [end] date (first column) of the timetable.
  DateTime get end => _end;
  set start(DateTime value) {
    _start = DateUtils.dateOnly(value);
    dispatch(TimetableStartChanged(_start));
  }

  set end(DateTime value) {
    _end = DateUtils.dateOnly(value);
    dispatch(TimetableStartChanged(_end));
  }

  int _columns = 3;

  /// The current number of [columns] in the timetable.
  int get columns => _columns;

  double _cellHeight = 50;

  /// break height
  double _breakHeight = 35;

  /// get breakHeight of the timetable
  double get breakHeight => _breakHeight;

  /// The current height of each cell in the timetable.
  double get cellHeight => _cellHeight;

  /// list of the listner
  final Map<int, Function(TimetableControllerEvent)> _listeners =
      <int, Function(TimetableControllerEvent)>{};

  /// if  table has listner
  bool get hasListeners => _listeners.isNotEmpty;

  double _headerHeight = 50;

  /// The current height of the header in the timetable.
  double get headerHeight => _headerHeight;

  double _timelineWidth = 50;

  /// The current width of the timeline where hour labels are rendered.
  double get timelineWidth => _timelineWidth;

  late DateTime _visibleDateStart;

  /// The first date of the visible area of the timetable.
  DateTime get visibleDateStart => _visibleDateStart;

  /// Allows listening to events dispatched from the timetable
  int addListener(Function(TimetableControllerEvent)? listener) {
    if (listener == null) {
      return -1;
    }
    final int id = _listeners.isEmpty ? 0 : _listeners.keys.reduce(max) + 1;
    _listeners[id] = listener;
    return id;
  }

  /// Removes a listener from the timetable
  void removeListener(int id) => _listeners.remove(id);

  /// Removes all listeners from the timetable
  void clearListeners() => _listeners.clear();

  /// Dispatches an event to all listeners
  void dispatch(TimetableControllerEvent event) {
    for (final Function(TimetableControllerEvent p1) listener
        in _listeners.values) {
      listener(event);
    }
  }

  /// Scrolls the timetable to the given date and time.
  void jumpTo(DateTime date) {
    dispatch(TimetableJumpToRequested(date));
  }

  /// Updates the number of columns in the timetable
  void setColumns(int i) {
    if (i == _columns) {
      return;
      // _columns = i;
    }
    dispatch(TimetableColumnsChanged(i));
  }

  /// Updates the height of each cell in the timetable
  void setCellHeight(double height) {
    if (height == _cellHeight) {
      return;
    }
    if (height <= 0) {
      return;
    }
    _cellHeight = min(height, 1000);
    dispatch(TimetableCellHeightChanged(height));
  }

  /// This allows the timetable to update the current visible date.
  void updateVisibleDate(DateTime date) {
    _visibleDateStart = date;
    dispatch(TimetableVisibleDateChanged(date));
  }
}

/// A generic event that can be dispatched from the timetable controller
abstract class TimetableControllerEvent {}

/// Event used to change the cell height of the timetable
class TimetableCellHeightChanged extends TimetableControllerEvent {
  /// cell height change evemt
  TimetableCellHeightChanged(this.height);

  ///cell height
  final double height;
}

/// Event used to change the number of columns in the timetable
class TimetableColumnsChanged extends TimetableControllerEvent {
  /// column height change evemt
  TimetableColumnsChanged(this.columns);

  ///no of columns
  final int columns;
}

/// Event used to scroll the timetable to a given date and time
class TimetableJumpToRequested extends TimetableControllerEvent {
  /// jump to specific date requested
  TimetableJumpToRequested(this.date);

  ///jump to this date
  final DateTime date;
}

/// Event dispatched when the start date of the timetable changes
class TimetableStartChanged extends TimetableControllerEvent {
  ///table start change event
  TimetableStartChanged(this.start);

  ///start of the table
  final DateTime start;
}

/// Event dispatched when the visible date of the timetable changes
class TimetableVisibleDateChanged extends TimetableControllerEvent {
  ///visible date changed event
  TimetableVisibleDateChanged(this.start);

  ///start of the visible date
  final DateTime start;
}
