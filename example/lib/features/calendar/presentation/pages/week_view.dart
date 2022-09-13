import 'package:edgar_planner_calendar_flutter/core/colors.dart';
import 'package:edgar_planner_calendar_flutter/core/constants.dart';
import 'package:edgar_planner_calendar_flutter/core/date_extension.dart';
import 'package:edgar_planner_calendar_flutter/core/static.dart';
import 'package:edgar_planner_calendar_flutter/core/text_styles.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/get_events_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_cubit.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///planner
class WeekPlanner extends StatefulWidget {
  /// initialize week planner
  const WeekPlanner({required this.timetableController, Key? key, this.id})
      : super(key: key);

  ///id that we will received from native ios
  final String? id;

  ///timetable controller
  final TimetableController timetableController;

  @override
  State<WeekPlanner> createState() => _WeekPlannerState();
}

///current date time
DateTime now = DateTime.now().subtract(const Duration(days: 30));

class _WeekPlannerState extends State<WeekPlanner> {
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
    simpleController = widget.timetableController;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      currentMonth = simpleController.visibleDateStart;
      setState(() {});
      Future<dynamic>.delayed(const Duration(milliseconds: 100), () {
        simpleController.jumpTo(dateTime);
      });
    });
    super.initState();
  }

  DateTime currentMonth = DateTime.now();

  ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(dateTime);
  final bool showSameHeader = true;

  @override
  Widget build(BuildContext context) => Scaffold(body:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints value) {
        final bool isMobile = value.maxWidth < 600;

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
                  child: SlWeekView<EventData>(
                    fullWeek: true,
                    timelines: customPeriods,
                    onEventDragged: (CalendarEvent<EventData> old,
                        CalendarEvent<EventData> newEvent, Period period) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .updateEvent(old, newEvent, period);
                    },
                    onWillAccept:
                        (CalendarEvent<EventData>? event, Period period) =>
                            true,
                    nowIndicatorColor: Colors.red,
                    cornerBuilder: (DateTime current) =>
                        const SizedBox.shrink(),
                    items:
                        state is LoadedState ? state.events : <PlannerEvent>[],
                    onTap: (DateTime date, Period period,
                        CalendarEvent<EventData>? event) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .onTap(dateTime, <PlannerEvent>[]);
                    },
                    headerHeight:
                        showSameHeader || isMobile ? headerHeight : 40,
                    headerCellBuilder: (DateTime date) => isMobile
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                DateFormat('E').format(date).toUpperCase(),
                                style: context.hourLabelMobile,
                              ),
                              Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.5),
                                      color: isSameDate(date)
                                          ? primaryPink
                                          : Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style: context.headline2Fw500.copyWith(
                                          fontSize: isMobile ? 16 : 24,
                                          color: isSameDate(date)
                                              ? Colors.white
                                              : null),
                                    ),
                                  )),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                DateFormat('E').format(date).toUpperCase(),
                                style: context.subtitle,
                              ),
                              Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.5),
                                      color: isSameDate(date)
                                          ? primaryPink
                                          : Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style: context.headline1WithNotoSans
                                          .copyWith(
                                              color: isSameDate(date)
                                                  ? Colors.white
                                                  : null),
                                    ),
                                  )),
                              const SizedBox(
                                height: 2,
                              ),
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
                                      style: isMobile
                                          ? context.hourLabelMobile
                                          : context.hourLabelTablet),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(start.format(context).substring(0, 5),
                                      style: isMobile
                                          ? context.hourLabelMobile
                                          : context.hourLabelTablet),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(end.format(context).substring(0, 5),
                                      style: isMobile
                                          ? context.hourLabelMobile
                                          : context.hourLabelTablet),
                                ],
                              ),
                      );
                    },
                    isCellDraggable: (CalendarEvent<EventData> event) {
                      if (event.eventData!.period.isBreak) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                    controller: simpleController,
                    itemBuilder:
                        (CalendarEvent<EventData> item, double width) =>
                            Container(
                      margin: const EdgeInsets.all(4),
                      child: Container(
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
                                    style: context.subtitle,
                                  )),
                                )
                              : EventTile(
                                  item: item,
                                  height: item.eventData!.period.isBreak
                                      ? simpleController.breakHeight
                                      : simpleController.cellHeight,
                                  width: width,
                                )),
                    ),
                    cellBuilder: (Period period) => Container(
                      height: period.isBreak
                          ? simpleController.breakHeight
                          : simpleController.cellHeight,
                      decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          color:
                              period.isBreak ? lightGrey : Colors.transparent),
                    ),
                  ),
                ),
              ],
            );
          }
        });
      }));
}
