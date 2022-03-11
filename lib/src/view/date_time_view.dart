import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:date_time_picker_widget/src/date_time_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeView extends StatelessWidget {
  final DateTimePickerModel model;

  final DateTimePickerController controller;

  const DateTimeView({required this.model, required this.controller});

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
                model.viewConverter.dateToView(selectedTimestamp.timestamp),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(width: 16),
              Text(
                model.viewConverter.timeToView(selectedTimestamp.timestamp),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          );
        });
  }
}
