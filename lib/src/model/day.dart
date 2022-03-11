import 'package:date_time_picker_widget/src/model/timeslot.dart';

class Day {
  //final int index;
  bool enabled;
  DateTime date;

  List<Timeslot> timeslots = [];

  Day({this.enabled = true, required this.date});
}
