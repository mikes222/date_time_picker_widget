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

  String monthYearToView(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  String dateToView(DateTime dateTime) {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  String timeToView(DateTime dateTime) {
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
