import 'package:example/bloc/event_cubit.dart';
import 'package:example/bloc/event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTimeTable extends StatefulWidget {
  @override
  _MyTimeTableState createState() => _MyTimeTableState();
}

class _MyTimeTableState extends State<MyTimeTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies'),
      ),
      body: Column(
        children: [
          BlocBuilder<EventCubit, EventState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddeingEvent) {
                return const Center(
                  child: Icon(Icons.close),
                );
              } else if (state is LoadedState) {
                final events = state.events;
                return SizedBox.shrink();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
