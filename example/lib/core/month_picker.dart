import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

///custome month picker model
class CustomMonthPicker extends DatePickerModel {
  ///custommonth pciker
  CustomMonthPicker(
      {required DateTime currentTime,
      required DateTime minTime,
      required DateTime maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() => <int>[1, 1, 0];
}
