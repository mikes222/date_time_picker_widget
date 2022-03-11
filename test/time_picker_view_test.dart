import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/view/time_picker_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testhelper.dart';

///
/// flutter test --update-goldens
///
void main() {
  testWidgets('Shows the timepicker', (WidgetTester tester) async {
    final int selectedTimestamp =
        DateTime.utc(2022, 3, 10, 1, 30, 0, 0, 0).millisecondsSinceEpoch;
    final DateTimePickerModel model = DateTimePickerModel(
        initialTimestamp: selectedTimestamp, timeInterval: 15 * 60 * 1000);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    await tester.pumpWidget(await TestHelper.makeTestableWidget(
      child: LayoutBuilder(builder: (context, constraints) {
        return TimePickerView(model: model, controller: controller);
      }),
    ));
    await tester.pumpAndSettle();
    await expectLater(
        find.byType(TimePickerView), matchesGoldenFile('timepicker.png'));
    //   expect(calculator.addOne(2), 3);
    //   expect(calculator.addOne(-7), -6);
    //   expect(calculator.addOne(0), 1);
    //   expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });
}
