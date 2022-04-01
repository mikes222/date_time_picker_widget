import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:date_time_picker_widget/src/model/date_time_picker_model.dart';
import 'package:date_time_picker_widget/src/view/date_time_view.dart';
import 'package:date_time_picker_widget/src/view/time_picker_view.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatefulWidget {
  final DateTimePickerModel model;

  TimePicker({required this.model});

  @override
  State<StatefulWidget> createState() {
    return _TimePickerState();
  }
}

/////////////////////////////////////////////////////////////////////////////

class _TimePickerState extends State {
  late final DateTimePickerController _controller;

  @override
  TimePicker get widget => super.widget as TimePicker;

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
          TimePickerView(model: widget.model, controller: _controller),
          StreamBuilder<SelectedTimestamp>(
              stream: _controller.selectedTimestampObserve,
              builder: (context, AsyncSnapshot<SelectedTimestamp> snapshot) {
                if (snapshot.data == null) return const SizedBox();
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const SizedBox();
                if (widget.model.onDateTimeChanged != null)
                  widget.model.onDateTimeChanged!(snapshot.data!.dateTime);
                return const SizedBox();
              }),
        ],
      );
    });
  }
}
