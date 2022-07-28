import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tests the rounding in the model', () {
    DateTime selectedDateTime = DateTime.utc(2022, 3, 1, 0, 0, 0, 0, 0);
    DateTime minDateTime = DateTime.utc(2022, 4, 1, 0, 0, 0, 0, 0);
    final DateTimePickerModel model = DateTimePickerModel(
        initialDateTime: selectedDateTime, minDateTime: minDateTime);

    DateTime rounded = model.roundMinMaxDateTime(selectedDateTime);
    expect(rounded, DateTime.utc(2022, 4, 1, 0, 0, 0, 0, 0));

    minDateTime.add(Duration(days: 5));
    expect(rounded, DateTime.utc(2022, 4, 1, 0, 0, 0, 0, 0));

    selectedDateTime.add(Duration(days: 7));
    expect(rounded, DateTime.utc(2022, 4, 1, 0, 0, 0, 0, 0));
  });
}
