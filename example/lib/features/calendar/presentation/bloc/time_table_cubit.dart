import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:edgar_planner_calendar_flutter/core/static.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/change_view_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/date_change_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/event_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/get_events_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/get_periods_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/method_name.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

///timetable cubit
class TimeTableCubit extends Cubit<TimeTableState> {
  /// initialized timetable cubit
  TimeTableCubit() : super(InitialState()) {
    getDummyEvents();
    setListener();
  }

  ///start date of the planner

  ///current date time
  static DateTime now = DateTime.now();

  ///start date

  DateTime startDate = DateTime(now.year, now.month);

  ///start date

  DateTime endDate =
      DateTime(now.year, now.month + 1).subtract(const Duration(days: 1));

  ///view of the calendar
  CalendarViewType viewType = CalendarViewType.weekView;

  ///list of the periods of the timetable
  List<Period> periods = customPeriods;

  /// set method handler to receive data from flutter
  static const MethodChannel platform = MethodChannel('com.example.demo/data');

  ///set method handler

  void setListener() {
    platform.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {

        ///receive id from ios
        case ReceiveMethods.sendToFlutter:
          debugPrint('id receive from ios app');
          await updateId(call.arguments);
          break;

        ///receive data change command from ios
        case ReceiveMethods.sendDate:
          debugPrint('date receive from flutter');
          final DateChange dateChange =
              DateChange.fromJson(jsonDecode(call.arguments));
          startDate = dateChange.startTime;
          endDate = dateChange.endTime;
          emit(LoadedState(_events, viewType));
          break;
        case ReceiveMethods.setView:
          debugPrint('set view received from native app');
          final ChangeView changeView =
              ChangeView.fromJson(jsonDecode(call.arguments));
          changeViewType(changeView.viewType);
          break;
        case ReceiveMethods.setPeriods:
          debugPrint('set periods received from native app');
          final GetPeriods changePeriods =
              GetPeriods.fromJson(jsonDecode(call.arguments));
          periods = changePeriods.periods;
          emit(PeriodsUpdated(periods));

          break;
        default:
          debugPrint('Data receive from flutter:No handler');
      }
    });
  }

  ///send onTap callback to native app
  Future<bool> onTap(DateTime dateTime) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'viewType': viewType.toString(),
      'date': dateTime.toString()
    };
    await sendToNativeApp(onTapMethod, data);
    return true;
  }

  ///send data to native app
  Future<bool> sendToNativeApp(String methodName, dynamic data) {
    platform
        .invokeMethod<dynamic>(
      methodName,
      data,
    )
        .then((dynamic value) {
      log('MethodName: $onTapMethod');
      log('Data: $data');
    });

    return Future<bool>.value(true);
  }

  ///get event
  List<PlannerEvent> get events => _events;

  ///events of timetable
  List<PlannerEvent> _events = <PlannerEvent>[];

  ///String id
  String? id;

  ///update id of the user
  Future<void> updateId(dynamic data) async {
    final Map<String, dynamic> jData = await jsonDecode(data);

    id = jData['id'].toString();
    emit(LoadedState(_events, viewType));
  }

  ///get dummy events
  Future<void> getDummyEvents() async {
    try {
      emit(LoadingState());
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      _events = dummyEventDatas;
      emit(LoadedState(_events, viewType));
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(ErrorState());
    }
  }

  ///call this function to add events
  Future<void> addEvent(PlannerEvent value) async {
    emit(AddingEvent());

    await Future<dynamic>.delayed(const Duration(seconds: 2));

    if (state is LoadedState) {}
    _events.add(value);
    emit(LoadedState(_events, viewType));
  }

  ///remove pld event and add new event
  bool updateEvent(CalendarEvent<EventData> old,
      CalendarEvent<EventData> newEvent, Period? period) {
    emit(UpdatingEvent());
    _events.remove(old);
    if (period != null) {
      newEvent.eventData!.period = period;
    }

    log('removed${old.toMap}');
    _events.add(PlannerEvent(
        startTime: newEvent.startTime,
        endTime: newEvent.endTime,
        eventData: newEvent.eventData));
    emit(LoadedState(_events, viewType));
    log('added${newEvent.toMap}');
    return true;
  }

  ///void save image as psd

  Future<void> saveToPdf(Uint8List image) async {
    final pw.Document pdf = pw.Document()
      ..addPage(pw.Page(
          build: (pw.Context context) =>
              pw.Image(pw.RawImage(bytes: image, width: 100, height: 100))));

    final Directory? path = Directory('path for my edgar planner save method');
    try {
      // await FileSaver.instance
      //     .saveFile("example", image, "pdf", mimeType: MimeType.PDF);
      final File file = File('${path!.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());
    } on FileSystemException catch (e) {
      debugPrint(e.message);
    }
  }

  ///chang calendar view
  void changeViewType(CalendarViewType viewType) {
    this.viewType = viewType;
    emit(LoadedState(events, viewType));
  }
}
