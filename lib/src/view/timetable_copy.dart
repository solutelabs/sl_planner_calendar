// import 'package:flutter/material.dart';
// import 'package:sl_planner_calendar/sl_planner_calendar.dart';
// import 'package:sl_planner_calendar/src/core/enum.dart';
// import 'package:sl_planner_calendar/src/view/schedule_view.dart';
// import 'package:sl_planner_calendar/src/view/three_day_view.dart';

// /// The [SlCalendar] widget displays calendar like view of the events
// /// that scrolls
// class SlCalendar<T> extends StatefulWidget {
//   ///
//   const SlCalendar({
//     required this.timelines,
//     required this.onWillAccept,
//     Key? key,
//     this.onEventDragged,
//     this.controller,
//     this.cellBuilder,
//     this.headerCellBuilder,
//     // ignore: always_specify_types
//     this.items = const [],
//     this.itemBuilder,
//     this.fullWeek = false,
//     this.headerHeight = 45,
//     this.hourLabelBuilder,
//     this.nowIndicatorColor,
//     this.showNowIndicator = true,
//     this.cornerBuilder,
//     this.snapToDay = true,
//     this.onTap,
//   }) : super(key: key);

//   /// [TimetableController] is the controller that also initialize the timetable
//   final TimetableController? controller;

//   /// Renders for the cells the represent each hour that provides
//   /// that [DateTime] for that hour
//   final Widget Function(Period)? cellBuilder;

//   /// Renders for the header that provides the [DateTime] for the day
//   final Widget Function(DateTime)? headerCellBuilder;

//   /// Timetable items to display in the timetable
//   final List<CalendarEvent<T>> items;

//   /// Renders event card from `TimetableItem<T>` for each item
//   final Widget Function(CalendarEvent<T>)? itemBuilder;

//   /// Renders hour label given [TimeOfDay] for each hour
//   final Widget Function(Period period)? hourLabelBuilder;

//   /// Renders upper left corner of the timetable given the first visible date
//   final Widget Function(DateTime current)? cornerBuilder;

//   /// Snap to hour column. Default is `true`.
//   final bool snapToDay;

//   ///show now indicator,default is true
//   final bool showNowIndicator;

//   /// Color of indicator line that shows the current time.

//   ///  Default is `Theme.indicatorColor`.
//   final Color? nowIndicatorColor;

//   /// Full week only

//   final bool fullWeek;

//   /// height  of the header
//   final double headerHeight;

//   ///ontapt
//   final Function(DateTime dateTime, Period, CalendarEvent<T>?)? onTap;

//   /// The [SlCalendar] widget displays calendar like view
//   /// of the events that scrollsn

//   /// list of the timeline
//   final List<Period> timelines;

//   ///return new and okd event
//   final Function(CalendarEvent<T> old, CalendarEvent<T> newEvent)?
//       onEventDragged;

//   /// Called to determine whether this widget is interested in receiving a given
//   /// piece of data being dragged over this drag target.
//   ///
//   /// Called when a piece of data enters the target. This will be followed by
//   /// either [onAccept] and [onAcceptWithDetails], if the data is dropped, or
//   /// [onLeave], if the drag leaves the target.
//   final DragTargetWillAccept<CalendarEvent<T>> onWillAccept;

//   @override
//   State<SlCalendar<T>> createState() => _SlCalendarState<T>();
// }

// class _SlCalendarState<T> extends State<SlCalendar<T>> {
//   double columnWidth = 50;
//   TimetableController controller =
//       TimetableController(viewType: CalendarViewType.DayView);
//   final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

//   Color get nowIndicatorColor =>
//       widget.nowIndicatorColor ?? Theme.of(context).indicatorColor;
//   int? _listenerId;

//   @override
//   void initState() {
//     controller = widget.controller ?? controller;

//     super.initState();
//   }

//   @override
//   void dispose() {
//     if (_listenerId != null) {
//       controller.removeListener(_listenerId!);
//     }

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => LayoutBuilder(
//       key: _key,
//       builder: (BuildContext context, BoxConstraints contraints) {
//         switch (controller.viewType) {
//           case CalendarViewType.ShecduleView:
//             return SlScheduleView<T>(
//               timelines: widget.timelines,
//               onWillAccept: widget.onWillAccept,
//               cellBuilder: widget.cellBuilder,
//               controller: controller,
//               cornerBuilder: widget.cornerBuilder,
//               fullWeek: widget.fullWeek,
//               headerCellBuilder: widget.headerCellBuilder,
//               headerHeight: widget.headerHeight,
//               hourLabelBuilder: widget.hourLabelBuilder,
//               itemBuilder: widget.itemBuilder,
//               items: widget.items,
//               nowIndicatorColor: widget.nowIndicatorColor,
//               onEventDragged: widget.onEventDragged,
//               onTap: widget.onTap,
//               showNowIndicator: widget.showNowIndicator,
//               snapToDay: widget.snapToDay,
//             );
//           case CalendarViewType.DayView:
//             return Container();
//           case CalendarViewType.WeekView:
//             return SlWeekView<T>(
//               timelines: widget.timelines,
//               onWillAccept: widget.onWillAccept,
//               cellBuilder: widget.cellBuilder,
//               controller: controller,
//               cornerBuilder: widget.cornerBuilder,
//               fullWeek: widget.fullWeek,
//               headerCellBuilder: widget.headerCellBuilder,
//               headerHeight: widget.headerHeight,
//               hourLabelBuilder: widget.hourLabelBuilder,
//               itemBuilder: widget.itemBuilder,
//               items: widget.items,
//               nowIndicatorColor: widget.nowIndicatorColor,
//               onEventDragged: widget.onEventDragged,
//               onTap: widget.onTap,
//               showNowIndicator: widget.showNowIndicator,
//               snapToDay: widget.snapToDay,
//             );
//           default:
//             return Container(
//               child: Text("defauly"),
//             );
//             return SlWeekView<T>(
//               timelines: widget.timelines,
//               onWillAccept: widget.onWillAccept,
//               cellBuilder: widget.cellBuilder,
//               controller: controller,
//               cornerBuilder: widget.cornerBuilder,
//               fullWeek: widget.fullWeek,
//               headerCellBuilder: widget.headerCellBuilder,
//               headerHeight: widget.headerHeight,
//               hourLabelBuilder: widget.hourLabelBuilder,
//               itemBuilder: widget.itemBuilder,
//               items: widget.items,
//               nowIndicatorColor: widget.nowIndicatorColor,
//               onEventDragged: widget.onEventDragged,
//               onTap: widget.onTap,
//               showNowIndicator: widget.showNowIndicator,
//               snapToDay: widget.snapToDay,
//             );
//         }
//       });
// }
