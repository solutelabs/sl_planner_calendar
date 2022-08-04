import 'package:flutter/material.dart';

/// period class
class Period {
  ///
  Period(
      {required this.starttime,
      required this.endTime,
      this.title,
      this.height,
      this.isBreak = false});

  ///starttime
  ///
  TimeOfDay starttime;

  ///endtime
  TimeOfDay endTime;

  /// String title
  String? title;

  //double tileHeight

  ///height of the cell
  double? height;

  /// if this period is break then make this variable true
  /// and pass title of the breack
  bool isBreak = false;

  ///to map functionality

  Map<String, dynamic> get toMap => <String, dynamic>{
        'startTime': starttime,
        'endTime': endTime,
        'title': title,
        'height': height,
        'isBreak': isBreak
      };
}
