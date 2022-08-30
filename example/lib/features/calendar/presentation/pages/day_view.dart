import 'dart:developer';

import 'package:example/core/date_extension.dart';
import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/bloc/time_table_cubit.dart';
import 'package:example/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:example/features/calendar/presentation/pages/add_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///planner
class DAyPlanner extends StatefulWidget {
  ///
  const DAyPlanner({Key? key, this.id}) : super(key: key);

  ///id that we will recived from native ios
  final String? id;

  @override
  State<DAyPlanner> createState() => _DAyPlannerState();
}

///current date time
DateTime now = DateTime.now().subtract(const Duration(days: 1));

///custom timeperiods for the timetable
List<Period> customPeriods = <Period>[
  Period(
    startTime: const TimeOfDay(hour: 9, minute: 30),
    endTime: const TimeOfDay(hour: 9, minute: 45),
  ),
  Period(
    startTime: const TimeOfDay(hour: 9, minute: 45),
    endTime: const TimeOfDay(hour: 10, minute: 30),
  ),
  Period(
    startTime: const TimeOfDay(hour: 10, minute: 30),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    isBreak: true,
    title: 'Recess',
  ),
  Period(
    startTime: const TimeOfDay(hour: 11, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 45),
  ),
  Period(
    startTime: const TimeOfDay(hour: 11, minute: 45),
    endTime: const TimeOfDay(hour: 12, minute: 30),
  ),
  Period(
      startTime: const TimeOfDay(hour: 12, minute: 30),
      endTime: const TimeOfDay(hour: 13, minute: 30),
      isBreak: true,
      title: 'Lunch'),
  Period(
    startTime: const TimeOfDay(hour: 13, minute: 30),
    endTime: const TimeOfDay(hour: 14, minute: 15),
  ),
  Period(
    startTime: const TimeOfDay(hour: 14, minute: 15),
    endTime: const TimeOfDay(hour: 15, minute: 0),
  ),
];

///return true if date is same
bool isSameDate(DateTime date) {
  final DateTime now = DateTime.now();
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return true;
  } else {
    return false;
  }
}

class _DAyPlannerState extends State<DAyPlanner> {
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

  DateTime currentMonth = DateTime.now();

  ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(dateTime);

  @override
  Widget build(BuildContext context) => Scaffold(body:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints value) {
        final bool isMobile = value.maxWidth < 600;
        // Size size = value.biggest;
        return BlocBuilder<TimeTableCubit, TimeTableState>(
            builder: (BuildContext context, TimeTableState state) {
          if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else {
            return Column(
              children: <Widget>[
                state is LoadingState
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
                Expanded(
                  child: SlDayView<Event>(
                    timelines: customPeriods,
                    onEventDragged: (CalendarEvent<Event> old,
                        CalendarEvent<Event> newEvent) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .updateEvent(old, newEvent);
                    },
                    onWillAccept: (CalendarEvent<Event>? event, DateTime date,
                        Period period) {
                      final List<CalendarEvent<Event>> events =
                          BlocProvider.of<TimeTableCubit>(context,
                                  listen: false)
                              .events;
                      isSlotAvlForSingleDay(events, event!, date, period);
                    },
                    nowIndicatorColor: Colors.red,
                    fullWeek: true,
                    cornerBuilder: (DateTime current) =>
                        const SizedBox.shrink(),
                    items: state is LoadedState
                        ? state.events
                        : <CalendarEvent<Event>>[],
                    onTap: (DateTime date, Period period,
                        CalendarEvent<Event>? event) {
                      log(date.toString());
                      log(period.toMap.toString());
                      log(event.toString());

                      Navigator.push<Widget>(
                          context,
                          CupertinoPageRoute<Widget>(
                              builder: (BuildContext context) => AddPlan(
                                    date: date,
                                    periods: customPeriods,
                                    period: period,
                                    timetableItem: event,
                                  )));
                    },
                    headerHeight: isMobile ? 38 : 40,
                    headerCellBuilder: (DateTime date) => isMobile
                        ? Row(
                            children: <Widget>[
                              SizedBox(
                                width: simpleController.timelineWidth,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        DateFormat('E').format(date),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.5),
                                              color: isSameDate(date)
                                                  ? Colors.pink
                                                  : Colors.transparent),
                                          child: Center(
                                            child: Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSameDate(date)
                                                      ? Colors.white
                                                      : null),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 0.5),
                                        // borderRadius:
                                        //     BorderRadius.circular(12.5),
                                        color: isSameDate(date)
                                            ? Colors.black87
                                            : Colors.transparent),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              DateFormat('E')
                                                  .format(date)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSameDate(date)
                                                      ? Colors.white
                                                      : null),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: isSameDate(date)
                                                ? Colors.white
                                                : null,
                                            size: 6,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Flexible(
                                            child: Text(
                                              DateFormat('d MMM').format(date),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSameDate(date)
                                                      ? Colors.white
                                                      : null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                    hourLabelBuilder: (Period period) {
                      final TimeOfDay start = period.startTime;

                      final TimeOfDay end = period.endTime;
                      return Container(
                        child: period.isBreak
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(period.title ?? '',
                                      style: const TextStyle(fontSize: 10)),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(start.format(context).substring(0, 5),
                                      style: const TextStyle(fontSize: 10)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(end.format(context).substring(0, 5),
                                      style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                      );
                    },
                    controller: simpleController,
                    itemBuilder: (CalendarEvent<Event> item) => Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(6),
                      height: item.eventData!.period.isBreak
                          ? simpleController.breakHeight
                          : simpleController.cellHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: item.eventData!.color),
                      child: item.eventData!.period.isBreak
                          ? Container(
                              height: simpleController.breakHeight,
                              child: Center(
                                  child: Text(
                                item.eventData!.title,
                                style: const TextStyle(color: Colors.white),
                              )),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                      child: Text(
                                        item.eventData!.title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                item.eventData!.freeTime
                                    ? const SizedBox.shrink()
                                    : Flexible(
                                        child: Text(
                                          item.eventData!.description,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                item.eventData!.freeTime
                                    ? const SizedBox.shrink()
                                    : const Spacer(),
                                item.eventData!.freeTime
                                    ? const SizedBox.shrink()
                                    : item.eventData!.documents.isNotEmpty
                                        ? Wrap(
                                            runSpacing: 8,
                                            spacing: 8,
                                            children: item.eventData!.documents
                                                .map((String e) => Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                      e,
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    )))
                                                .toList())
                                        : const SizedBox.shrink(),
                              ],
                            ),
                    ),
                    cellBuilder: (Period period) => Container(
                      height: period.isBreak
                          ? simpleController.breakHeight
                          : simpleController.cellHeight,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 0.5),
                          color: period.isBreak
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.red),
                    ),
                  ),
                ),
              ],
            );
          }
        });
      }));
}
