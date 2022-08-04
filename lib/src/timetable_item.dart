/// A time table item is a single entry in a time table.
/// Required fields:
///  - [start] - DateTime the start time of the item
///  - [end] - DateTime the end time of the item
///
/// Optional fields:
///  - [data] - Optional generic payload that can be used by
/// the item builder to render the item card
///
/// Caluculated fields:
/// - [duration] - Duration is the difference between [start] and [end]
///  provided in the constructor
class TimetableItem<T> {
  ////
  TimetableItem(this.start, this.end, {this.data})
      : assert(start.isBefore(end)),
        duration = end.difference(start);

  ///start of the item
  final DateTime start;

  ///end of the item
  final DateTime end;

  ///end of the item
  final T? data;

  ///duration of the item
  final Duration duration;
}
