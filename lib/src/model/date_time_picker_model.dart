import 'package:date_time_picker_widget/src/date_time_picker_view_converter.dart';

class DateTimePickerModel {
  /// The initial timestamp to show when opening that widget
  late final int initialTimestamp;

  /// The minimum timestamp which can be chosen by the user
  late final int? minTimestamp;

  /// The maximum timestamp which can be chosen by the user
  late final int? maxTimestamp;

  /// The interval in milliseconds between the elements. Minimum is 1 minute (=60*1000 milliseconds)
  int timeInterval;

  final int numberOfWeeksToDisplay;

  final int firstDayOfWeek;

  final Function(int timestamp)? onDateTimeChanged;

  late final DateTimePickerViewConverter viewConverter;

  /// if set all time entries less than the given time in milliseconds will not be shown
  late final int? minTime;

  /// if set all time entries largen than the given time in milliseconds will not be shown
  late final int? maxTime;

  DateTimePickerModel({
    int? initialTimestamp,
    int? minTimestamp,
    int? maxTimestamp,
    this.firstDayOfWeek = DateTime.sunday,
    this.timeInterval = 60 * 1000,
    this.onDateTimeChanged,
    DateTimePickerViewConverter? viewConverter,
    this.numberOfWeeksToDisplay = 4,
    int? minTime,
    int? maxTime,
  })  : assert(timeInterval >= 60 * 1000),
        assert(timeInterval % (60 * 1000) == 0),
        assert(firstDayOfWeek == DateTime.sunday ||
            firstDayOfWeek == DateTime.monday),
        assert(minTime == null || minTime > 0),
        assert(
            maxTime == null || (maxTime > 0 && maxTime < 24 * 60 * 60 * 1000)),
        assert(minTime == null || maxTime == null || minTime < maxTime),
        assert(initialTimestamp == null ||
            minTimestamp == null ||
            minTimestamp <= initialTimestamp),
        assert(initialTimestamp == null ||
            maxTimestamp == null ||
            maxTimestamp >= initialTimestamp) {
    this.initialTimestamp = _calculateInitialTimestamp(initialTimestamp);
    this.minTimestamp =
        minTimestamp == null ? null : _roundTimestamp(minTimestamp);
    this.maxTimestamp =
        maxTimestamp == null ? null : _roundTimestamp(maxTimestamp);
    this.viewConverter = viewConverter ?? DateTimePickerViewConverter();
    this.minTime = minTime == null ? null : _roundTimestamp(minTime);
    this.maxTime = maxTime == null ? null : _roundTimestamp(maxTime);
  }

  int _roundTimestamp(int timestamp) {
    return (timestamp / timeInterval).round() * timeInterval;
  }

  int _calculateInitialTimestamp(int? timestamp) {
    int result = timestamp ?? DateTime.now().millisecondsSinceEpoch;
    return _roundTimestamp(result);
  }
}
