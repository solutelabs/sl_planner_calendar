import 'package:example/core/colors.dart';
import 'package:example/features/calendar/data/event_model.dart';
import 'package:example/features/calendar/presentation/bloc/event_cubit.dart';
import 'package:example/features/calendar/presentation/bloc/event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:sl_planner_calendar/sl_planner_calendar.dart';

///
class AddPlan extends StatefulWidget {
  ////
  const AddPlan(
      {required this.date,
      required this.periods,
      Key? key,
      this.period,
      this.timetableItem})
      : super(key: key);

  ///date for the plan
  final DateTime date;

  ///periods for the plan
  final List<Period> periods;

  ///period fot the plan
  final Period? period;

  ///Timetable item if avaialable
  final TimetableItem<Event>? timetableItem;

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Period? period;
  Color? selectedColor;

  List<String> documents = <String>[
    'lession.pdf',
    'science.ppt',
    'ovrview.png'
  ];
  List<String> mydocs = <String>[];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Add Event',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              DropdownButton<Period>(
                  items: widget.periods
                      .map((Period e) => DropdownMenuItem<Period>(
                          value: e,
                          child: Text(
                              '${e.starttime.hour}:${e.starttime.minute} - ${e.endTime.hour}:${e.endTime.minute} ${e.isBreak ? e.title! : ''}')))
                      .toList(),
                  value: period,
                  hint: const Text('Select Period'),
                  isExpanded: true,
                  onChanged: (Period? e) {
                    period = e;
                    setState(() {});
                  }),
              TextField(
                controller: title,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              period == null || !period!.isBreak
                  ? Column(
                      children: [
                        TextField(
                          controller: description,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: mycolors.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final Color color = mycolors[index];
                              return InkWell(
                                onTap: () {
                                  selectedColor = color;
                                  setState(() {});
                                },
                                child: Center(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.blue,
                                            width:
                                                selectedColor == color ? 3 : 0),
                                        color: color),
                                  ),
                                ),
                              );
                            }),
                        MultipleSearchSelection<String>(
                          items: documents,
                          // List<Country>
                          fieldToCheck: (String c) => c,
                          itemBuilder: (String doc) => Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    doc,
                                  ),
                                ),
                              )),
                          pickedItemBuilder: (String doc) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(doc),
                            ),
                          ),
                          onTapShowedItem: () {},
                          onPickedChange: (List<String> items) {},
                          onItemAdded: (String item) {
                            mydocs.add(item);
                          },
                          onItemRemoved: (String item) {
                            mydocs.remove(item);
                          },
                          sortShowedItems: true,
                          sortPickedItems: true,
                          fuzzySearch: FuzzySearch.jaro,

                          padding: const EdgeInsets.all(0),
                          title: const Text(
                            'G Drive Documents',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          titlePadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          searchItemTextContentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              BlocBuilder<EventCubit, EventState>(
                  builder: (BuildContext context, EventState state) {
                if (state is AddeingEvent) {
                  return const CircularProgressIndicator.adaptive();
                }
                return ElevatedButton(
                    onPressed: () {
                      final DateTime start = DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.day,
                          widget.period!.starttime.hour,
                          widget.period!.starttime.minute);

                      final DateTime end = DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.day,
                          widget.period!.endTime.hour,
                          widget.period!.endTime.minute);

                      BlocProvider.of<EventCubit>(context, listen: false)
                          .addEvent(TimetableItem<Event>(start, end, 
                              data: Event(
                                  color: period!.isBreak
                                      ? darkGrey.withOpacity(0.3)
                                      : selectedColor!,
                                  description: description.text,
                                  title: title.text,
                                  period: period!,
                                  documents: mydocs)));
                    },
                    child: const Text('Add Event'));
              })
            ],
          ),
        ),
      );
}
