// To parse this JSON data, do
//
//     final getPeriods = getPeriodsFromJson(jsonString);

import 'dart:convert';

import 'package:sl_planner_calendar/sl_planner_calendar.dart';

GetPeriods getPeriodsFromJson(String str) =>
    GetPeriods.fromJson(json.decode(str));

String getPeriodsToJson(GetPeriods data) => json.encode(data.toJson());

///get periods from the ios
class GetPeriods {
  ///initialize the object
  GetPeriods({
    required this.periods,
  });

  /// return object from json
  factory GetPeriods.fromJson(Map<String, dynamic> json) => GetPeriods(
        periods: List<Period>.from(json['periods']
            .map((Map<String, dynamic> x) => Period.fromJson(x))),
      );

  ///list of the periods
  List<Period> periods;
///convert object to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'periods':
            List<dynamic>.from(periods.map<dynamic>((Period x) => x.toJson())),
      };
}