import 'dart:math'; 
import 'package:example/features/calendar/presentation/bloc/event_cubit.dart';
import 'package:example/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => BlocProvider<EventCubit>(
        create: (context) => EventCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const Planner(), 
          },
        ),
      );
}

// /// Plain old default time table screen.
// class TimetableScreen extends StatefulWidget {
//   const TimetableScreen({Key? key}) : super(key: key);

//   @override
//   State<TimetableScreen> createState() => _TimetableScreenState();
// }

// class _TimetableScreenState extends State<TimetableScreen> {
//   final simpleController = TimetableController(
//       start:
//           DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 7)),
//       initialColumns: 3,
//       cellHeight: 100);
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         simpleController.jumpTo(now);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey,
//           actions: [
//             TextButton(
//               onPressed: () async => Navigator.pushNamed(context, '/custom'),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: const [
//                   Icon(Icons.celebration_outlined, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     "Custom builders",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   SizedBox(width: 8),
//                   Icon(Icons.chevron_right_outlined, color: Colors.white),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: Timetable(
//           timelines: customeTilenes,
//           hourLabelBuilder: (period) {
//             var start = TimeOfDay(
//               hour: period.starttime.hour,
//               minute: period.starttime.minute,
//             );

//             var end = TimeOfDay(
//               hour: period.endTime.hour,
//               minute: period.endTime.minute,
//             );
//             return Container(
//               decoration: BoxDecoration(
//                   color: period.isBreak
//                       ? Colors.grey.withOpacity(0.5)
//                       : Colors.white),
//               child: period.isBreak
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(period.title ?? "",
//                             style: const TextStyle(fontSize: 11)),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(start.format(context),
//                             style: const TextStyle(fontSize: 11)),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Text(end.format(context),
//                             style: const TextStyle(fontSize: 11)),
//                       ],
//                     ),
//             );
//           },
//           items: generateItems(),
//           controller: simpleController,
//           cellBuilder: (datetime) => Container(
//             decoration: BoxDecoration(
//               border:
//                   Border.all(color: Colors.red.withOpacity(0.5), width: 0.2),
//             ),
//             child: Center(
//               child: Text(
//                 DateFormat("MM/d/yyyy\nha").format(datetime.starttime),
//                 style: const TextStyle(color: Colors.blue
//                     // color: Color(0xff000000 +
//                     //         (0x002222 * datetime.hour) +
//                     //         (0x110000 * datetime.day))
//                     //     .withOpacity(0.5),
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       );
// }

// /// Timetable screen with all the stuff - controller, builders, etc.
// class CustomTimetableScreen extends StatefulWidget {
//   const CustomTimetableScreen({Key? key}) : super(key: key);
//   @override
//   State<CustomTimetableScreen> createState() => _CustomTimetableScreenState();
// }

// class _CustomTimetableScreenState extends State<CustomTimetableScreen> {
//   final items = generateItems();
//   final controller = TimetableController(
//     start: DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 7)),
//     initialColumns: 3,
//     cellHeight: 180.0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         controller.jumpTo(DateTime.now());
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey,
//           actions: [
//             TextButton(
//               onPressed: () async => Navigator.pop(context),
//               child: Row(
//                 children: const [
//                   Icon(Icons.chevron_left_outlined, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     "Default",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_day),
//               onPressed: () => controller.setColumns(1),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_month_outlined),
//               onPressed: () => controller.setColumns(3),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_week),
//               onPressed: () => controller.setColumns(5),
//             ),
//             IconButton(
//               icon: const Icon(Icons.zoom_in),
//               onPressed: () =>
//                   controller.setCellHeight(controller.cellHeight + 10),
//             ),
//             IconButton(
//               icon: const Icon(Icons.zoom_out),
//               onPressed: () =>
//                   controller.setCellHeight(controller.cellHeight - 10),
//             ),
//           ],
//         ),
//         body: Timetable<String>(
//           controller: controller,
//           timelines: customeTilenes,
//           items: items,
//           cellBuilder: (datetime) => Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blueGrey, width: 0.2),
//             ),
//             child: Center(
//               child: Text(
//                 DateFormat("MM/d/yyyy\nha").format(datetime.starttime),
//                 style: const TextStyle(color: Colors.blue
//                     // color: Color(0xff000000 +
//                     //         (0x002222 * datetime.hour) +
//                     //         (0x110000 * datetime.day))
//                     //     .withOpacity(0.5),
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           cornerBuilder: (datetime) => Container(
//             color: Colors.accents[datetime.day % Colors.accents.length],
//             child: Center(child: Text("${datetime.year}")),
//           ),
//           headerCellBuilder: (datetime) {
//             final color =
//                 Colors.primaries[datetime.day % Colors.accents.length];
//             return Container(
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: color, width: 2)),
//               ),
//               child: Center(
//                 child: Text(
//                   DateFormat("E\nMMM d").format(datetime),
//                   style: TextStyle(
//                     color: color,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           },
//           hourLabelBuilder: (period) {
//             var start = TimeOfDay(
//               hour: period.starttime.hour,
//               minute: period.starttime.minute,
//             );

//             var end = TimeOfDay(
//               hour: period.endTime.hour,
//               minute: period.endTime.minute,
//             );
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(start.format(context),
//                     style: const TextStyle(fontSize: 11)),
//                 Text(end.format(context), style: const TextStyle(fontSize: 11)),
//               ],
//             );
//           },
//           itemBuilder: (item) => Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withAlpha(220),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 item.data ?? "",
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ),
//           nowIndicatorColor: Colors.red,
//           snapToDay: true,
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Text("Now"),
//           onPressed: () => controller.jumpTo(DateTime.now()),
//         ),
//       );
// }

// /// Generates some random items for the timetable.
// List<TimetableItem<String>> generateItems() {
//   final random = Random();
//   final items = <TimetableItem<String>>[];
//   final today = DateUtils.dateOnly(DateTime.now());
//   for (var i = 0; i < 100; i++) {
//     int hourOffset = random.nextInt(56 * 24) - (7 * 24);
//     final date = today.add(Duration(hours: hourOffset));
//     items.add(TimetableItem(
//       date,
//       date.add(Duration(minutes: (random.nextInt(8) * 15) + 15)),
//       data: "item $i",
//     ));
//   }
//   return items;
// }

// DateTime now = DateTime.now();
// double ceilHeight = 80;
// List<Period> customeTilenes = [
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 9, 30),
//       endTime: DateTime(now.year, now.month, now.day, 9, 45),
//       height: ceilHeight),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 9, 45),
//       endTime: DateTime(now.year, now.month, now.day, 10, 30),
//       height: ceilHeight),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 10, 30),
//       endTime: DateTime(now.year, now.month, now.day, 11, 0),
//       isBreak: true,
//       title: "Recess",
//       height: 45),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 11, 0),
//       endTime: DateTime(now.year, now.month, now.day, 11, 45),
//       height: ceilHeight),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 11, 45),
//       endTime: DateTime(now.year, now.month, now.day, 12, 30),
//       height: ceilHeight),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 12, 30),
//       endTime: DateTime(now.year, now.month, now.day, 1, 30),
//       height: 45,
//       isBreak: true,
//       title: "Lunch"),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 1, 30),
//       endTime: DateTime(now.year, now.month, now.day, 2, 15),
//       height: ceilHeight),
//   Period(
//       starttime: DateTime(now.year, now.month, now.day, 2, 15),
//       endTime: DateTime(now.year, now.month, now.day, 3, 0),
//       height: ceilHeight),
// ];
