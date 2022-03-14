import 'package:intl/intl.dart';

class DateTimePickerViewConverter {
  final String pickADateText;

  final String pickATimeText;

  final bool is24h;

  DateTimePickerViewConverter(
      {this.pickADateText = "Pick a date",
      this.pickATimeText = "Pick a time",
      this.is24h = false});

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
    return DateFormat(is24h ? 'HH:mm' : 'hh:mm aa').format(dateTime);
  }

  String getPickADateText() {
    return pickADateText;
  }

  String getPickATimeText() {
    return pickATimeText;
  }
}
