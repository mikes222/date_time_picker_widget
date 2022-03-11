import 'package:intl/intl.dart';

class DateTimePickerViewConverter {
  final Map<int, String> weekdays = {
    DateTime.sunday: 'S',
    DateTime.monday: 'M',
    DateTime.tuesday: 'T',
    DateTime.wednesday: 'W',
    DateTime.thursday: 'T',
    DateTime.friday: 'F',
    DateTime.saturday: 'S',
  };

  String monthYearToView(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  String dateToView(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  String timeToView(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    return DateFormat('HH:mm' /*: 'hh:mm aa'*/).format(dateTime);
  }

  String pickADateText() {
    return "Pick a Date";
  }

  String pickATimeText() {
    return "Pick a Time";
  }

  DateTimePickerViewConverter();
}
