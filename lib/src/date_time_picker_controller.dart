import 'dart:math';

import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/model/day.dart';
import 'package:date_time_picker_widget/src/model/timeslot.dart';
import 'package:date_time_picker_widget/src/model/week.dart';
import 'package:rxdart/rxdart.dart';

/// The controller controls all changes. It informs the views if any change
/// occurs and verifies that the changes do not validate the constraints.
class DateTimePickerController {
  final DateTimePickerModel model;

  late DateTime selectedDateTime;

  late final DateTime _firstDay;

  late final Subject<SelectedTimestamp> _selectedInject;

  late final Subject<SelectedPage> _pageInject;

  /// currently shown weeks
  List<Week>? _currentWeeks;

  int _currentPage = 0;

  int _maxPages = 0;

  Day? _currentDay;

  DateTimePickerController({required this.model}) {
    _selectedInject = BehaviorSubject<SelectedTimestamp>();
    _pageInject = BehaviorSubject<SelectedPage>();
    selectedDateTime = model.initialDateTime;
    if (model.minTime != null &&
        model.minTime! >
            (selectedDateTime.millisecond +
                selectedDateTime.second * 1000 +
                selectedDateTime.minute * 60 * 1000 +
                selectedDateTime.hour * 60 * 60 * 1000)) {
      if (model.isUtc)
        selectedDateTime = DateTime.utc(
            selectedDateTime.year,
            selectedDateTime.month,
            selectedDateTime.day,
            (model.minTime! / 60 / 60 / 1000).floor(),
            ((model.minTime! % (60 * 60 * 1000)) / 60 / 1000).floor(),
            ((model.minTime! % (60 * 1000)) / 1000).floor(),
            ((model.minTime! % 1000)).floor());
      else
        selectedDateTime = DateTime(
            selectedDateTime.year,
            selectedDateTime.month,
            selectedDateTime.day,
            (model.minTime! / 60 / 60 / 1000).floor(),
            ((model.minTime! % (60 * 60 * 1000)) / 60 / 1000).floor(),
            ((model.minTime! % (60 * 1000)) / 1000).floor(),
            ((model.minTime! % 1000)).floor());
    }
    if (model.maxTime != null &&
        model.maxTime! <
            (selectedDateTime.millisecond +
                selectedDateTime.second * 1000 +
                selectedDateTime.minute * 60 * 1000 +
                selectedDateTime.hour * 60 * 60 * 1000)) {
      if (model.isUtc)
        selectedDateTime = DateTime.utc(
            selectedDateTime.year,
            selectedDateTime.month,
            selectedDateTime.day,
            (model.maxTime! / 60 / 60 / 1000).floor(),
            ((model.maxTime! % (60 * 60 * 1000)) / 60 / 1000).floor(),
            ((model.maxTime! % (60 * 1000)) / 1000).floor(),
            ((model.maxTime! % 1000)).floor());
      else
        selectedDateTime = DateTime(
            selectedDateTime.year,
            selectedDateTime.month,
            selectedDateTime.day,
            (model.maxTime! / 60 / 60 / 1000).floor(),
            ((model.maxTime! % (60 * 60 * 1000)) / 60 / 1000).floor(),
            ((model.maxTime! % (60 * 1000)) / 1000).floor(),
            ((model.maxTime! % 1000)).floor());
    }
    // calculate first day at first page
    this._firstDay = _calculateFirstDayOfWeek(DateTime.utc(1970, 1, 6));
    int difference = selectedDateTime.millisecondsSinceEpoch -
        _firstDay.millisecondsSinceEpoch;
    // difference in weeks:
    difference = (difference / 1000 / 60 / 60 / 24 / 7).floor();
    int currentPage = (difference / model.numberOfWeeksToDisplay).floor();
    _maxPages = currentPage + 500;
    setPageNbr(currentPage);
    // inform listeners about initial status
    _currentDay = _createDay(selectedDateTime);
    _selectedInject.add(SelectedTimestamp(selectedDateTime, _currentDay!));
  }

