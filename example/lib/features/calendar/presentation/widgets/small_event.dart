import 'package:edgar_planner_calendar_flutter/core/colors.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/data/event_model.dart';
import 'package:flutter/material.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';
import 'package:edgar_planner_calendar_flutter/core/text_styles.dart';

///small even tile
class SmallEventTile extends StatelessWidget {
  ///small event constructor
  const SmallEventTile(
      {required this.event, Key? key, this.tileHeight = 30, this.width})
      : super(key: key);

  ///heigh of the tile
  final double tileHeight;

  ///double width
  final double? width;

  ///Calendar event
  final CalendarEvent<Event> event;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(1),
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        height: tileHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: event.eventData!.color),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.circle,
              color: Colors.black,
              size: 10,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                event.eventData!.title,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      );
}

///small even tile
class ExtraSmallEventTile extends StatelessWidget {
  ///small event constructor
  const ExtraSmallEventTile(
      {required this.event, Key? key, this.tileHeight = 19, this.width})
      : super(key: key);

  ///heigh of the tile
  final double tileHeight;

  ///double width
  final double? width;

  ///Calendar event
  final CalendarEvent<Event> event;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(1),
        width: width,
        height: tileHeight,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: event.eventData!.color),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.circle,
              color: Colors.black,
              size: 6,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                event.eventData!.title,
                maxLines: 1,
                style: context.subtitle1.copyWith(color: textBlack),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      );
}
