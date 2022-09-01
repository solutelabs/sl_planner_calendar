///calend day

class CalendarDay {
  ///
  CalendarDay({required this.dateTime, this.deadCell = false});

  ///bool is deadCell
  bool deadCell;

  ///
  /// DateTime
  DateTime dateTime;

  @override
  String toString() => 'DeadCell $deadCell' ' DateTime: $dateTime';
}
