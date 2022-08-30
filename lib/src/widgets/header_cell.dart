import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///headerCell widget build the label for the header of the timetable
class HeaderCell extends StatelessWidget {
  ///headerCell
  const HeaderCell({
    required this.dateTime,
    required this.columnWidth,
    Key? key,
    this.headerCellBuilder,
  }) : super(key: key);

  /// Renders for the header that provides the [DateTime] for the day
  final Widget Function(DateTime)? headerCellBuilder;

  ///dateTime
  final DateTime dateTime;

  ///columnWidth
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final FontWeight weight = DateUtils.isSameDay(dateTime, DateTime.now()) //
        ? FontWeight.bold
        : FontWeight.normal;
    return SizedBox(
        width: columnWidth,
        child: headerCellBuilder != null
            ? headerCellBuilder!(dateTime)
            : Center(
                child: Text(
                  DateFormat('MMM\nd').format(dateTime),
                  style: TextStyle(fontSize: 12, fontWeight: weight),
                  textAlign: TextAlign.center,
                ),
              ));
  }
}
