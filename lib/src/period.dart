 

import 'package:flutter/material.dart';  

///
class Period {
  ///starttime
  ///
  TimeOfDay starttime;

  ///endtime
  TimeOfDay endTime;

  /// String title
  String? title;

  //double tileHeight

  double? height;

  bool isBreak = false;

  ///
  Period(
      {required this.starttime,
      required this.endTime,
      this.title,
      this.height,
      this.isBreak = false});

  Map<String, dynamic> get toMap => <String, dynamic>{
        'startTime': starttime,
        'endTime': endTime,
        'title': title,
        'height': height,
        'isBreak': isBreak
      };
}
