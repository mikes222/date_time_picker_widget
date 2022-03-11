import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/view/date_time_view.dart';
import 'package:date_time_picker_widget/src/view/day_picker_view.dart';
import 'package:date_time_picker_widget/src/view/month_picker_view.dart';
import 'package:date_time_picker_widget/src/view/weekday_view.dart';
import 'package:flutter/cupertino.dart';

class DatePicker extends StatefulWidget {
  final DateTimePickerModel model;

  DatePicker({required this.model});

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

/////////////////////////////////////////////////////////////////////////////

class _DatePickerState extends State {
  late final DateTimePickerController _controller;

  @override
  DatePicker get widget => super.widget as DatePicker;

  @override
  void initState() {
    super.initState();
    _controller = DateTimePickerController(model: widget.model);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          DateTimeView(model: widget.model, controller: _controller),
          const SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  widget.model.viewConverter.pickADateText(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              MonthPickerView(model: widget.model, controller: _controller),
            ],
          ),
          WeekdayView(model: widget.model, controller: _controller),
          DayPickerView(model: widget.model, controller: _controller),
        ],
      );
    });
  }
}
