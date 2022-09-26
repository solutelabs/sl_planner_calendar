import 'dart:developer';

import 'package:edgar_planner_calendar_flutter/core/colors.dart';
import 'package:edgar_planner_calendar_flutter/core/constants.dart';
import 'package:edgar_planner_calendar_flutter/core/text_styles.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/models/get_events_model.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_cubit.dart'; 
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/widgets/event_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///Preview
class Preview {
  ///export week view
  static void exportWeekView(DateTime startDate, DateTime endDate,
      List<Period> timelines, List<PlannerEvent> event, BuildContext context) {
    final TimetableController simpleController = TimetableController(
        start: startDate,
        end: endDate,
        timelineWidth: 60,
        breakHeight: 35,
        cellHeight: 110);

    ScreenshotController()
        .captureFromWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      home: SizedBox(
        width: endDate.difference(startDate).inDays * 130 + 60,
        height: headerHeight + getTimelineHeight(timelines, 110, 35) + 500,
        child: Material(
          child: SlWeekView<EventData>(
            backgroundColor: white,
            size: Size(
              endDate.difference(startDate).inDays * 130 + 60,
              headerHeight + getTimelineHeight(timelines, 110, 35) + 500,
            ),
            columnWidth: 130,
            onImageCapture: (Uint8List data) {},
            fullWeek: true,
            timelines: timelines,
            onEventDragged: (CalendarEvent<EventData> old,
                CalendarEvent<EventData> newEvent, Period period) {},
            onWillAccept: (CalendarEvent<EventData>? event, Period period) =>
                true,
            nowIndicatorColor: primaryPink,
            cornerBuilder: (DateTime current) => Container(
              color: white,
            ),
            items: event,
            onTap: (DateTime date, Period period,
                CalendarEvent<EventData>? event) {},
            headerHeight: 40,
            headerCellBuilder: (DateTime date) => Container(
              color: white,
              child: Column(
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
                          style: context.headline1WithNotoSans.copyWith(
                              color: isSameDate(date) ? Colors.white : null),
                        ),
                      )),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
            hourLabelBuilder: (Period period) {
              final TimeOfDay start = period.startTime;

              final TimeOfDay end = period.endTime;
              return Container(
                color: white,
                child: period.isBreak
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(period.title ?? '',
                              style: context.hourLabelTablet),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(start.format(context).substring(0, 5),
                              style: context.hourLabelTablet),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(end.format(context).substring(0, 5),
                              style: context.hourLabelTablet),
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
            itemBuilder: (CalendarEvent<EventData> item, double width) =>
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
                      ? SizedBox(
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
                  color: period.isBreak ? lightGrey : Colors.transparent),
            ),
          ),
        ),
      ),
    ))
        .then((Uint8List value) {
      log(' Week view image received from planner');
      BlocProvider.of<TimeTableCubit>(context).saveTomImage(value);
    });
  }
}
