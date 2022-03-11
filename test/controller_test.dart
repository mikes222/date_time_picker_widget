import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('substracts one month from first of march', () {
    final int selectedTimestamp =
        DateTime.utc(2022, 3, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
    final DateTimePickerModel model =
        DateTimePickerModel(initialTimestamp: selectedTimestamp);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    controller.previousMonth();
    expect(controller.selectedDateTime.hour, 0);
    expect(controller.selectedDateTime.day, 1);
    expect(controller.selectedDateTime.month, 2);
    expect(controller.selectedDateTime.year, 2022);
  });

  test('substracts one month from last of march', () {
    final int selectedTimestamp =
        DateTime.utc(2022, 3, 31, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
    final DateTimePickerModel model =
        DateTimePickerModel(initialTimestamp: selectedTimestamp);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    controller.previousMonth();
    expect(controller.selectedDateTime.hour, 0);
    expect(controller.selectedDateTime.day, 28);
    expect(controller.selectedDateTime.month, 2);
    expect(controller.selectedDateTime.year, 2022);
  });

  test('substracts one month from last of january', () {
    final int selectedTimestamp =
        DateTime.utc(2022, 1, 31, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
    final DateTimePickerModel model =
        DateTimePickerModel(initialTimestamp: selectedTimestamp);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    controller.previousMonth();
    expect(controller.selectedDateTime.hour, 0);
    expect(controller.selectedDateTime.day, 31);
    expect(controller.selectedDateTime.month, 12);
    expect(controller.selectedDateTime.year, 2021);
  });

  test('adds one month from last of january', () {
    final int selectedTimestamp =
        DateTime.utc(2022, 1, 31, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
    final DateTimePickerModel model =
        DateTimePickerModel(initialTimestamp: selectedTimestamp);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    controller.nextMonth();
    expect(controller.selectedDateTime.hour, 0);
    expect(controller.selectedDateTime.day, 28);
    expect(controller.selectedDateTime.month, 2);
    expect(controller.selectedDateTime.year, 2022);
  });
}