  void dispose() {
    _selectedInject.close();
  }

  Stream<SelectedTimestamp> get selectedTimestampObserve =>
      _selectedInject.stream;

  Stream<SelectedPage> get selectedPageObserve => _pageInject.stream;

  int get currentPage => _currentPage;

  int get maxPages => _maxPages;

  List<Week> getWeeks(int pageNbr) {
    if (_currentPage == pageNbr) {
      return _currentWeeks!;
    }
    List<Week> result = [];
    for (int i = 0; i < model.numberOfWeeksToDisplay; ++i) {
      result.add(_createWeek(pageNbr * model.numberOfWeeksToDisplay + i));
    }
    return result;
  }

  void setPageNbr(int pageNbr, [String? origin]) {
    if (_currentPage == pageNbr) {
      return;
    }
    List<Week> result = getWeeks(pageNbr);
    _currentWeeks = result;
    _currentPage = pageNbr;
    _pageInject.add(SelectedPage(pageNbr, _currentWeeks!, origin));
  }

  DateTime _calculateFirstDayOfWeek(DateTime dt) {
    DateTime result;
    if (model.firstDayOfWeek == DateTime.monday) {
      result = dt.add(Duration(days: -1 * dt.weekday + 1));
    } else {
      result = dt.add(Duration(days: -1 * dt.weekday));
    }
    return result;
  }

  Week _createWeek(int nbr) {
    DateTime dt = _firstDay.add(Duration(days: DateTime.daysPerWeek * nbr));
    Week week = Week();
    for (int i = 0; i < DateTime.daysPerWeek; ++i) {
      Day day = _createDay(dt);
      if (selectedDateTime == day.date) {
        // this is the selected day
        _currentDay = day;
      }
      week.days.add(day);
      //print("dt is $dt for ${model.timeInterval} and day ${day.date}");
      dt = dt.add(Duration(days: 1));
    }
    return week;
  }

  Day _createDay(DateTime dt) {
    Day day = Day(date: dt);
    if (model.minDateTime != null &&
        DateTime(model.minDateTime!.year, model.minDateTime!.month,
                    model.minDateTime!.day)
                .millisecondsSinceEpoch >
            dt.millisecondsSinceEpoch) {
      day.enabled = false;
    }
    if (model.maxDateTime != null &&
        DateTime(model.maxDateTime!.year, model.maxDateTime!.month,
                    model.maxDateTime!.day)
                .add(const Duration(days: 1))
                .millisecondsSinceEpoch <
            dt.millisecondsSinceEpoch) {
      day.enabled = false;
    }
    _createTimeslots(day);
    if (model.onDayCreated != null) model.onDayCreated!(day);
    return day;
  }

  void _createTimeslots(Day day) {
    DateTime dt = model.isUtc
        ? DateTime.utc(day.date.year, day.date.month, day.date.day)
        : DateTime(day.date.year, day.date.month, day.date.day);
    while (dt.day == day.date.day) {
      if ((model.minTime == null ||
              model.minTime! <=
                  (dt.millisecond +
                      dt.second * 1000 +
                      dt.minute * 60 * 1000 +
                      dt.hour * 60 * 60 * 1000)) &&
          (model.maxTime == null ||
              model.maxTime! >=
                  (dt.millisecond +
                      dt.second * 1000 +
                      dt.minute * 60 * 1000 +
                      dt.hour * 60 * 60 * 1000))) {
        Timeslot timeslot = Timeslot(date: dt);
        if (model.minDateTime != null &&
            model.minDateTime!.millisecondsSinceEpoch >
                dt.millisecondsSinceEpoch) {
          timeslot.enabled = false;
        }
        if (model.maxDateTime != null &&
            model.maxDateTime!.millisecondsSinceEpoch <
                dt.millisecondsSinceEpoch) {
          timeslot.enabled = false;
        }
        day.timeslots.add(timeslot);
      }
      dt = dt.add(model.timeInterval);
    }
  }

