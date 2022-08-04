import 'dart:developer';

import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/bloc/event_cubit.dart';
import 'package:example/features/calendar/presentation/bloc/event_state.dart';
import 'package:example/features/calendar/presentation/pages/add_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///planner
class Planner extends StatefulWidget {
  final String? id;

  ///
  const Planner({Key? key, this.id}) : super(key: key);

  @override
  State<Planner> createState() => _PlannerState();
}

///current date time
DateTime now = DateTime.now().subtract(const Duration(days: 1));

///custom t
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

///return true if date is same
bool isSameDate(DateTime date) {
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return true;
  } else {
    return false;
  }
}

class _PlannerState extends State<Planner> {
  final TimetableController simpleController = TimetableController(
      start:
          DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 1)),
      timelineWidth: 60,
      breakHeight: 35,
      cellHeight: 120);

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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          title: Text(
            DateFormat('MMM-y').format(currentMonth),
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Your id is"),
                        content: Text(widget.id??"No  id recived"),
                      ));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            // TextButton(
            //   onPressed: () async => Navigator.pushNamed(context, '/custom'),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     children: const [
            //       Icon(Icons.celebration_outlined, color: Colors.white),
            //       SizedBox(width: 8),
            //       Text(
            //         "Custom builders",
            //         style: TextStyle(color: Colors.white, fontSize: 16),
            //       ),
            //       SizedBox(width: 8),
            //       Icon(Icons.chevron_right_outlined, color: Colors.white),
            //     ],
            //   ),
            // ),
          ],
        ),
        body: BlocBuilder<EventCubit, EventState>(
            builder: (BuildContext context, EventState state) {
          // if (state is LoadingState) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else
          if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else {
            //  else if (state is LoadedState) {
            //   final events = state.events;
            //   return SizedBox.shrink();
            // }
            return Column(
              children: <Widget>[
                state is LoadingState
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
                Expanded(
                  child: Timetable<Event>(
                    fullWeek: true,
                    timelines: customPeriods,
                    items: state is LoadedState
                        ? state.events
                        : <TimetableItem<Event>>[],
                    onTap: (DateTime date, Period period,
                        TimetableItem<Event>? event) {
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
                    headerCellBuilder: (DateTime date) => Column(
                      children: <Widget>[
                        Text(
                          DateFormat('E').format(date),
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
                                    color:
                                        isSameDate(date) ? Colors.white : null),
                              ),
                            ))
                      ],
                    ),
                    hourLabelBuilder: (Period period) {
                      final TimeOfDay start = period.starttime;

                      final TimeOfDay end = period.endTime;
                      return Container(
                        decoration: const BoxDecoration(color: Colors.white),
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
                                  Text(start.format(context),
                                      style: const TextStyle(fontSize: 10)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(end.format(context),
                                      style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                      );
                    },
                    controller: simpleController,
                    itemBuilder: (TimetableItem<Event> item) => Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(4),
                      height: item.data!.period.isBreak
                          ? simpleController.breakHeight
                          : simpleController.cellHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: item.data!.color),
                      child: item.data!.period.isBreak
                          ? Container(
                              height: simpleController.breakHeight,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Text(item.data!.title),
                                  ],
                                ),
                                Text(item.data!.description),
                                item.data!.documents.isNotEmpty
                                    ? Center(
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              item.data!.documents.first,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )),
                                      )
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
                            color: Colors.grey.withOpacity(0.5), width: 0.2),
                      ),

                      // child
                      // : Center(
                      //   child: Text(
                      //     DateFormat("MM/d/yyyy\nha").format(datetime.starttime),
                      //     style: const TextStyle(color: Colors.blue
                      //         // color: Color(0xff000000 +
                      //         //         (0x002222 * datetime.hour) +
                      //         //         (0x110000 * datetime.day))
                      //         //     .withOpacity(0.5),
                      //         ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      );
}
