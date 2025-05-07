import 'package:date_time_picker_widget/src/date_time_picker_view_converter.dart';
import 'package:date_time_picker_widget/src/model/day.dart';

/// The model holds all parameters on how to behave with datepicker
class DateTimePickerModel {
  /// The initial timestamp to show when opening that widget
  late final DateTime initialDateTime;

  /// The minimum timestamp which can be chosen by the user
  late final DateTime? minDateTime;

  /// The maximum timestamp which can be chosen by the user
  late final DateTime? maxDateTime;

  /// The interval in milliseconds between the elements. Minimum is 1 minute (=60*1000 milliseconds)
  late final Duration timeInterval;

  final int numberOfWeeksToDisplay;

  final int firstDayOfWeek;

  final Function(DateTime dateTime)? onDateTimeChanged;

  /// Use this function to manipulate a day or timeslots and enable/disable them individually
  final Function(Day day)? onDayCreated;

  late final DateTimePickerViewConverter viewConverter;

  /// if set all time entries less than the given time in milliseconds will not be shown
  late final int? minTime;

  /// if set all time entries largen than the given time in milliseconds will not be shown
  late final int? maxTime;

  late final bool isUtc;

  DateTimePickerModel({
    /// The initial datetime. Depending on this field the isUTC will be set to true or false
    required DateTime initialDateTime,
    // The minimum date/time which can be picked by the user. See also
    // [maxDateTime]
    DateTime? minDateTime,

    /// The maximum date/time which can be picked by the user. Take care of
    /// Winter/Summer-time-changes. For example during winter time if you add
    /// a few days to calculate the maxtime and the calculated maxtime is in
    /// the summertime the DateTime class automatically adds one hour to the
    /// enddate.
    DateTime? maxDateTime,
    this.firstDayOfWeek = DateTime.sunday,
    this.timeInterval = const Duration(minutes: 1),
    this.onDateTimeChanged,
    DateTimePickerViewConverter? viewConverter,
    this.numberOfWeeksToDisplay = 4,

    /// The timepicker will not show times before the minTime. This can be used
    /// to reflect office hours
    Duration? minTime,

    /// The timepicker will not show times after the maxTime. This can be used
    /// to reflect office hours
    Duration? maxTime,
    this.onDayCreated,
  })  : assert(timeInterval.inMinutes >= 1),
        assert(timeInterval.inMilliseconds % (60 * 1000) == 0),
        assert(firstDayOfWeek == DateTime.sunday || firstDayOfWeek == DateTime.monday),
        assert(minTime == null || minTime.inMilliseconds > 0),
        assert(maxTime == null || (maxTime.inMilliseconds > 0 && maxTime.inHours < 24)),
        assert(minTime == null || maxTime == null || minTime < maxTime),
        // allow time exceeds the boundaries when starting up (but do not allow to pick a time outside the boundaries)
        // assert(minDateTime == null ||
        //     minDateTime.millisecondsSinceEpoch <=
        //         initialDateTime.millisecondsSinceEpoch),
        // assert(maxDateTime == null ||
        //     maxDateTime.millisecondsSinceEpoch >=
        //         initialDateTime.millisecondsSinceEpoch),
        assert(numberOfWeeksToDisplay > 0) {
    isUtc = initialDateTime.isUtc;
    this.minDateTime = minDateTime == null ? null : roundDateTime(minDateTime);
    this.maxDateTime = maxDateTime == null ? null : roundDateTime(maxDateTime);
    this.viewConverter = viewConverter ?? DateTimePickerViewConverter();
    this.minTime = minTime == null ? null : roundTimestamp(minTime.inMilliseconds);
    this.maxTime = maxTime == null ? null : roundTimestamp(maxTime.inMilliseconds);
    this.initialDateTime = roundMinMaxDateTime(initialDateTime);
  }

  int roundTimestamp(int timestamp) {
    // use floor to round down. So that 14:47 and 53 seconds will be rounded to 14:47 and not 14:48 which would be confusing
    return (timestamp / timeInterval.inMilliseconds).floor() * timeInterval.inMilliseconds;
  }

  /// rounds the given time according to the settings and make sure it is in
  /// the given boundary of [minDateTime] and [maxDateTime]
  int roundMinMaxTimestamp(int timestamp) {
    int result = roundTimestamp(timestamp);
    if (minDateTime != null && result < minDateTime!.millisecondsSinceEpoch) {
      result = minDateTime!.millisecondsSinceEpoch;
    }
    if (maxDateTime != null && result > maxDateTime!.millisecondsSinceEpoch) {
      result = maxDateTime!.millisecondsSinceEpoch;
    }
    return result;
  }

  /// rounds the given time according to the settings, especially the timeInterval
  DateTime roundDateTime(DateTime dateTime) {
    final Duration d = Duration(hours: dateTime.hour, minutes: dateTime.minute);
    // use floor to round down. So that 14:47 and 53 seconds will be rounded to 14:47 and not 14:48 which would be confusing
    final int milliseconds = (d.inMilliseconds / timeInterval.inMilliseconds).floor() * timeInterval.inMilliseconds;
    if (isUtc) {
      return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, (milliseconds / 60 / 60 / 1000).floor(), (milliseconds / 60 / 1000).floor() % 60);
    } else {
      return DateTime(dateTime.year, dateTime.month, dateTime.day, (milliseconds / 60 / 60 / 1000).floor(), (milliseconds / 60 / 1000).floor() % 60);
    }
  }

  /// rounds the given time according to the settings and make sure it is in
  /// the given boundary of [minDateTime] and [maxDateTime]
  DateTime roundMinMaxDateTime(DateTime dateTime) {
    DateTime result = roundDateTime(dateTime);
    if (minDateTime != null && minDateTime!.isAfter(result)) {
      result = minDateTime!;
    }
    if (maxDateTime != null && maxDateTime!.isBefore(result)) {
      result = maxDateTime!;
    }
    return result;
  }
}
