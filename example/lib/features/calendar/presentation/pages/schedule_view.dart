import 'dart:developer';
import 'package:example/core/utils.dart';
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
class SchedulePlanner extends StatefulWidget {
  ///
  const SchedulePlanner({Key? key, this.id, this.isMobile = true})
      : super(key: key);

  ///id that we will received from native ios
  final String? id;

  ///bool isMobile
  final bool isMobile;

  @override
  State<SchedulePlanner> createState() => _SchedulePlannerState();
}

///current date time
DateTime now = DateTime.now().subtract(const Duration(days: 1));

///custom Time Periods for the timetable
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

class _SchedulePlannerState extends State<SchedulePlanner> {
  TimetableController simpleController = TimetableController(
      start: DateTime(2022, 8),
      end: DateTime(2022, 10),
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
  Widget build(BuildContext context) =>
      BlocBuilder<TimeTableCubit, TimeTableState>(
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
                child: SlScheduleView<Event>(
                  timelines: customPeriods,
                  onEventDragged: (CalendarEvent<Event> old,
                      CalendarEvent<Event> newEvent) {
                    BlocProvider.of<TimeTableCubit>(context, listen: false)
                        .updateEvent(old, newEvent);
                  },
                  onWillAccept: (CalendarEvent<Event>? event) {
                    if (event != null) {
                      if (state is LoadingState) {
                        final List<CalendarEvent<dynamic>> overLappingEvents =
                            BlocProvider.of<TimeTableCubit>(context,
                                    listen: false)
                                .events
                                .where((CalendarEvent<dynamic> element) =>
                                    !isTimeIsEqualOrLess(
                                        element.startTime, event.startTime) &&
                                    isTimeIsEqualOrLess(
                                        element.endTime, event.endTime))
                                .toList();
                        if (overLappingEvents.isEmpty) {
                          log('Slot available: ${event.toMap}');
                          return true;
                        } else {
                          log('Slot Not available-> Start Time: '
                              '${overLappingEvents.first.startTime}'
                              'End Time: ${overLappingEvents.first.endTime}');

                          return false;
                        }
                      } else {
                        return false;
                      }
                    } else {
                      return false;
                    }
                  },
                  nowIndicatorColor: Colors.red,
                  fullWeek: true,
                  cornerBuilder: (DateTime current) => const SizedBox.shrink(),
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
                  headerHeight: widget.isMobile ? 38 : 40,
                  headerCellBuilder: (DateTime date) =>
                      //  widget.isMobile
                      //     ?
                      SizedBox(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateFormat('E').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                        Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.5),
                                color: isSameDate(date)
                                    ? Colors.pink
                                    : Colors.transparent),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isSameDate(date) ? Colors.white : null),
                              ),
                            ))
                      ],
                    ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    height: 51,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: item.eventData!.color),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
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
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  // const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                getFormattedTime(
                                    item.eventData!.period, context),
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              e,
                                              style:
                                                  const TextStyle(fontSize: 10),
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
                            : Colors.transparent),
                  ),
                ),
              ),
            ],
          );
        }
      });
}
