import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:flutter/material.dart';

class TimeView extends StatelessWidget {
  final DateTimePickerModel model;

  final DateTimePickerController controller;

  const TimeView({required this.model, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectedTimestamp>(
        stream: controller.selectedTimestampObserve,
        builder: (context, AsyncSnapshot<SelectedTimestamp> snapshot) {
          if (snapshot.data == null) return const SizedBox();
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SizedBox();

          SelectedTimestamp selectedTimestamp = snapshot.data!;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.viewConverter.timeToView(selectedTimestamp.dateTime),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        });
  }
}
