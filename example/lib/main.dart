import 'package:example/features/calendar/presentation/bloc/event_cubit.dart';
import 'package:example/features/calendar/presentation/pages/planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
