import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:edgar_planner_calendar_flutter/core/static.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/event_model.dart';
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

  ///view of the calendar
  CalendarViewType viewType = CalendarViewType.weekView;

  /// set method handler to receive data from flutter
  static const MethodChannel platform = MethodChannel('com.example.demo/data');

  ///set method handler

  void setListener() {
    platform.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case ReceiveMethods.sendToFlutter:
          debugPrint('id receive from ios app');
          await updateId(call.arguments);
          break;

        case ReceiveMethods.sendDate:
          debugPrint('date receive from flutter');
          log(call.arguments.toString());
          id = call.arguments.toString();
          emit(LoadedState(_events, viewType));
          break;

        default:
          debugPrint('Data receive from flutter:No handler');
      }
    });
  }

  ///send ontap callback to native app
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
  List<CalendarEvent<Event>> get events => _events;

  ///events of timetable
  List<CalendarEvent<Event>> _events = <CalendarEvent<Event>>[];

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
      _events = dummyEvents;
      emit(LoadedState(_events, viewType));
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(ErrorState());
    }
  }

  ///call this function to add events
  Future<void> addEvent(CalendarEvent<Event> value) async {
    emit(AddingEvent());

    await Future<dynamic>.delayed(const Duration(seconds: 2));

    if (state is LoadedState) {}
    _events.add(value);
    emit(LoadedState(_events, viewType));
  }

  ///remove pld event and add new event
  bool updateEvent(
      CalendarEvent<Event> old, CalendarEvent<Event> newEvent, Period? period) {
    emit(UpdatingEvent());
    _events.remove(old);
    if (period != null) {
      newEvent.eventData!.period = period;
    }

    log('removed${old.toMap}');
    _events.add(newEvent);
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

    final Directory? path = Directory('path for my edgar planner save methid');
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
