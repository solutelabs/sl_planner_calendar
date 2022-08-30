import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:example/core/static.dart';
import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/bloc/method_name.dart';
import 'package:example/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

///timetable cubit
class TimeTableCubit extends Cubit<TimeTableState> {
  ///
  TimeTableCubit() : super(InitialState()) {
    getDummyEvents();
  }

  ///view of the calendar
  CalendarViewType viewType = CalendarViewType.scheduleView;

  /// set method handler to receive data from flutter
  static const MethodChannel platform = MethodChannel('com.example.demo/data');

  ///set method handler

  void setListner() {
    platform.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case sendToFlutter:
          debugPrint('Data recive from flutter');
          await updateId(call.arguments);
          break;

        default:
          debugPrint('Data recive from flutter:No handler');
      }
    });
  }

  ///send data to native appp
  Future<bool> sendToNativeApp(dynamic data) {
    platform.invokeMethod<dynamic>(
      'receiveFromFlutter',
      data,
    );

    return Future<bool>.value(true);
  }

  ///get event
  List<CalendarEvent<Event>> get events => _events;

  ///events of timetable
  List<CalendarEvent<Event>> _events = <CalendarEvent<Event>>[];

  ///Stirng id
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
    emit(AddeingEvent());

    await Future<dynamic>.delayed(const Duration(seconds: 2));

    if (state is LoadedState) {}
    _events.add(value);
    emit(LoadedState(_events, viewType));
  }

  ///remove pld event and add new event
  bool updateEvent(CalendarEvent<Event> old, CalendarEvent<Event> newEvent) {
    emit(UpdatingEvent());
    _events.remove(old);
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

    final Directory? path = await getDownloadsDirectory();
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
