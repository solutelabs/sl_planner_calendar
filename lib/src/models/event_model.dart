///
class CalendarEvent<T> {
  ///Pass starttime and endtime along with evet data
  CalendarEvent(
      {required this.startTime, required this.endTime, this.eventData});

  ///start Time of the event
  DateTime startTime;

  ///end time of the event
  DateTime endTime;

  ///extra data for the event
  T? eventData;

  ///return map object of the parameter
  Map<String, dynamic> get toMap => <String, dynamic>{
        'starTime': startTime.toString(),
        'endTime': endTime.toString(),
        'eventData': eventData.toString()
      };
}
