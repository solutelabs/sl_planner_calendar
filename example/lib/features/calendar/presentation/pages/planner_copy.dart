import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:example/core/date_extension.dart';
import 'package:example/core/month_picker.dart';
import 'package:example/features/calendar/presentation/bloc/time_table_cubit.dart';
import 'package:example/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:example/features/calendar/presentation/pages/day_view.dart';
import 'package:example/features/calendar/presentation/pages/schedule_view.dart';
import 'package:example/features/calendar/presentation/pages/week_view.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///planner
class Planner extends StatefulWidget {
  ///
  const Planner({Key? key, this.id}) : super(key: key);

  ///id that we will recived from native ios
  final String? id;

  @override
  State<Planner> createState() => _PlannerState();
}

///current date time
DateTime now = DateTime.now().subtract(const Duration(days: 1));

///custom timeperiods for the timetable
List<Period> customPeriods = <Period>[
  Period(
    starttime: const TimeOfDay(hour: 9, minute: 30),
    endTime: const TimeOfDay(hour: 9, minute: 45),
  ),
  Period(
    starttime: const TimeOfDay(hour: 9, minute: 45),
    endTime: const TimeOfDay(hour: 10, minute: 30),
  ),
  Period(
    starttime: const TimeOfDay(hour: 10, minute: 30),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    isBreak: true,
    title: 'Recess',
  ),
  Period(
    starttime: const TimeOfDay(hour: 11, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 45),
  ),
  Period(
    starttime: const TimeOfDay(hour: 11, minute: 45),
    endTime: const TimeOfDay(hour: 12, minute: 30),
  ),
  Period(
      starttime: const TimeOfDay(hour: 12, minute: 30),
      endTime: const TimeOfDay(hour: 13, minute: 30),
      isBreak: true,
      title: 'Lunch'),
  Period(
    starttime: const TimeOfDay(hour: 13, minute: 30),
    endTime: const TimeOfDay(hour: 14, minute: 15),
  ),
  Period(
    starttime: const TimeOfDay(hour: 14, minute: 15),
    endTime: const TimeOfDay(hour: 15, minute: 0),
  ),
];
///screenshot controller
ScreenshotController screenshotController = ScreenshotController();

class _PlannerState extends State<Planner> {
  TimetableController simpleController = TimetableController(
      start:
          DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 1)),
      end: dateTime.lastDayOfMonth,
      timelineWidth: 60,
      breakHeight: 35,
      cellHeight: 120);
  static DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      currentMonth = simpleController.visibleDateStart;
      setState(() {});
      Future<dynamic>.delayed(const Duration(milliseconds: 100), () {
        simpleController.jumpTo(now);
      });
    });
  }

  List<Widget> widgets = <Widget>[
    SchedulePlanner(
      isMobile: isMobile,
    ),
    const DAyPlanner(),
    const WeekPlanner(),
  ];
  DateTime currentMonth = DateTime.now();
  static bool isMobile = true;
  ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(dateTime);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            DatePicker.showPicker(context,
                    pickerModel: CustomMonthPicker(
                        minTime: DateTime(
                          2020,
                        ),
                        maxTime: DateTime.now(),
                        currentTime: dateTime))
                .then((DateTime? value) {
              if (value != null) {
                log(dateTime.toString());
                dateTime = value;

                setState(() {});
                simpleController.changeDate(
                    DateTime(dateTime.year, dateTime.month),
                    dateTime.lastDayOfMonth);
              }
            });
          },
          child: Text(
            DateFormat('MMMM-y').format(dateTime),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog<Widget>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Your id is'),
                      content: Text(BlocProvider.of<TimeTableCubit>(context,
                                  listen: false)
                              .id ??
                          'No  id recived'),
                    ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () async {
              // screenshotController.capture(pixelRatio: 4).then((image) {
              //   BlocProvider.of<TimeTableCubit>(context, listen: false)
              //       .saveToPdf(image!);

              final Directory? path = await getDownloadsDirectory();
              // screenshotController.captureAndSave(path!.path,
              //     fileName: "planner", pixelRatio: 5);
              //from path_provide package
              await screenshotController
                  .captureFromWidget(
                      Container(
                          height: 4000,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent, width: 5),
                            color: Colors.redAccent,
                          ),
                          child: const Text('dfdsfdsf')),
                      pixelRatio: 10)
                  .then((Uint8List capturedImage) async {
                await FileSaver.instance.saveFile(
                    'example', capturedImage, 'png',
                    mimeType: MimeType.PNG);
                // Handle captured image
              });

              // });
              // simpleController.setColumns(5);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
            onPressed: () {
              void _showActionSheet(BuildContext context) {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: const Text('Set Calendar view'),
                    message: const Text('Select calendar view'),
                    actions: <CupertinoActionSheetAction>[
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          BlocProvider.of<TimeTableCubit>(context,
                                  listen: false)
                              .changeViewType(CalendarViewType.weekView);
                          Navigator.pop(context);
                        },
                        child: const Text('Week View'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          BlocProvider.of<TimeTableCubit>(context,
                                  listen: false)
                              .changeViewType(CalendarViewType.shecduleView);
                          Navigator.pop(context);
                        },
                        child: const Text('Schedule View'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          BlocProvider.of<TimeTableCubit>(context,
                                  listen: false)
                              .changeViewType(CalendarViewType.dayView);
                          Navigator.pop(context);
                        },
                        child: const Text('Day View'),
                      ),
                      CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Destructive Action'),
                      )
                    ],
                  ),
                );
              }

              _showActionSheet(context);
            },
          ),
        ],
      ),
      body:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints value) {
        isMobile = value.maxWidth < 600;
        return BlocBuilder<TimeTableCubit, TimeTableState>(
            builder: (BuildContext context, TimeTableState state) {
          if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else {
            return Screenshot<Widget>(
              controller: screenshotController,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: IndexedStack(
                  index: state is LoadedState
                      ? (state.viewType == CalendarViewType.shecduleView
                          ? 0
                          : state.viewType == CalendarViewType.dayView
                              ? 1
                              : 2)
                      : 0,
                  children: <Widget>[
                    SchedulePlanner(
                      isMobile: isMobile,
                    ),
                    const DAyPlanner(),
                    const WeekPlanner(),
                  ],
                ),
              ),
            );
          }
        });
      }));
}
