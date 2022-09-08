import 'package:edgar_planner_calendar_flutter/core/fonts.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_cubit.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

/// root app of the module
class MyApp extends StatelessWidget {
  ///
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<TimeTableCubit>(
        create: (BuildContext context) => TimeTableCubit(),
        child: MaterialApp(
          theme: ThemeData(fontFamily: Fonts.sofiaPro),
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => const Planner(),
          },
        ),
      );
}