  void previousMonth() {
    if (_currentPage < (4 / model.numberOfWeeksToDisplay).ceil()) return;
    setPageNbr(_currentPage - (4 / model.numberOfWeeksToDisplay).ceil());
  }

  void nextMonth() {
    if (_currentPage > _maxPages - (4 / model.numberOfWeeksToDisplay).ceil())
      return;
    setPageNbr(_currentPage + (4 / model.numberOfWeeksToDisplay).ceil());
  }

  void previousYear() {
    if (_currentPage < (12 * 4 / model.numberOfWeeksToDisplay).ceil()) return;
    setPageNbr(_currentPage - (12 * 4 / model.numberOfWeeksToDisplay).ceil());
  }

  void nextYear() {
    if (_currentPage >
        _maxPages - (12 * 4 / model.numberOfWeeksToDisplay).ceil()) return;
    setPageNbr(_currentPage + (12 * 4 / model.numberOfWeeksToDisplay).ceil());
  }

  List<Timeslot> getTimeslotsForSelectedDay() {
    if (_currentDay != null) return _currentDay!.timeslots;
    if (_currentWeeks == null) getWeeks(_currentPage);
    for (Week week in _currentWeeks!) {
      for (Day day in week.days) {
        if (isSelectedDay(day.date)) return day.timeslots;
      }
    }
    throw Exception("Unexpected: timeslot for $selectedDateTime not found");
  }

  void setDay(DateTime day) {
    selectedDateTime = DateTime.utc(
        day.year,
        day.month,
        day.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
        selectedDateTime.second,
        selectedDateTime.millisecond,
        selectedDateTime.microsecond);
    if (model.minDateTime != null &&
        model.minDateTime!.millisecondsSinceEpoch >
            selectedDateTime.millisecondsSinceEpoch) {
      selectedDateTime = model.minDateTime!;
    }
    if (model.maxDateTime != null &&
        model.maxDateTime!.millisecondsSinceEpoch <
            selectedDateTime.millisecondsSinceEpoch) {
      selectedDateTime = model.maxDateTime!;
    }
    _currentDay = _createDay(selectedDateTime);
    _selectedInject.add(SelectedTimestamp(selectedDateTime, _currentDay!));
  }

  void setTime(DateTime time) {
    selectedDateTime = DateTime.utc(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        time.hour,
        time.minute,
        time.second,
        time.millisecond,
        time.microsecond);
    _selectedInject.add(SelectedTimestamp(selectedDateTime, _currentDay!));
  }

  bool isSelectedDay(DateTime day) {
    return day.year == selectedDateTime.year &&
        day.month == selectedDateTime.month &&
        day.day == selectedDateTime.day;
  }

  bool isSelectedTime(DateTime dateTime) {
    return isSelectedDay(dateTime) &&
        dateTime.hour == selectedDateTime.hour &&
        dateTime.minute == selectedDateTime.minute;
  }

  DateTime _addMonths(DateTime from, int months) {
    final r = months % 12;
    final q = (months - r) ~/ 12;
    var newYear = from.year + q;
    var newMonth = from.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(from.day, _daysInMonth(newYear, newMonth));
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  }

  static const _daysInMonthArray = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  int _daysInMonth(int year, int month) {
    var result = _daysInMonthArray[month];
    if (month == 2 && _isLeapYear(year)) result++;
    return result;
  }

  bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}

/////////////////////////////////////////////////////////////////////////////

class SelectedTimestamp {
  final DateTime dateTime;

  final Day day;

  const SelectedTimestamp(this.dateTime, this.day);
}

/////////////////////////////////////////////////////////////////////////////

class SelectedPage {
  final int pageNbr;

  final List<Week> weeks;

  final String? origin;

  const SelectedPage(this.pageNbr, this.weeks, this.origin);
}
