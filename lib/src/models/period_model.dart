import 'package:flutter/material.dart';

/// period class
class Period {
  ///
  Period(
      {required this.startTime,
      required this.endTime,
      this.title,
      this.isBreak = false});

  ///Start Time
  ///
  TimeOfDay startTime;

  ///End Time
  TimeOfDay endTime;

  /// String title
  String? title;

  /// if this period is break then make this variable true
  /// and pass title of the break
  bool isBreak = false;

  ///to map functionality

  Map<String, dynamic> get toMap => <String, dynamic>{
        'startTime': startTime,
        'endTime': endTime,
        'title': title,
        'isBreak': isBreak
      };

// DateTime get nowDate{
//   DateTime now=DateTime.now();
//  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
// }
}
