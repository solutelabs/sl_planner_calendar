import 'package:edgar_planner_calendar_flutter/core/colors.dart';
import 'package:edgar_planner_calendar_flutter/core/text_styles.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_cubit.dart';
import 'package:edgar_planner_calendar_flutter/features/calendar/presentation/bloc/time_table_event_state.dart';
import 'package:edgar_planner_calendar_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///right strip for the tablet view
class RightStrip extends StatelessWidget {
  /// initialize the constructor
  const RightStrip({Key? key, this.width = 48, this.height = 60})
      : super(key: key);

  ///const double width
  final double width;

  ///const double height
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        child: BlocBuilder<TimeTableCubit, TimeTableState>(
          builder: (BuildContext context, TimeTableState state) {
            final CalendarViewType viewType =
                BlocProvider.of<TimeTableCubit>(context, listen: false)
                    .viewType;
            return Column(
              children: <Widget>[
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).day,
                  onTap: () {
                    if (viewType != CalendarViewType.dayView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.dayView);
                    }
                  },
                  selected: viewType == CalendarViewType.dayView,
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).week,
                  onTap: () {
                    if (viewType != CalendarViewType.weekView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.weekView);
                    }
                  },
                  selected: viewType == CalendarViewType.weekView,
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).month,
                  onTap: () {
                    if (viewType != CalendarViewType.monthView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.monthView);
                    }
                  },
                  selected: viewType == CalendarViewType.monthView,
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).term1,
                  onTap: () {
                    if (viewType != CalendarViewType.termView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.termView);
                    }
                    final DateTime e = DateTime.now();
                    final DateTime firstDate = DateTime(e.year);
                    final DateTime lastDate =
                        DateTime(e.year, 4).subtract(const Duration(days: 1));

                    BlocProvider.of<TimeTableCubit>(context, listen: false)
                        .changeDate(firstDate, lastDate);
                  },
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).term2,
                  onTap: () {
                    if (viewType != CalendarViewType.termView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.termView);
                    }
                    final DateTime e = DateTime.now();
                    final DateTime firstDate = DateTime(e.year, 4);
                    final DateTime lastDate =
                        DateTime(e.year, 7).subtract(const Duration(days: 1));

                    BlocProvider.of<TimeTableCubit>(context, listen: false)
                        .changeDate(firstDate, lastDate);
                  },
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).term3,
                  onTap: () {
                    if (viewType != CalendarViewType.termView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.termView);
                    }
                    final DateTime e = DateTime.now();
                    final DateTime firstDate = DateTime(e.year, 7);
                    final DateTime lastDate =
                        DateTime(e.year, 10).subtract(const Duration(days: 1));

                    BlocProvider.of<TimeTableCubit>(context, listen: false)
                        .changeDate(firstDate, lastDate);
                  },
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).term4,
                  onTap: () {
                    if (viewType != CalendarViewType.termView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.termView);
                    }
                    final DateTime e = DateTime.now();
                    final DateTime firstDate = DateTime(e.year, 10);
                    final DateTime lastDate = DateTime(e.year, 12, 31);

                    BlocProvider.of<TimeTableCubit>(context, listen: false)
                        .changeDate(firstDate, lastDate);
                  },
                )),
                Expanded(
                    child: RightSideButton(
                  title: S.of(context).records,
                  onTap: () {
                    if (viewType != CalendarViewType.dayView) {
                      BlocProvider.of<TimeTableCubit>(context, listen: false)
                          .changeViewType(CalendarViewType.dayView);
                    }
                  },
                )),
              ],
            );
          },
        ),
      );
}

///sideButton of the strips
class RightSideButton extends StatelessWidget {
  ///initialize side button
  const RightSideButton(
      {required this.title, this.selected = false, Key? key, this.onTap})
      : super(key: key);

  ///onTap callBack
  final Function? onTap;

  ///Title
  final String title;

  /// true if selected
  final bool selected;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: selected ? grey : Colors.transparent,
            border: Border.all(color: lightGrey),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
        child: RotatedBox(
            quarterTurns: 1,
            child: Center(
                child: Text(
              title,
              style: context.stripsTheme
                  .copyWith(color: selected ? Colors.black : null),
            ))),
      ));
}
