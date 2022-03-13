import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/view/month_picker_view.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testhelper.dart';

///
/// flutter test --update-goldens
///
void main() {
  testWidgets('adds one to input values', (WidgetTester tester) async {
    final DateTime selectedDateTime =
        DateTime.utc(2022, 3, 1, 0, 0, 0, 0, 0);
    final DateTimePickerModel model =
        DateTimePickerModel(initialDateTime: selectedDateTime);
    final DateTimePickerController controller =
        DateTimePickerController(model: model);
    await tester.pumpWidget(await TestHelper.makeTestableWidget(
      child: MonthPickerView(model: model, controller: controller),
    ));
    await tester.pumpAndSettle();
    await expectLater(
        find.byType(MonthPickerView), matchesGoldenFile('monthpicker.png'));
    //   expect(calculator.addOne(2), 3);
    //   expect(calculator.addOne(-7), -6);
    //   expect(calculator.addOne(0), 1);
    //   expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });
}
