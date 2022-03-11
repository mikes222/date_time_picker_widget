import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/view/date_time_view.dart';
import 'package:date_time_picker_widget/src/view/day_picker_view.dart';
import 'package:date_time_picker_widget/src/view/month_picker_view.dart';
import 'package:date_time_picker_widget/src/view/time_picker_view.dart';
import 'package:date_time_picker_widget/src/view/weekday_view.dart';
import 'package:flutter/cupertino.dart';

class DateTimePicker extends StatefulWidget {
  final DateTimePickerModel model;

  const DateTimePicker({required this.model});

  @override
  State<StatefulWidget> createState() {
    return _DateTimePickerState();
  }
}

/////////////////////////////////////////////////////////////////////////////

class _DateTimePickerState extends State {
  late final DateTimePickerController _controller;

  @override
  DateTimePicker get widget => super.widget as DateTimePicker;

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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  widget.model.viewConverter.pickATimeText(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          TimePickerView(model: widget.model, controller: _controller),
          StreamBuilder<SelectedTimestamp>(
              stream: _controller.selectedTimestampObserve,
              builder: (context, AsyncSnapshot<SelectedTimestamp> snapshot) {
                if (snapshot.data == null) return const SizedBox();
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const SizedBox();
                if (widget.model.onDateTimeChanged != null)
                  widget.model.onDateTimeChanged!(snapshot.data!.timestamp);
                return const SizedBox();
              }),
        ],
      );
    });
  }
}
